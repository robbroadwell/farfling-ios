import SwiftUI
import MapKit
import UIKit

struct ContentView: View {
    let darkMode: Bool = true
    let borderColorDark: Color = Color(hex: "#000000")
    let borderColorLight: Color = Color(hex: "#FFFFFF")
    var borderColor: Color {
        darkMode ? borderColorDark : borderColorLight
    }
    
    let hitAreaWidth: CGFloat = 40
    let maxPanelWidthPercentage: CGFloat = 0.45
    let borderSize: CGFloat = 8
    let headerSize: CGFloat = 0
    
    @State private var leftInset: CGFloat = 0
    @State private var startLeftInset: CGFloat = 0
    @State private var rightInset: CGFloat = 0
    @State private var startRightInset: CGFloat = 0
    @State private var animatePulse = false
    @State private var isMapMoving = false
    @State private var showBottomDrawer = true
    @State private var mapPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50)
    ))
    @State private var bottomInset: CGFloat = 0
    @State private var startBottomInset: CGFloat = 0
    
    var body: some View {
        ZStack {
            map
            overlay
        }
    }
    
    var map: some View {
        Map(position: $mapPosition) {
            Annotation("UserLocation", coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.3))
                        .frame(width: 40, height: 40)
                        .scaleEffect(animatePulse ? 1.4 : 1)
                        .animation(Animation.easeOut(duration: 1).repeatForever(autoreverses: true), value: animatePulse)
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 15, height: 15)
                }
                .onAppear {
                    animatePulse = true
                }
            }
        }
        .onMapCameraChange(frequency: .continuous) {
            isMapMoving = true
            withAnimation(.easeInOut(duration: 0.3)) {
                showBottomDrawer = false
            }
        }
        .onMapCameraChange(frequency: .onEnd) {
            isMapMoving = false
            withAnimation(.easeInOut(duration: 0.3)) {
                showBottomDrawer = true
            }
        }
        .ignoresSafeArea()
        .padding(.horizontal, borderSize)
    }
    
    var overlay: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let holeRect = CGRect(
                x: borderSize + leftInset,
                y: borderSize + headerSize,
                width: width - borderSize * 2 - leftInset - rightInset,
                height: height - borderSize * 2 - headerSize
            )
            let holePath = Path(roundedRect: holeRect, cornerRadius: 47.28)
            
            ZStack {
                HStack {
                    Spacer()
                    Button(action: {
                        // Handle login action
                        triggerHaptic()
                    }) {
                        Text("Log in")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "#1A2D51")) // Dark blue text
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(Color(hex: "#FAF6EB")) // Off-white background
                            .clipShape(Capsule())
                    }
                }
                .padding(.trailing, 30)
                
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 140)
                    .padding(.top, 5)
            }
            .frame(height: headerSize)
            .frame(maxWidth: .infinity, alignment: .top)
            .padding(.top, 60)
            
            
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color(hex: "#C19A6B"))
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                Capsule()
                    .fill(Color.white)
                    .frame(width: 40, height: 6)
                    .padding(.top, 8)
            }
            .offset(y: showBottomDrawer ? 0 : 100)
            .animation(.easeInOut(duration: 0.3), value: showBottomDrawer)
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 15)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation == .zero {
                            startBottomInset = bottomInset
                        }
                        let proposed = max(0, min(geometry.size.height * 0.5, startBottomInset - value.translation.height))
                        bottomInset = proposed
                    }
                    .onEnded { value in
                        withAnimation {
                            let thresholds: [CGFloat] = [0, geometry.size.height * 0.5]
                            let closest = thresholds.min(by: {
                                abs(bottomInset - $0) < abs(bottomInset - $1)
                            }) ?? 0
                            bottomInset = closest
                            startBottomInset = 0
                            if closest == 0 || closest == geometry.size.height * 0.5 {
                                triggerHaptic()
                            }
                        }
                    }
                )
            
            Button(action: {
                withAnimation {
                    leftInset = geometry.size.width * maxPanelWidthPercentage
                }
            }) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "figure.run")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.black)

                    Text("1")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.red)
                        .clipShape(Circle())
                        .offset(x: 10, y: -10)
                }
                .padding()
                .background(Color.white)
                .clipShape(Circle())
                .shadow(radius: 10)
            }
            .position(x: 60, y: geometry.size.height - 65)

            Button(action: {
                withAnimation {
                    rightInset = geometry.size.width * maxPanelWidthPercentage
                }
            }) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.black)

                    Text("1")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.red)
                        .clipShape(Circle())
                        .offset(x: 10, y: -10)
                }
                .padding()
                .background(Color.white)
                .clipShape(Circle())
                .shadow(radius: 10)
            }
            .position(x: geometry.size.width - 60, y: geometry.size.height - 65)

            Canvas { context, size in
                context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(borderColor))
                context.blendMode = .destinationOut
                context.fill(holePath, with: .color(.black))
            }
            .compositingGroup()
            .ignoresSafeArea()
            .allowsHitTesting(false)

            Rectangle()
                .fill(Color.clear)
                .frame(width: hitAreaWidth + leftInset)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation == .zero {
                                startLeftInset = leftInset
                            }
                            let proposed = max(0, min(geometry.size.width * 0.5, startLeftInset + value.translation.width))
                            leftInset = proposed
                        }
                        .onEnded { value in
                            withAnimation {
                                let thresholds: [CGFloat] = [0, maxPanelWidthPercentage]
                                let closest = thresholds.min(by: { abs(leftInset - geometry.size.width * $0) < abs(leftInset - geometry.size.width * $1) }) ?? 0
                                leftInset = geometry.size.width * closest
                                startLeftInset = 0 // reset after snap
                                if closest == 0 || closest == maxPanelWidthPercentage {
                                    triggerHaptic()
                                }
                            }
                        }
                )
                .frame(maxHeight: .infinity)
                .position(x: 0, y: geometry.size.height / 2)
            
            Rectangle()
                .fill(Color.clear)
                .frame(width: hitAreaWidth + rightInset)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation == .zero {
                                startRightInset = rightInset
                            }
                            let proposed = max(0, min(geometry.size.width * 0.5, startRightInset - value.translation.width))
                            rightInset = proposed
                        }
                        .onEnded { value in
                            withAnimation {
                                let thresholds: [CGFloat] = [0, maxPanelWidthPercentage]
                                let closest = thresholds.min(by: {
                                    abs(rightInset - geometry.size.width * $0) < abs(rightInset - geometry.size.width * $1)
                                }) ?? 0
                                rightInset = geometry.size.width * closest
                                startRightInset = 0
                                if closest == 0 || closest == maxPanelWidthPercentage {
                                    triggerHaptic()
                                }
                            }
                        }
                )
                .frame(maxHeight: .infinity)
                .position(x: geometry.size.width, y: geometry.size.height / 2)
            
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        
        self.init(red: r, green: g, blue: b)
    }
}

extension ContentView {
    func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
}

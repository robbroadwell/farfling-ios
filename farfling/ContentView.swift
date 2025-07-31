import SwiftUI
import MapKit

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
    
    var body: some View {
        ZStack {
            map
            overlay
        }
    }
    
    
    var map: some View {
        Map(initialPosition: .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50)
        ))) {
            UserAnnotation()
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

            Canvas { context, size in
                context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(borderColor))
                context.blendMode = .destinationOut
                context.fill(holePath, with: .color(.black))
            }
            .compositingGroup()
            .ignoresSafeArea()
            .allowsHitTesting(false)
            
            ZStack {
                HStack {
                    Spacer()
                    Button(action: {
                        // Handle login action
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
                .padding(.trailing, 20)

                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 130)
            }
            .frame(height: headerSize)
            .frame(maxWidth: .infinity, alignment: .top)
            .padding(.top, 60)

            Button(action: {
                withAnimation {
                    leftInset = geometry.size.width * maxPanelWidthPercentage
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
            .position(x: 60, y: geometry.size.height - 65)

            Button(action: {
                withAnimation {
                    rightInset = geometry.size.width * maxPanelWidthPercentage
                }
            }) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "person.circle")
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

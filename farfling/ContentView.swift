import SwiftUI
import MapKit
import UIKit

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    var darkMode: Bool {
        colorScheme == .dark
    }
    let borderColorDark: Color = Color(hex: "#000000")
    let borderColorLight: Color = Color(hex: "#FFFFFF")
    var borderColor: Color {
        darkMode ? borderColorDark : borderColorLight
    }
    
    let hitAreaWidth: CGFloat = 40
    let maxPanelWidthPercentage: CGFloat = 0.47
    let overshootFactor: CGFloat = 1.15
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
    @State private var isDrawerFullyExpanded = false
    @State private var showTopSearchPanel = false
    
    var body: some View {
        ZStack {
            HStack(alignment: .top, spacing: 0) {
                // Left panel
                VStack(alignment: .leading, spacing: 12) {
                    ForEach([
                        ("figure.hiking", "Hiking"),
                        ("bicycle", "Cycling"),
                        ("skiing", "Skiing"),
                        ("kayak", "Kayaking"),
                        ("mountain.2", "Climbing"),
                        ("surfboard", "Surfing"),
                        ("sailboat", "Sailing"),
                        ("scuba.dive", "Diving")
                    ], id: \.1) { icon, label in
                        HStack {
                            Image(systemName: icon)
                                .frame(width: 15)
                            Text(label)
                                .font(.system(size: 12, weight: .bold))
                        }
                        .foregroundColor(Color(hex: "#0A2C46"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .frame(width: UIScreen.main.bounds.width * maxPanelWidthPercentage)
                        .background(Color.white)
                        .clipShape(Capsule())
                    }
                    Spacer()
                }
                .padding(.top, 60)
                .padding(.leading, 12)
                .frame(width: UIScreen.main.bounds.width * maxPanelWidthPercentage)

                Spacer()

                // Right panel
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Start date").font(.subheadline)
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            .frame(height: 40)
                            .overlay(
                                Text("Jul 6, 2024")
                                    .font(.system(size: 12, weight: .bold))
                            )
                        Text("End date").font(.subheadline)
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            .frame(height: 40)
                            .overlay(
                                Text("Jul 12, 2024")
                                    .font(.system(size: 12, weight: .bold))
                            )
                    }
                    .frame(width: UIScreen.main.bounds.width * maxPanelWidthPercentage)
                }
                .padding(20)
                .frame(width: UIScreen.main.bounds.width * maxPanelWidthPercentage)
            }
            .ignoresSafeArea()

            ZStack {
                map
                overlay
            }
            .ignoresSafeArea()
            .mask(
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let height = geometry.size.height

                    Path { path in
                        let holeRect = CGRect(
                            x: borderSize + leftInset,
                            y: borderSize + headerSize,
                            width: width - borderSize * 2 - leftInset - rightInset,
                            height: height - borderSize * 2 - headerSize
                        )
                        path.addRect(holeRect)
                    }
                }
                .ignoresSafeArea()
            )
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
    }
    
    var overlay: some View {
        GeometryReader { geometry in
            let iconColor = darkMode ? Color.white : Color.black
            let width = geometry.size.width
            let height = geometry.size.height
            let holeRect = CGRect(
                x: borderSize + leftInset,
                y: borderSize + headerSize,
                width: width - borderSize * 2 - leftInset - rightInset,
                height: height - borderSize * 2 - headerSize
            )
            let holePath = Path(roundedRect: holeRect, cornerRadius: 47.28)
            
            ZStack(alignment: .top) {
                VisualEffectBlur(blurStyle: .systemMaterial)
                    .frame(height: geometry.size.height * 1.5)
                    .frame(maxWidth: .infinity)
                Capsule()
                    .fill(Color.white)
                    .frame(width: 40, height: 6)
                    .padding(.top, 8)
            }
            .offset(y: showBottomDrawer ? 0 : 100)
            .animation(.easeInOut(duration: 0.3), value: showBottomDrawer)
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height + (geometry.size.height * 0.675) - bottomInset)
            .animation(.easeInOut(duration: 0.3), value: bottomInset)
            .onTapGesture {
                withAnimation {
                    if bottomInset == 0 {
                        bottomInset = geometry.size.height * 0.5
                        triggerHaptic()
                    } else if bottomInset == geometry.size.height * 0.5 {
                        bottomInset = geometry.size.height
                        isDrawerFullyExpanded = true
                        triggerHaptic()
                    }
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if startBottomInset == 0 {
                            startBottomInset = bottomInset
                        }
                        let proposed = max(0, min(geometry.size.height * 1.0, startBottomInset - value.translation.height))
                        bottomInset = proposed
                    }
                    .onEnded { value in
                        withAnimation {
                            let thresholds: [CGFloat] = [0, geometry.size.height * 0.5, geometry.size.height]
                            let closest = thresholds.min(by: {
                                abs(bottomInset - $0) < abs(bottomInset - $1)
                            }) ?? 0
                            bottomInset = closest
                            isDrawerFullyExpanded = closest == geometry.size.height
                            startBottomInset = 0
                            if closest == 0 || closest == geometry.size.height * 0.5 || isDrawerFullyExpanded {
                                triggerHaptic()
                            }
                        }
                    }
            )
            
            if isDrawerFullyExpanded {
                Button(action: {
                    withAnimation {
                        bottomInset = 0
                        isDrawerFullyExpanded = false
                        triggerHaptic()
                    }
                }) {
                    Text("Map")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.black.opacity(0.8))
                        .clipShape(Capsule())
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height - 60)
            }
            
            // Moved and refactored the left button into the HStack above
            
            ZStack {
                VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                    .edgesIgnoringSafeArea(.top)
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                leftInset = geometry.size.width * maxPanelWidthPercentage
                            }
                        }) {
                            ZStack {
                                Image(systemName: "bell")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 25)
                                    .foregroundColor(iconColor)
                                VStack {
                                    HStack {
                                        Spacer()
                                        Text("1")
                                            .font(.caption2)
                                            .foregroundColor(.white)
                                            .padding(6)
                                            .background(Color.red)
                                            .clipShape(Circle())
                                            .offset(x: 6, y: -6)
                                    }
                                    Spacer()
                                }
                            }
                            .frame(width: 30, height: 30)
                        }
                        Spacer()
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                if showTopSearchPanel {
                                    showTopSearchPanel = false
                                    showBottomDrawer = true
                                } else {
                                    showTopSearchPanel = true
                                    showBottomDrawer = false
                                }
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 25)
                                .foregroundColor(iconColor)
                        }
                        Spacer()
                        Image("Logo")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
                            .padding(.top, 5)
                            .foregroundColor(iconColor)
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "slider.horizontal.3")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 25)
                                .foregroundColor(iconColor)
                        }
                        Spacer()
                        Button(action: {
                            withAnimation {
                                rightInset = geometry.size.width * maxPanelWidthPercentage
                            }
                        }) {
                            ZStack {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 25)
                                    .foregroundColor(iconColor)
                                VStack {
                                    HStack {
                                        Spacer()
                                        Text("1")
                                            .font(.caption2)
                                            .foregroundColor(.white)
                                            .padding(6)
                                            .background(Color.red)
                                            .clipShape(Circle())
                                            .offset(x: 6, y: -6)
                                    }
                                    Spacer()
                                }
                            }
                            .frame(width: 30, height: 30)
                        }
                        Spacer()
                    }
                    Rectangle()
                        .fill(Color.white.opacity(0.5))
                        .frame(height: 2)
                        .frame(maxWidth: .infinity)
//                        .shadow(radius: 3)
                }
            }
            .frame(height: headerSize)
            .frame(maxWidth: .infinity, alignment: .top)
            .padding(.top, 65)

            // Top sliding search panel
            if showTopSearchPanel {
                VStack(spacing: 0) {
                    Color.clear
                        .frame(height: 85)
                    VisualEffectBlur(blurStyle: .systemMaterial)
                        .frame(maxWidth: .infinity)
                        .frame(height: geometry.size.height * 0.825)
                        .transition(.asymmetric(
                            insertion: .move(edge: .top).combined(with: .opacity),
                            removal: .move(edge: .top).combined(with: .opacity)
                        ))
                        .overlay(
                            VStack {
                                Spacer()
                                Capsule()
                                    .fill(Color.secondary)
                                    .frame(width: 40, height: 6)
                                    .padding(.bottom, 12)
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            showTopSearchPanel = false
                                            showBottomDrawer = true
                                        }
                                    }
                            }
                        )
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    if value.translation.height > 50 {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            showTopSearchPanel = false
                                            showBottomDrawer = true
                                        }
                                    }
                                }
                        )
                }
                .zIndex(2)
            }

            

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
                            let maxDrag = geometry.size.width * maxPanelWidthPercentage * overshootFactor
                            let proposed = max(0, min(maxDrag, startLeftInset + value.translation.width))
                            leftInset = proposed
                        }
                        .onEnded { value in
                            withAnimation(.spring()) {
                                // Snap only to 0 or geometry.size.width * maxPanelWidthPercentage
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

struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
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

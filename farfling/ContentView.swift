import SwiftUI
import MapKit
import UIKit

enum BottomTab: String {
    case activities, filters, dates, results, settings
}

struct ContentView: View {
    let tabIconSize: CGFloat = 22
    @Environment(\.colorScheme) private var colorScheme
    var darkMode: Bool {
        colorScheme == .dark
    }
    let borderColorDark: Color = Color(hex: "#FFFFFF")
    let borderColorLight: Color = Color(hex: "#000000")
    var borderColor: Color {
        darkMode ? borderColorDark : borderColorLight
    }
    
    let holeRadius: CGFloat = 0 // 47.28
    let hitAreaWidth: CGFloat = 60
    let maxPanelWidthPercentage: CGFloat = 0.5
    let borderSize: CGFloat = 0
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
    
    let topPanelHeightOffset: CGFloat = 88
    @State private var showTopSearchPanel = false
    @State private var showLogoPanel = false
    @State private var showFiltersPanel = false
    @State private var activeBottomTab: BottomTab? = nil
    
    var panels: some View {
        ZStack {
            Group {
                if rightInset == 0 {
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
                }
            }
            .transaction { $0.animation = nil }

            Group {
                if leftInset == 0 {
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
                }
            }
            .transaction { $0.animation = nil }
        }
    }
    
    
    
    var body: some View {
        ZStack {
            panels

            ZStack {
                map
                    .allowsHitTesting(!(showTopSearchPanel || showLogoPanel || showFiltersPanel))
                overlay
            }
            .ignoresSafeArea()
            .mask(
                AnimatedHoleMask(leftInset: leftInset, rightInset: rightInset)
                    .fill(Color.black)
                    .animation(.easeInOut(duration: 0.3), value: leftInset)
                    .animation(.easeInOut(duration: 0.3), value: rightInset)
            )
            
            // Header ZStack moved out of overlay, now here above the map/overlay ZStack
            VStack {
                ZStack {
                    VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                        .edgesIgnoringSafeArea(.top)
                    VStack {
                        HStack {
                            Button(action: {
                                withAnimation {
                                    leftInset = UIScreen.main.bounds.width * maxPanelWidthPercentage
                                }
                            }) {
                                ZStack {
                                    Image(systemName: "bell")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 25)
                                        .foregroundColor(darkMode ? Color.white : Color.black)
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
//                            Button(action: {
//                                withAnimation(.easeInOut(duration: 0.3)) {
//                                    let willOpen = !showTopSearchPanel
//                                    showTopSearchPanel = willOpen
//                                    showLogoPanel = false
//                                    showFiltersPanel = false
//                                    showBottomDrawer = !willOpen
//                                }
//                            }) {
//                                Image(systemName: "person.crop.circle")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(height: 25)
//                                    .foregroundColor(darkMode ? Color.white : Color.black)
//                            }
                            Spacer()
                            Image("Logo")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 40)
                                .foregroundColor(darkMode ? Color.white : Color.black)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        let willOpen = !showLogoPanel
                                        showLogoPanel = willOpen
                                        showFiltersPanel = false
                                        showTopSearchPanel = false
                                        showBottomDrawer = !(willOpen)
                                    }
                                }
                            Spacer()
//                            Button(action: {
//                                withAnimation(.easeInOut(duration: 0.3)) {
//                                    let willOpen = !showFiltersPanel
//                                    showFiltersPanel = willOpen
//                                    showLogoPanel = false
//                                    showTopSearchPanel = false
//                                    showBottomDrawer = !(willOpen)
//                                }
//                            }) {
//                                Image(systemName: "magnifyingglass")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(height: 25)
//                                    .foregroundColor(darkMode ? Color.white : Color.black)
//                            }
                            Button(action: {
                                withAnimation {
                                    rightInset = UIScreen.main.bounds.width * maxPanelWidthPercentage
                                }
                            }) {
                                ZStack {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 25)
                                        .foregroundColor(darkMode ? Color.white : Color.black)
//                                    VStack {
//                                        HStack {
//                                            Spacer()
//                                            Text("1")
//                                                .font(.caption2)
//                                                .foregroundColor(.white)
//                                                .padding(6)
//                                                .background(Color.red)
//                                                .clipShape(Circle())
//                                                .offset(x: 6, y: -6)
//                                        }
//                                        Spacer()
//                                    }
                                }
                                .frame(width: 30, height: 30)
                            }
                        }
                            .padding(.horizontal)
                        
                        Rectangle()
                            .fill(borderColor)
                            .frame(height: 2)
                            .frame(maxWidth: .infinity)
                        //                        .shadow(radius: 3)
                    }
                    .padding(.top, 40)
                }
                .frame(height: headerSize)
                .frame(maxWidth: .infinity, alignment: .top)
                
                Spacer()
            }
            .padding(.top, 50)
        }
        .ignoresSafeArea()
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
            let holePath = Path(roundedRect: holeRect, cornerRadius: holeRadius)

            ZStack(alignment: .top) {
                VisualEffectBlur(blurStyle: .systemMaterial)
                    .frame(height: geometry.size.height * 1.5)
                    .frame(maxWidth: .infinity)
                Capsule()
                    .fill(borderColor)
                    .frame(width: 40, height: 6)
                    .padding(.top, 8)
                Rectangle()
                    .fill(borderColor)
                    .frame(height: 2)
                    .frame(maxWidth: .infinity)
            }
            .offset(y: showBottomDrawer ? 0 : 140)
            .animation(.easeInOut(duration: 0.3), value: showBottomDrawer)
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height + (geometry.size.height * 0.60) - bottomInset)
            .animation(.easeInOut(duration: 0.3), value: leftInset)
            .animation(.easeInOut(duration: 0.3), value: rightInset)
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
                .position(x: geometry.size.width / 2, y: geometry.size.height - 130)
            }

            if showTopSearchPanel {
                VStack(spacing: 0) {
                    Color.clear
                        .frame(height: topPanelHeightOffset)
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

            // Logo dropdown panel
            if showLogoPanel {
                VStack(spacing: 0) {
                    Color.clear
                        .frame(height: topPanelHeightOffset)
                    VisualEffectBlur(blurStyle: .systemChromeMaterialDark)
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
                                            showLogoPanel = false
                                            showBottomDrawer = true
                                        }
                                    }
                            }
                        )
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    if value.translation.height < -50 {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            showLogoPanel = false
                                            showBottomDrawer = true
                                        }
                                    }
                                }
                        )
                }
                .zIndex(2)
            }

            // Filters dropdown panel
            if showFiltersPanel {
                VStack(spacing: 0) {
                    Color.clear
                        .frame(height: topPanelHeightOffset)
                    VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
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
                                            showFiltersPanel = false
                                            showBottomDrawer = true
                                        }
                                    }
                            }
                        )
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    if value.translation.height < -50 {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            showFiltersPanel = false
                                            showBottomDrawer = true
                                        }
                                    }
                                }
                        )
                }
                .zIndex(2)
            }

            // Begin overlay dimming and blur
            let maxInset = geometry.size.width * maxPanelWidthPercentage
            let dimmingOpacity = max(leftInset, rightInset) / maxInset

            
            
            // --- Begin Custom Bottom Tab Bar ---
            VStack {
                Spacer()
                ZStack {
                    VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                        .frame(height: 90)
                        .background(Color.clear)
                        .overlay(
                            HStack {
                                Spacer()
                                // Results tab (now styled like others, with "house" icon)
                                ZStack {
                                    if activeBottomTab == .results {
                                        Color.white
                                            .cornerRadius(12)
                                    } else {
                                        Color.clear
                                    }
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: tabIconSize, weight: .bold))
                                        .foregroundColor(activeBottomTab == .results ? .black : (darkMode ? .white : .black))
                                }
                                .frame(width: 70, height: 70)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation {
                                        activeBottomTab = (activeBottomTab == .results) ? nil : .results
                                    }
                                }
                                Spacer()
                                // Activities
                                ZStack {
                                    if activeBottomTab == .activities {
                                        Color.white
                                            .cornerRadius(12)
                                    } else {
                                        Color.clear
                                    }
                                    Image(systemName: "calendar")
                                        .font(.system(size: tabIconSize, weight: .bold))
                                        .foregroundColor(activeBottomTab == .activities ? .black : (darkMode ? .white : .black))
                                        .frame(maxWidth: .infinity)
                                }
                                .frame(width: 70, height: 70)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    activeBottomTab = (activeBottomTab == .activities) ? nil : .activities
                                }
                                Spacer()
//                                // Filters
//                                ZStack {
//                                    if activeBottomTab == .filters {
//                                        Color.white
//                                            .cornerRadius(12)
//                                    } else {
//                                        Color.clear
//                                    }
//                                    Group {
//                                        if isMapMoving {
//                                            ProgressView()
//                                                .progressViewStyle(CircularProgressViewStyle(tint: activeBottomTab == .filters ? .black : .white))
//                                                .scaleEffect(0.8)
//                                        } else {
//                                            ZStack {
//                                                Circle()
//                                                    .fill(activeBottomTab == .filters ? Color.white : Color.white.opacity(0.2))
//                                                    .frame(width: 52, height: 52)
//                                                Text("\(Int.random(in: 1...10))")
//                                                    .font(.system(size: 16, weight: .bold))
//                                                    .foregroundColor(activeBottomTab == .filters ? .black : .white)
//                                            }
//                                        }
//                                    }
//                                    .frame(maxWidth: .infinity)
//                                }
//                                .frame(width: 70, height: 70)
//                                .contentShape(Rectangle())
//                                .onTapGesture {
//                                    activeBottomTab = (activeBottomTab == .filters) ? nil : .filters
//                                }
//                                Spacer()
                                // Dates
                                ZStack {
                                    if activeBottomTab == .dates {
                                        Color.white
                                            .cornerRadius(12)
                                    } else {
                                        Color.clear
                                    }
                                    Image(systemName: "slider.horizontal.3")
                                        .font(.system(size: tabIconSize, weight: .bold))
                                        .foregroundColor(activeBottomTab == .dates ? .black : (darkMode ? .white : .black))
                                        .frame(maxWidth: .infinity)
                                }
                                .frame(width: 70, height: 70)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    activeBottomTab = (activeBottomTab == .dates) ? nil : .dates
                                }
                                Spacer()
                                // Settings
                                ZStack {
                                    if activeBottomTab == .settings {
                                        Color.white
                                            .cornerRadius(12)
                                    } else {
                                        Color.clear
                                    }
                                    Image(systemName: "plus")
                                        .font(.system(size: tabIconSize, weight: .bold))
                                        .foregroundColor(activeBottomTab == .settings ? .black : (darkMode ? .white : .black))
                                        .frame(maxWidth: .infinity)
                                }
                                .frame(width: 70, height: 70)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    activeBottomTab = (activeBottomTab == .settings) ? nil : .settings
                                }
                                Spacer()
                            }
                            .padding(.bottom, 20)
                        )
                }
                .frame(height: 90)
                .ignoresSafeArea(edges: .bottom)
            }
            .ignoresSafeArea(.keyboard)
            // --- End Custom Bottom Tab Bar ---
            
            ZStack {
                Color.black.opacity(0.8 * dimmingOpacity)
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            leftInset = 0
                            rightInset = 0
                        }
                    }
            }
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.3), value: dimmingOpacity)
            .allowsHitTesting(leftInset > 0 || rightInset > 0)
            // End overlay dimming and blur
            
            
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
                            let maxDrag = geometry.size.width * maxPanelWidthPercentage
                            let proposed = max(0, min(maxDrag, startLeftInset + value.translation.width))
                            leftInset = proposed

                            // If right drawer is open, directly reduce it by the same amount
                            if rightInset > 0 {
                                let remaining = max(0, geometry.size.width * maxPanelWidthPercentage - proposed)
                                rightInset = remaining
                            }
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
                            let maxDrag = geometry.size.width * maxPanelWidthPercentage
                            let proposed = max(0, min(maxDrag, startRightInset + (-value.translation.width)))
                            rightInset = proposed

                            // If left drawer is open, directly reduce it by the same amount
                            if leftInset > 0 {
                                let remaining = max(0, geometry.size.width * maxPanelWidthPercentage - proposed)
                                leftInset = remaining
                            }
                        }
                        .onEnded { value in
                            withAnimation(.spring()) {
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

import SwiftUI

struct AnimatedHoleMask: Shape {
    var leftInset: CGFloat
    var rightInset: CGFloat

    // Flat animatable pair — safe and clean
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(leftInset, rightInset) }
        set {
            leftInset = newValue.first
            rightInset = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        let holeRect = CGRect(
            x: leftInset,
            y: 0,
            width: rect.width - leftInset - rightInset,
            height: rect.height
        )

        var path = Path()
        path.addRoundedRect(in: holeRect, cornerSize: CGSize(width: 20, height: 20))
        return path
    }
}

import SwiftUI
import MapKit

struct ContentView: View {
    let darkMode: Bool = true
    let borderColorDark: Color = Color(hex: "#000000")
    let borderColorLight: Color = Color(hex: "#FFFFFF")
    var borderColor: Color {
        darkMode ? borderColorDark : borderColorLight
    }
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

                    Text("Farfling")
                        .font(.headline)
                        .bold()

                    Spacer()

                }
                .frame(height: headerSize)
                
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .padding(.top, 30)

            Rectangle()
                .fill(Color.clear)
                .frame(width: 28 + leftInset)
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
                .frame(width: 28 + rightInset)
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

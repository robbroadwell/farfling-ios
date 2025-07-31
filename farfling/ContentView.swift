import SwiftUI
import MapKit

struct ContentView: View {
    let darkMode: Bool = false
    let borderColorDark: Color = Color(hex: "#000000")
    let borderColorLight: Color = Color(hex: "#FFFFFF")
    var borderColor: Color {
        darkMode ? borderColorDark : borderColorLight
    }
    let borderSize: CGFloat = 14
    let headerSize: CGFloat = 80
    @State private var leftInset: CGFloat = 0
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
                width: width - borderSize * 2 - leftInset,
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
            
            Rectangle()
                .fill(Color.clear)
                .frame(width: 30)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let proposedInset = min(max(0, value.translation.width), geometry.size.width * 0.75)
                            leftInset = proposedInset
                        }
                        .onEnded { value in
                            withAnimation {
                                if value.translation.width > geometry.size.width * 0.125 {
                                    leftInset = geometry.size.width * 0.25
                                } else {
                                    leftInset = 0
                                }
                            }
                        }
                )
                .frame(maxHeight: .infinity)
                .position(x: 15, y: geometry.size.height / 2)
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

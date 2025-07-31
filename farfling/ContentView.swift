import SwiftUI
import MapKit

struct ContentView: View {
    let borderSize: CGFloat = 30
    var body: some View {
        ZStack {
            Color(hex: "#153968")
                .ignoresSafeArea()

            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                let holeRect = CGRect(
                    x: borderSize,
                    y: borderSize,
                    width: width - borderSize * 2,
                    height: height - borderSize * 2
                )
                let holePath = Path(roundedRect: holeRect, cornerRadius: 47.28)

                Canvas { context, size in
                    context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(Color.white.opacity(0.6)))
                    context.blendMode = .destinationOut
                    context.fill(holePath, with: .color(.black))
                }
                .compositingGroup()
                .ignoresSafeArea()
            }
            .ignoresSafeArea()
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

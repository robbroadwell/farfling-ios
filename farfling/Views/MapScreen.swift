import SwiftUI

struct MapScreen: View {
    @Binding var redOffsetX: CGFloat
    @Binding var yellowOffsetX: CGFloat
    @Binding var purpleOffsetX: CGFloat

    var percentageDrawerIsOpen: CGFloat {
        max(
            (screen.width - purpleOffsetX) / screen.width,
            (yellowOffsetX + screen.width) / screen.width
        )
    }

    var body: some View {
        ZStack {
            ZStack {
                Color.red
                    .ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Color.cyan
                            .frame(height: 65 + insets.top)
                            .ignoresSafeArea()
                        
                        Color.blue
                            .frame(height: 65)
                    }
                    
                    Spacer()
                }
                
                Color.black
                    .opacity(
                        percentageDrawerIsOpen * 0.7
                    )
                    .ignoresSafeArea()
            }
        }
        .offset(x: redOffsetX)
    }
}

#Preview {
    StatefulPreviewWrapper3(0.0, -screen.width, screen.width) { red, yellow, purple in
        MapScreen(redOffsetX: red, yellowOffsetX: yellow, purpleOffsetX: purple)
    }
}

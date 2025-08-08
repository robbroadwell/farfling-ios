import SwiftUI

struct AccountScreen: View {
    @Binding var purpleOffsetX: CGFloat

    var body: some View {
        ZStack {
            Color.purple
                .mask(
                    RoundedRectangle(cornerRadius: 47.28, style: .continuous)
                )
                .ignoresSafeArea()

            // footer
            VStack {
                Spacer()
                
                ZStack {
                    Color.cyan
                        .frame(height: 65 + insets.bottom + 7)
                        .mask(
                            RoundedRectangle(cornerRadius: 47.28, style: .continuous)
                        )
                    
                    Color.blue
                        .frame(height: 65)
                        .padding(.bottom, insets.bottom + 7)
                }
            }
            .ignoresSafeArea()
        }
        .offset(x: purpleOffsetX)
    }
}
    
#Preview {
    StatefulPreviewWrapper(0.0) { binding in
        AccountScreen(purpleOffsetX: binding)
    }
}

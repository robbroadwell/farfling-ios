import SwiftUI

struct ChatScreen: View {
        @Binding var yellowOffsetX: CGFloat

        var body: some View {
            ZStack {
                Color.yellow
                    .mask(
                        RoundedRectangle(cornerRadius: 47.28, style: .continuous)
                    )
                    .ignoresSafeArea()
                
                HStack {
                    Color.gray
                        .frame(width: 75)
                        .padding(.leading, 5)
                    
                    Spacer()
                }
                .padding(.bottom, 42 + insets.bottom)
                
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
            .offset(x: yellowOffsetX)
        }
    }

#Preview {
    StatefulPreviewWrapper(0.0) { binding in
        ChatScreen(yellowOffsetX: binding)
    }
}

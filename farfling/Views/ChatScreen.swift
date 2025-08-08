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
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            ForEach(0..<15) { index in
                                ZStack(alignment: .bottom) {
                                    Color.gray
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(height: 1)
                                        .frame(maxWidth: .infinity)
                                        .alignmentGuide(.bottom) { d in d[.bottom] }
                                }
                                .frame(width: 75, height: 75)
                            }
                        }
                    }
                    .frame(width: 75)
                    .background(Color.clear)
                    .contentShape(Rectangle())
                    .animation(.spring(response: 0.5, dampingFraction: 0.75, blendDuration: 1), value: UUID())
                    Spacer()
                }
                .padding(.bottom, 38 + insets.bottom)
                
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

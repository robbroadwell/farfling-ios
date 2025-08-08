import SwiftUI

struct SwipeArea: View {
    @Binding var redOffsetX: CGFloat
    @Binding var yellowOffsetX: CGFloat
    @Binding var purpleOffsetX: CGFloat
    
    @Binding var isMapVisible: Bool
    @Binding var isYellowVisible: Bool
    @Binding var isPurpleVisible: Bool

    @State private var dragStartYellowOffsetX: CGFloat? = nil
    @State private var dragStartRedOffsetX: CGFloat? = nil
    @State private var dragStartPurpleOffsetX: CGFloat? = nil

    var body: some View {
        HStack {
            if !isYellowVisible {
                Color.green
                    .frame(width: 20)
            }
            
            Spacer()
            
            if !isPurpleVisible {
                Color.green
                    .frame(width: 20)
            }
        }
        .ignoresSafeArea()
        .gesture(
            DragGesture()
                .onChanged { value in
                    if dragStartYellowOffsetX == nil {
                        dragStartYellowOffsetX = yellowOffsetX
                    }
                    if dragStartRedOffsetX == nil {
                        dragStartRedOffsetX = redOffsetX
                    }
                    if dragStartPurpleOffsetX == nil {
                        dragStartPurpleOffsetX = purpleOffsetX
                    }
                    if let startOffset = dragStartRedOffsetX {
                        redOffsetX = startOffset + value.translation.width * 0.5
                    }
                    if let startOffset = dragStartYellowOffsetX {
                        if purpleOffsetX == screen.width {
                            yellowOffsetX = max(-screen.width, min(0, startOffset + value.translation.width))
                        }
                    }
                    if let startOffset = dragStartPurpleOffsetX {
                        if yellowOffsetX == -screen.width {
                            purpleOffsetX = min(screen.width, max(0, startOffset + value.translation.width))
                        }
                    }
                }
                .onEnded { value in
                    dragStartYellowOffsetX = nil
                    dragStartRedOffsetX = nil
                    dragStartPurpleOffsetX = nil

                    let predictedTranslation = value.predictedEndTranslation.width

                    withAnimation(.easeOut(duration: 0.3)) {
                        if yellowOffsetX > -screen.width + 1 {
                            if predictedTranslation < 0 {
                                yellowOffsetX = -screen.width
                                redOffsetX = 0.0
                                isMapVisible = true
                                isYellowVisible = false
                                isPurpleVisible = false
                                
                            } else {
                                yellowOffsetX = 0
                                redOffsetX = screen.width * 0.5
                                isMapVisible = false
                                isYellowVisible = true
                                isPurpleVisible = false
                            }
                        }

                        if purpleOffsetX < screen.width {
                            if predictedTranslation > 0 {
                                purpleOffsetX = screen.width
                                redOffsetX = 0.0
                                isMapVisible = true
                                isYellowVisible = false
                                isPurpleVisible = false
                                
                            } else {
                                purpleOffsetX = 0
                                redOffsetX = -screen.width * 0.5
                                isMapVisible = false
                                isYellowVisible = false
                                isPurpleVisible = true
                            }
                        }
                    }
                }
        )
    }
}

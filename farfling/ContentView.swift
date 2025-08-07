import SwiftUI

struct ContentView: View {
    @State private var isMapVisible: Bool = true
    @State private var redOffsetX: CGFloat = 0.0
    @State private var purpleOffsetX: CGFloat = UIScreen.main.bounds.width
    @State private var yellowOffsetX: CGFloat = -UIScreen.main.bounds.width
    @State private var dragStartYellowOffsetX: CGFloat? = nil
    @State private var dragStartRedOffsetX: CGFloat? = nil
    @State private var dragStartPurpleOffsetX: CGFloat? = nil
    
    var percentageDrawerIsOpen: CGFloat {
        max(
            (UIScreen.main.bounds.width - purpleOffsetX) / UIScreen.main.bounds.width,
            (yellowOffsetX + UIScreen.main.bounds.width) / UIScreen.main.bounds.width
        )
    }
    

    var body: some View {
        
        ZStack {
            
            // main screen
            ZStack {
                ZStack {
                    // map
                    Color.red
                        .ignoresSafeArea()
                    
                    // header
                    VStack {
                        Color.blue
                            .frame(height: 65)
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
            
            // chat screen
            ZStack {
                Color.purple
                    .mask(
                        RoundedRectangle(cornerRadius: 47.28, style: .continuous)
                    )
                    .ignoresSafeArea()

                // footer
                VStack {
                    Spacer()
                    Color.blue
                        .frame(height: 65)
                }
            }
            .offset(x: purpleOffsetX)
            
            
            
            // account screen
            ZStack {
                Color.yellow
                    .mask(
                        RoundedRectangle(cornerRadius: 47.28, style: .continuous)
                    )
                    .ignoresSafeArea()
                    
                
                // footer
                VStack {
                    Spacer()
                    Color.blue
                        .frame(height: 65)
                }
            }
            .offset(x: yellowOffsetX)
            
            
            
            // green swipe area
            HStack {
                if isMapVisible {
                    Color.green
                        .frame(width: 20)
                    
                    Spacer() // let the map be swipable
                    
                    Color.green
                        .frame(width: 20)
                } else {
                    Color.white.opacity(0.001)
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
                            if purpleOffsetX == UIScreen.main.bounds.width {
                                yellowOffsetX = max(-UIScreen.main.bounds.width, min(0, startOffset + value.translation.width))
                            }
                        }
                        if let startOffset = dragStartPurpleOffsetX {
                            if yellowOffsetX == -UIScreen.main.bounds.width {
                                purpleOffsetX = min(UIScreen.main.bounds.width, max(0, startOffset + value.translation.width))
                            }
                        }
                        
                        print("redOffsetX | \(redOffsetX)")
                        print("yellowOffsetX | \(yellowOffsetX)")
                        print("purpleOffsetX | \(purpleOffsetX)")
                        
                    }
                    .onEnded { value in
                        dragStartYellowOffsetX = nil
                        dragStartRedOffsetX = nil
                        dragStartPurpleOffsetX = nil
                                                
                        let predictedTranslation = value.predictedEndTranslation.width
                        let threshold: CGFloat = UIScreen.main.bounds.width / 2

                        withAnimation(.easeOut(duration: 0.3)) {
                            if yellowOffsetX > -UIScreen.main.bounds.width + 1 {
                                print("Yellow drawer is partially open")
                                if predictedTranslation < 0 {
                                    print("Swiping left - close yellow")
                                    yellowOffsetX = -UIScreen.main.bounds.width
                                    redOffsetX = 0.0
                                    isMapVisible = true
                                } else {
                                    print("Swiping right - open yellow")
                                    yellowOffsetX = 0
                                    redOffsetX = UIScreen.main.bounds.width * 0.5
                                    isMapVisible = false
                                }
                            }
                            
                            if purpleOffsetX < UIScreen.main.bounds.width {
                                if predictedTranslation > 0 {
                                    print("Swiping right - close purple")
                                    purpleOffsetX = UIScreen.main.bounds.width
                                    redOffsetX = 0.0
                                    isMapVisible = true
                                } else {
                                    print("Swiping left - open purple")
                                    purpleOffsetX = 0
                                    redOffsetX = -UIScreen.main.bounds.width * 0.5
                                    isMapVisible = false
                                }
                            }
                        }
                    }
            )
        }
        
    }
}

#Preview {
    ContentView()
}

import SwiftUI

struct ContentView: View {
    @State private var isMapVisible: Bool = true
    @State private var isYellowVisible: Bool = false
    @State private var isPurpleVisible: Bool = false
    @State private var redOffsetX: CGFloat = 0.0
    @State private var purpleOffsetX: CGFloat = screen.width
    @State private var yellowOffsetX: CGFloat = -screen.width
    @State private var dragStartYellowOffsetX: CGFloat? = nil
    @State private var dragStartRedOffsetX: CGFloat? = nil
    @State private var dragStartPurpleOffsetX: CGFloat? = nil
    
    var body: some View {
        ZStack {
            MapScreen(
                redOffsetX: $redOffsetX,
                yellowOffsetX: $yellowOffsetX,
                purpleOffsetX: $purpleOffsetX
            )
            
            AccountScreen(
                redOffsetX: $redOffsetX,
                purpleOffsetX: $purpleOffsetX,
                isMapVisible: $isMapVisible,
                isPurpleVisible: $isPurpleVisible
            )
            
            ChatScreen(
                redOffsetX: $redOffsetX,
                yellowOffsetX: $yellowOffsetX,
                isMapVisible: $isMapVisible,
                isYellowVisible: $isYellowVisible
            )

            SwipeArea(
                redOffsetX: $redOffsetX,
                yellowOffsetX: $yellowOffsetX,
                purpleOffsetX: $purpleOffsetX,
                isMapVisible: $isMapVisible,
                isYellowVisible: $isYellowVisible,
                isPurpleVisible: $isPurpleVisible
            )
        }
    }
}

#Preview {
    ContentView()
}

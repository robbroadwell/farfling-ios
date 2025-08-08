import SwiftUI

struct AccountScreen: View {
    enum Tab: Int, CaseIterable {
        case one = 0, two, three, four, five
    }
    @State private var selectedTab: Tab = .one
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
                    HStack(spacing: 0) {
                        ForEach(Tab.allCases, id: \.self) { tab in
                            (tab == selectedTab ? Color.white.opacity(0.2) : Color.clear)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(height: 65 + insets.bottom)
                    .background(Color.cyan)
                    .mask(
                        RoundedCorner(radius: 47.28, corners: [.bottomLeft, .bottomRight])
                    )

                    HStack {
                        ForEach(Tab.allCases, id: \.self) { tab in
                            Button(action: {
                                selectedTab = tab
                            }) {
                                VStack(spacing: 4) {
                                    Image(systemName: "star")
                                        .font(.system(size: 20))
                                    Text("Tab \(tab.rawValue + 1)")
                                        .font(.caption2)
                                }
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                            }
                        }
                    }
                    .frame(height: 65)
                    .padding(.bottom, insets.bottom)
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

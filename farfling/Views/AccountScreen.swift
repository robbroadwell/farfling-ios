import SwiftUI

struct AccountScreen: View {
    struct Tab: Identifiable, Equatable {
        let id: Int
        let icon: String
        let name: String

        static let all: [Tab] = [
            Tab(id: 0, icon: "person.crop.circle", name: "Profile"),
            Tab(id: 1, icon: "star.circle", name: "Badges"),
            Tab(id: 2, icon: "photo.on.rectangle", name: "Photos"),
            Tab(id: 3, icon: "bell.circle", name: "Notifications"),
            Tab(id: 4, icon: "gearshape", name: "Settings"),
        ]
    }
    @State private var selectedTab: Tab = Tab.all[0]
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
                        ForEach(Tab.all, id: \.id) { tab in
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
                        ForEach(Tab.all, id: \.id) { tab in
                            Button(action: {
                                selectedTab = tab
                            }) {
                                VStack(spacing: 4) {
                                    Image(systemName: tab.icon)
                                        .font(.system(size: 20))
                                    Text(tab.name)
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

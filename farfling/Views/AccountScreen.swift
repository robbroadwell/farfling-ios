import SwiftUI

struct AccountScreen: View {
    struct AccountHeader: View {
        let leftAction: () -> Void
        let title: String

        var body: some View {
            ZStack {
                // Center title
                Text(title)
                    .font(.headline)
                    .lineLimit(1)
                    .truncationMode(.tail)

                // Leading/Trailing controls
                HStack {
                    Button(action: leftAction) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .regular))
                            .frame(width: 36, height: 36)
                            .contentShape(Rectangle())
                    }
                    Spacer()
                }
            }
            .padding(.top, insets.top + 6)
            .padding(.horizontal, 16)
            .frame(height: 56 + insets.top)
            .background(.ultraThinMaterial)
            .mask(
                RoundedCorner(radius: 47.28, corners: [.topLeft, .topRight])
            )
            .smallShadow()
        }
    }

    struct Tab: Identifiable, Equatable {
        let id: Int
        let icon: String
        let name: String

        static let all: [Tab] = [
            Tab(id: 0, icon: "person.crop.circle", name: "Profile"),
            Tab(id: 1, icon: "photo.on.rectangle", name: "Photos"),
            Tab(id: 2, icon: "bell.circle", name: "Alerts"),
            Tab(id: 3, icon: "gearshape", name: "Settings"),
        ]
    }
    @State private var selectedTab: Tab = Tab.all[0]
    @Binding var redOffsetX: CGFloat
    @Binding var purpleOffsetX: CGFloat
    @Binding var isMapVisible: Bool
    @Binding var isPurpleVisible: Bool

    var body: some View {
        ZStack {
            Color.purple
                .mask(
                    RoundedRectangle(cornerRadius: 47.28, style: .continuous)
                )
                .ignoresSafeArea()
            VStack(spacing: 0) {
                AccountHeader(
                    leftAction: {
                        withAnimation(.spring()) {
                            purpleOffsetX = screen.width
                            redOffsetX = 0
                            isMapVisible = true
                            isPurpleVisible = false
                        }
                    },
                    title: "Account"
                )
                Spacer()
            }
            .ignoresSafeArea(edges: .top)

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
                    .frame(height: 70 + insets.bottom)
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
                    .frame(height: 55)
                    .padding(.bottom, insets.bottom)
                    .padding(.top, 15)
                }
            }
            .ignoresSafeArea()
            .smallShadow()
        }
        .offset(x: purpleOffsetX)
        .standardShadow()
    }
}
    
#Preview {
    StatefulPreviewWrapper(false) { isMapBinding in
        StatefulPreviewWrapper(false) { isPurpleVisibleBinding in
            StatefulPreviewWrapper(0.0) { redBinding in
                StatefulPreviewWrapper(0.0) { purpleBinding in
                    AccountScreen(
                        redOffsetX: redBinding,
                        purpleOffsetX: purpleBinding,
                        isMapVisible: isMapBinding,
                        isPurpleVisible: isPurpleVisibleBinding
                    )
                }
            }
        }
    }
}

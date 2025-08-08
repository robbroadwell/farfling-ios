import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct ChatScreen: View {
    @Binding var yellowOffsetX: CGFloat
    enum Tab: Int, CaseIterable {
        case one = 0, two, three, four, five
    }
    @State private var selectedTab: Tab = .one

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
            .padding(.bottom, 31 + insets.bottom)
            
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
        .offset(x: yellowOffsetX)
    }
}

#Preview {
    StatefulPreviewWrapper(0.0) { binding in
        ChatScreen(yellowOffsetX: binding)
    }
}

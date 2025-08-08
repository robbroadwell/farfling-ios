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
    
    struct Activity: Identifiable, Equatable {
        let id = UUID()
        let name: String
        let location: String
        let imageName: String

        static let sample: [Activity] = [
            Activity(name: "Kitesurf", location: "Tarifa", imageName: "kitesurf"),
            Activity(name: "Yoga", location: "Bali", imageName: "yoga"),
            Activity(name: "Hiking", location: "Patagonia", imageName: "hiking"),
            Activity(name: "Surf", location: "Oahu", imageName: "surf"),
            Activity(name: "Scuba", location: "Belize", imageName: "scuba"),
            Activity(name: "Climb", location: "Yosemite", imageName: "climb"),
            Activity(name: "Ski", location: "Zermatt", imageName: "ski"),
            Activity(name: "Sail", location: "Santorini", imageName: "sail"),
            Activity(name: "Run", location: "Chamonix", imageName: "run"),
            Activity(name: "Camp", location: "Banff", imageName: "camp"),
            Activity(name: "Fish", location: "Alaska", imageName: "fish"),
            Activity(name: "Bike", location: "Amsterdam", imageName: "bike"),
            Activity(name: "Kayak", location: "Norway", imageName: "kayak"),
            Activity(name: "Skate", location: "Venice", imageName: "skate"),
            Activity(name: "Dance", location: "Havana", imageName: "dance"),
        ]
    }
    
    struct IndexedActivity: Identifiable {
        let id: Int
        let activity: Activity
    }
    
    var indexedActivities: [IndexedActivity] {
        let repeatedCount = 1000
        let base = Activity.sample
        return (0..<(base.count * repeatedCount)).map { i in
            IndexedActivity(id: i, activity: base[i % base.count])
        }
    }
    
    @State private var selectedActivity: Activity? = nil
    
    struct Tab: Identifiable, Equatable {
        let id: Int
        let icon: String
        let name: String

        static let all: [Tab] = [
            Tab(id: 0, icon: "bubble.left.and.bubble.right", name: "Chat"),
            Tab(id: 1, icon: "doc.text.magnifyingglass", name: "Details"),
            Tab(id: 2, icon: "photo", name: "Photos"),
            Tab(id: 3, icon: "gear", name: "Settings"),
        ]
    }
    @State private var selectedTab: Tab = Tab.all[0]

    var body: some View {
        ZStack {
            Color.yellow
                .mask(
                    RoundedRectangle(cornerRadius: 47.28, style: .continuous)
                )
                .ignoresSafeArea()
            
            HStack {
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 0) {
                            ForEach(indexedActivities) { item in
                                Button(action: {
                                    selectedActivity = item.activity
                                }) {
                                    ZStack(alignment: .bottom) {
                                        Image(item.activity.imageName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: screen.width / 4, height: screen.width / 4)
                                            .clipped()
                                            .overlay(
                                                selectedActivity == item.activity
                                                ? Color.clear
                                                : Color.black.opacity(0.3)
                                            )
                                        VStack(spacing: 2) {
                                            Text(item.activity.name)
                                                .font(.caption2)
                                                .foregroundColor(.white)
                                            Text(item.activity.location)
                                                .font(.caption2)
                                                .foregroundColor(.white.opacity(0.8))
                                        }
                                        .padding(4)
                                        .background(Color.black.opacity(0.4))
                                        .frame(maxHeight: .infinity)
                                    }
                                    .frame(width: screen.width / 4, height: screen.width / 4)
                                }
                                .frame(height: screen.width / 4)
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .onAppear {
                        let middleIndex = indexedActivities.count / 2
                        DispatchQueue.main.async {
                            proxy.scrollTo(middleIndex, anchor: .top)
                        }
                    }
                }
                .frame(width: screen.width / 4)
                .background(Color.clear)
                .contentShape(Rectangle())
                Spacer()
            }
            .padding(.bottom, 31 + insets.bottom)
            
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
                    .frame(height: 65)
                    .padding(.bottom, insets.bottom)
                    .padding(.top, 5)
                }
                .smallShadow()
            }
            .ignoresSafeArea()
        }
        .offset(x: yellowOffsetX)
        .standardShadow()
    }
}

#Preview {
    StatefulPreviewWrapper(0.0) { binding in
        ChatScreen(yellowOffsetX: binding)
    }
}

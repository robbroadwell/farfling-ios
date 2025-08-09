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

struct ActivityListColumn: View {
    @Binding var selectedActivity: ChatScreen.Activity?
    let indexedActivities: [ChatScreen.IndexedActivity]
    let onSelect: (ChatScreen.Activity) -> Void

    var drawerSize: CGFloat {
        screen.width * 3/8
    }

    var body: some View {
        HStack {
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(indexedActivities) { item in
                            Button(action: {
                                selectedActivity = item.activity
                                onSelect(item.activity)
                            }) {
                                ZStack(alignment: .bottom) {
                                    Image(item.activity.imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: drawerSize, height: drawerSize)
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
                                .frame(width: drawerSize, height: drawerSize)
                            }
                            .frame(height: drawerSize)
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
            .frame(width: drawerSize)
            .background(Color.clear)
            .contentShape(Rectangle())
            Spacer()
        }
        .padding(.bottom, 31 + insets.bottom)
    }
}

struct ActivityListRow: View {
    @Binding var selectedActivity: ChatScreen.Activity?
    let indexedActivities: [ChatScreen.IndexedActivity]

    var drawerSize: CGFloat {
        screen.width * 3/8
    }

    var body: some View {
        VStack {
            Spacer()
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(indexedActivities) { item in
                            Button(action: {
                                selectedActivity = item.activity
                            }) {
                                ZStack(alignment: .bottom) {
                                    Image(item.activity.imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: drawerSize, height: drawerSize)
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
                                .frame(width: drawerSize, height: drawerSize)
                            }
                            .frame(height: drawerSize)
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .frame(height: drawerSize)
                .onAppear {
                    let middleIndex = indexedActivities.count / 2
                    DispatchQueue.main.async {
                        proxy.scrollTo(middleIndex, anchor: .top)
                    }
                }
            }
            .background(Color.clear)
            .contentShape(Rectangle())
            
        }
        .padding(.bottom, 31 + insets.bottom)
    }
}

struct ChatScreen: View {
    @Binding var redOffsetX: CGFloat
    @Binding var yellowOffsetX: CGFloat
    @Binding var isMapVisible: Bool
    @Binding var isYellowVisible: Bool

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
    @State private var isActivityColumnOpen: Bool = false
    @State private var headerTitle: String = "Chat"

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

    struct ChatUser: Identifiable, Equatable {
        let id: UUID = UUID()
        let name: String
    }

    struct ChatMessage: Identifiable, Equatable {
        let id: UUID = UUID()
        let author: ChatUser
        let text: String
        let timestamp: Date
    }

    struct ChatThread: Identifiable, Equatable {
        struct TypingStatus: Equatable {
            let user: ChatUser
        }
        let id: UUID = UUID()
        let root: ChatMessage
        let replies: [ChatMessage]
        let typing: TypingStatus?

        static let sample: [ChatThread] = {
            let alice = ChatUser(name: "Alice Johnson")
            let bob = ChatUser(name: "Bob Lee")
            let carla = ChatUser(name: "Carla Méndez")
            let dan = ChatUser(name: "Dan Wu")
            let eva = ChatUser(name: "Eva Rossi")

            func msg(_ author: ChatUser, _ text: String, minutesAgo: Int) -> ChatMessage {
                ChatMessage(author: author, text: text, timestamp: Calendar.current.date(byAdding: .minute, value: -minutesAgo, to: Date()) ?? Date())
            }

            return [
                ChatThread(
                    root: msg(alice, "Anyone up for sunrise surf tomorrow at 6?", minutesAgo: 2),
                    replies: [
                        msg(bob, "I'm in. Wind looks decent.", minutesAgo: 1),
                        msg(carla, "6 is brutal but ok. Coffee afterwards?", minutesAgo: 1),
                        msg(dan, "I'll bring the drone for shots.", minutesAgo: 0)
                    ],
                    typing: TypingStatus(user: carla) // show typing in this thread
                ),
                ChatThread(
                    root: msg(eva, "New yoga studio opened near the boardwalk 🧘‍♀️", minutesAgo: 12),
                    replies: [
                        msg(alice, "I tried their vinyasa class—solid playlist.", minutesAgo: 10),
                        msg(bob, "Do they have early classes?", minutesAgo: 9),
                        msg(eva, "Yep, 7am and 8:30am", minutesAgo: 8)
                    ],
                    typing: nil
                ),
                ChatThread(
                    root: msg(dan, "Scuba trip to Belize in November—who's interested?", minutesAgo: 30),
                    replies: [
                        msg(carla, "That blue hole is on my bucket list.", minutesAgo: 28),
                        msg(bob, "Cost estimate?", minutesAgo: 27),
                        msg(dan, "Thinking budget-friendly—group rates if 6+ people.", minutesAgo: 25)
                    ],
                    typing: nil
                ),
                ChatThread(
                    root: msg(carla, "Trail run Saturday in Chamonix theme—costumes optional 😂", minutesAgo: 55),
                    replies: [
                        msg(alice, "I'm coming as a cowbell.", minutesAgo: 50),
                        msg(eva, "Please do.", minutesAgo: 49)
                    ],
                    typing: nil
                )
            ]
        }()
    }

    // Data source for the chat list
    private let chatThreads: [ChatThread] = ChatThread.sample

    var body: some View {
        ZStack {
            ChatThreadList(chatThreads: chatThreads, topContentInset: 56 + insets.top)
                .allowsHitTesting(!isActivityColumnOpen)
                .blur(radius: isActivityColumnOpen ? 10 : 0)
                .animation(.spring(response: 0.35, dampingFraction: 0.85), value: isActivityColumnOpen)
                .mask(
                    RoundedRectangle(cornerRadius: 47.28, style: .continuous)
                )
                .ignoresSafeArea()

            // LEFT DRAWER: ActivityListColumn (slide-in)
            ZStack(alignment: .leading) {
                if isActivityColumnOpen {
                    Color.clear
                        .contentShape(Rectangle())
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                isActivityColumnOpen = false
                            }
                        }
                }
                HStack(spacing: 0) {
                    ActivityListColumn(
                        selectedActivity: $selectedActivity,
                        indexedActivities: indexedActivities,
                        onSelect: { activity in
                            headerTitle = "\(activity.name), \(activity.location)"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                    isActivityColumnOpen = false
                                }
                            }
                        }
                    )
                    .offset(x: isActivityColumnOpen ? 0 : -(screen.width * 3/8 + 16))
                    
                    Spacer(minLength: 0)
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.85), value: isActivityColumnOpen)
            
            // HEADER
            VStack(spacing: 0) {
                ChatHeader(
                    menuAction: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            isActivityColumnOpen.toggle()
                        }
                    },
                    rightAction: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            yellowOffsetX = -screen.width
                            redOffsetX = 0
                            isMapVisible = true
                            isYellowVisible = false
                        }
                    },
                    title: headerTitle,
                    isMenuOpen: isActivityColumnOpen
                )
                Spacer()
            }
            .ignoresSafeArea(edges: .top)

            ChatTabBar(selectedTab: $selectedTab)
        }
        .offset(x: yellowOffsetX)
        .standardShadow()
    }
}

#Preview {
    StatefulPreviewWrapper(false) { isMapBinding in
        StatefulPreviewWrapper(false) { isYellowVisibleBinding in
            StatefulPreviewWrapper(0.0) { redBinding in
                StatefulPreviewWrapper(0.0) { yellowBinding in
                    ChatScreen(
                        redOffsetX: redBinding,
                        yellowOffsetX: yellowBinding,
                        isMapVisible: isMapBinding,
                        isYellowVisible: isYellowVisibleBinding
                    )
                }
            }
        }
    }
}

struct ChatThreadList: View {
    let chatThreads: [ChatScreen.ChatThread]
    var topContentInset: CGFloat = 0

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                ForEach(chatThreads) { thread in
                    VStack(alignment: .leading, spacing: 8) {
                        MessageRow(message: thread.root)
                        ForEach(thread.replies) { reply in
                            MessageRow(message: reply, indentLevel: 1)
                        }
                        if let typing = thread.typing {
                            TypingIndicatorRow(user: typing.user, indentLevel: 1)
                        }
                        Divider()
                            .opacity(0.15)
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(.top, topContentInset + 20)
            .padding(.bottom, 120) // leave room for bottom UI
        }
        .background(Color(UIColor.systemBackground))
    }
}

struct MessageRow: View {
    let message: ChatScreen.ChatMessage
    var indentLevel: Int = 0

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if indentLevel > 0 {
                Rectangle()
                    .frame(width: 2)
                    .opacity(0.08)
                    .padding(.leading, 8)
            }

            AvatarView(name: message.author.name)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(message.author.name)
                        .font(.subheadline).bold()
                    Text(Self.relativeDate(message.timestamp))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text(message.text)
                    .font(.body)
            }
            Spacer(minLength: 0)
        }
        .padding(.leading, CGFloat(indentLevel) * 24)
    }

    static func relativeDate(_ date: Date) -> String {
        let fmt = RelativeDateTimeFormatter()
        fmt.unitsStyle = .short
        return fmt.localizedString(for: date, relativeTo: Date())
    }
}

struct AvatarView: View {
    let name: String

    var initials: String {
        let parts = name.split(separator: " ")
        let first = parts.first?.first.map(String.init) ?? "?"
        let last = parts.dropFirst().first?.first.map(String.init) ?? ""
        return first + last
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(colorForName(name))
                .frame(width: 32, height: 32)
            Text(initials)
                .font(.caption).bold()
                .foregroundColor(.white)
        }
        .accessibilityLabel(Text("Avatar of \(name)"))
    }

    private func colorForName(_ name: String) -> Color {
        let hash = abs(name.hashValue)
        let hue = Double(hash % 256) / 255.0
        return Color(hue: hue, saturation: 0.55, brightness: 0.75)
    }
}

struct TypingIndicatorRow: View {
    let user: ChatScreen.ChatUser
    var indentLevel: Int = 0
    @State private var animate = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if indentLevel > 0 {
                Rectangle()
                    .frame(width: 2)
                    .opacity(0.08)
                    .padding(.leading, 8)
            }

            AvatarView(name: user.name)

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text(user.name)
                        .font(.subheadline).bold()
                    Text("typing…")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                HStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.secondary.opacity(0.15))
                        .frame(width: 42, height: 28)
                        .overlay(
                            HStack(spacing: 6) {
                                ForEach(0..<3) { i in
                                    Circle()
                                        .frame(width: 6, height: 6)
                                        .opacity(animate ? 1.0 : 0.3)
                                        .scaleEffect(animate ? 1.0 : 0.8)
                                        .animation(
                                            .easeInOut(duration: 0.8)
                                                .repeatForever()
                                                .delay(Double(i) * 0.2),
                                            value: animate
                                        )
                                }
                            }
                        )
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.leading, CGFloat(indentLevel) * 24)
        .onAppear { animate = true }
    }
}

struct ChatTabBar: View {
    @Binding var selectedTab: ChatScreen.Tab

    var body: some View {
        VStack {
            Spacer()

            ZStack {
                HStack(spacing: 0) {
                    ForEach(ChatScreen.Tab.all, id: \.id) { tab in
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
                    ForEach(ChatScreen.Tab.all, id: \.id) { tab in
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
            .smallShadow()
        }
        .ignoresSafeArea()
    }
}


struct ChatHeader: View {
    let menuAction: () -> Void
    let rightAction: () -> Void
    let title: String
    let isMenuOpen: Bool

    var body: some View {
        ZStack {
            // Center title
            Text(title)
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.tail)

            // Leading/Trailing controls
            HStack {
                Button(action: menuAction) {
                    Image(systemName: isMenuOpen ? "xmark" : "line.3.horizontal")
                        .rotationEffect(.degrees(isMenuOpen ? 90 : 0))
                        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isMenuOpen)
                        .font(.system(size: 20, weight: .semibold))
                        .frame(width: 36, height: 36)
                        .contentShape(Rectangle())
                }
                Spacer()
                Button(action: rightAction) {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 20, weight: .regular))
                        .frame(width: 36, height: 36)
                        .contentShape(Rectangle())
                }
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

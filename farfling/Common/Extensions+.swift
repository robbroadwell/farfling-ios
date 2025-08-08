import SwiftUI

extension UIApplication {
    var keyWindowSafeAreaInsets: UIEdgeInsets {
        self.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .safeAreaInsets ?? .zero
    }
}

var insets: UIEdgeInsets { UIApplication.shared.keyWindowSafeAreaInsets }
var screen: CGRect { UIScreen.main.bounds }

struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    var content: (Binding<Value>) -> Content

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: value)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}


struct StatefulPreviewWrapper3<Value, Content: View>: View {
    @State private var value1: Value
    @State private var value2: Value
    @State private var value3: Value
    let content: (Binding<Value>, Binding<Value>, Binding<Value>) -> Content

    init(
        _ value1: Value,
        _ value2: Value,
        _ value3: Value,
        content: @escaping (Binding<Value>, Binding<Value>, Binding<Value>) -> Content
    ) {
        _value1 = State(initialValue: value1)
        _value2 = State(initialValue: value2)
        _value3 = State(initialValue: value3)
        self.content = content
    }

    var body: some View {
        content($value1, $value2, $value3)
    }
}

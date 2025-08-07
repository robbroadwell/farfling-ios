import SwiftUI
import MapKit

struct ContentView2: View {
    var body: some View {
        DrawerMapView()
    }
}


struct DrawerMapView: View {
    @State private var topOffset: CGFloat = 0
    @State private var bottomOffset: CGFloat = 0
    @State private var leftOffset: CGFloat = 0
    @State private var rightOffset: CGFloat = 0
    @State private var leftDrawerWidth: CGFloat = 0
    @State private var accumulatedDrawerWidth: CGFloat = 200
    @GestureState private var dragOffset: CGFloat = 0

    private let maxDrawerSize: CGFloat = 300
    private let minDrawerSize: CGFloat = 10

    var body: some View {
        ZStack {
            Color.red
            HStack(spacing: 0) {
                Map(coordinateRegion: .constant(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                    span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50)
                )))
                .clipShape(RoundedRectangle(cornerRadius: 47.28))
            }
            
            HStack {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: max(0, min(250, accumulatedDrawerWidth + dragOffset)))
                    .gesture(
                        DragGesture()
                            .updating($dragOffset) { value, state, _ in
                                state = value.translation.width
                            }
                            .onEnded { value in
                                let proposed = accumulatedDrawerWidth + value.translation.width
                                accumulatedDrawerWidth = max(0, min(250, proposed))
                            }
                    )
                Spacer()
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 47.28))
        .compositingGroup()
        .shadow(radius: 4)
        .padding(.vertical, 14)
        .ignoresSafeArea()
        .padding(.horizontal, 12)
    }
}

#Preview {
    ContentView()
}

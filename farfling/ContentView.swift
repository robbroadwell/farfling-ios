import SwiftUI
import MapKit

struct ContentView: View {
    var body: some View {
        DrawerMapView()
    }
}


struct DrawerMapView: View {
    @State private var topOffset: CGFloat = 0
    @State private var bottomOffset: CGFloat = 0
    @State private var leftOffset: CGFloat = 0
    @State private var rightOffset: CGFloat = 0

    private let maxDrawerSize: CGFloat = 300
    private let minDrawerSize: CGFloat = 10

    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .padding(.top, topOffset)
                    .padding(.bottom, bottomOffset + 40)
                    .padding(.leading, leftOffset + 40)
                    .padding(.trailing, rightOffset + 40)
                    .overlay(
                        Map(coordinateRegion: .constant(MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                            span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50)
                        )))
                        .clipShape(RoundedRectangle(cornerRadius: 47.28))
                    )
                    .animation(
                        .spring(),
                        value: [
                            topOffset,
                            bottomOffset,
                            leftOffset,
                            rightOffset
                        ]
                    )

                // Top Drawer
                VStack {
                    Rectangle()
                        .fill(Color.white.opacity(0.95))
                        .frame(height: topOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let newHeight = min(max(value.translation.height, 0), maxDrawerSize)
                                    topOffset = newHeight
                                }
                        )
                        .background(Color.white)
                    Spacer()
                }

                // Bottom Drawer
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(Color.white.opacity(0.95))
                        .frame(height: bottomOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let newHeight = min(max(-value.translation.height, 0), maxDrawerSize)
                                    bottomOffset = newHeight
                                }
                        )
                        .background(Color.white)
                }

                // Left Drawer
                HStack {
                    Rectangle()
                        .fill(Color.white.opacity(0.95))
                        .frame(width: leftOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let newWidth = min(max(value.translation.width, 0), maxDrawerSize)
                                    leftOffset = newWidth
                                }
                        )
                        .background(Color.white)
                    Spacer()
                }

                // Right Drawer
                HStack {
                    Spacer()
                    Rectangle()
                        .fill(Color.white.opacity(0.95))
                        .frame(width: rightOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let newWidth = min(max(-value.translation.width, 0), maxDrawerSize)
                                    rightOffset = newWidth
                                }
                        )
                        .background(Color.white)
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 47.28))
            .compositingGroup()
            .shadow(radius: 4)
        }
        .padding(.vertical, 14)
        .ignoresSafeArea()
        .padding(.horizontal, 12)
    }
}

#Preview {
    ContentView()
}

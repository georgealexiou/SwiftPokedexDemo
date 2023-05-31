import SwiftUI

struct LoadingView: View {
    var size: CGFloat
    @State private var isRotating = false

    var body: some View {
        Image("pokeball")
            .resizable()
            .frame(width: size, height: size)
            .aspectRatio(contentMode: .fit)
            .rotationEffect(.degrees(isRotating ? 360 : 0))
            .onAppear() {
                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                    self.isRotating = true
                }
            }
    }
}

struct LoadingViewPreview: PreviewProvider {
    static var previews: some View {
        LoadingView(size: 200)
    }
}

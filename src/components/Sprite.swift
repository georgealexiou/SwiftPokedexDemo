import SwiftUI

struct Sprite: View {
    var spriteURL: String
    var text: String
    var backgroundColor: Color?
    
    var body: some View {
        VStack{
            AsyncImage(url: URL(string: spriteURL)) { image in
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .background(backgroundColor != nil ? backgroundColor : .clear)
                    .cornerRadius(10)
            } placeholder: {
                LoadingView(size:50)
            }
            Text(text)
        }
    }
}

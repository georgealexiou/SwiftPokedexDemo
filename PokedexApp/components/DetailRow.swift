import SwiftUI

struct DetailRow: View {
    var title: String
    var content: String
    var color: Color?

    var body: some View {
        HStack {
            Text(title)
                .bold()
                .foregroundColor(color)
            Spacer()
            Text(content)
        }
        .frame(maxWidth: 250)
        .padding(.horizontal)
    }
}

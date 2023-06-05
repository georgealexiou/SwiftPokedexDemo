import SwiftUI

struct StatBar: View {
    var title: String
    var value: Int
    var max: Int
    var color: Color?

    var body: some View {
        HStack {
            HStack {
                Text(title.capitalized)
                Spacer()
            }
            .frame(width: 135)
            ProgressView(value: Float(value) / Float(max))
                .tint(color ?? .clear)

            HStack {
                Spacer()
                Text("\(Int(value))")
            }
            .frame(width: 40)
        }
    }
}

import Foundation

import SwiftUI

struct Types: View {
    var types: [String]

    var body: some View {
        HStack {
            Type(type: types[0])
            if types.count == 2 {
                Type(type: types[1])
            }
        }
    }
}

private struct Type: View {
    var type: String

    var body: some View {
        VStack {
            Text(type.capitalized)
        }
        .padding(3)
        .frame(width: 80
        )
        .background(pokemonTypeColors[type.lowercased()])
        .foregroundColor(Color.white)
        .cornerRadius(5)
    }
}

struct PokemonTypesPreview: PreviewProvider {
    static var previews: some View {
        Types(types: ["Grass", "Poison"])
    }
}

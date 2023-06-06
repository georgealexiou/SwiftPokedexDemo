import SwiftUI

struct MediumView: View {
    var pokemon: Pokemon
    var image: UIImage
    
    var body: some View {
        HStack {
            VStack {
                Text("#\(formatNumber(id: pokemon.id))")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .opacity(0.6)
                Text("\(pokemon.name.capitalized)")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .opacity(0.8)
                Types(types: pokemon.types)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Image(uiImage: image)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        typeColorsBackground[pokemon.types.first?.lowercased() ?? ""] ?? .clear,
                        pokemonTypeColors[pokemon.types.first?.lowercased() ?? ""] ?? .clear
                    ]
                ),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

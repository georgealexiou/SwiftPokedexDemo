import SwiftUI

struct LargeView: View {
    var pokemon: Pokemon
    var image: UIImage
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("\(pokemon.name.capitalized)")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .opacity(0.8)
                    Text("#\(formatNumber(id: pokemon.id))")
                        .font(.title)
                        .bold()
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .opacity(0.6)
                }
            }
            
            Image(uiImage: image)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
            
            Types(types: pokemon.types)
                .frame(maxWidth: .infinity, alignment: .leading)
            
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

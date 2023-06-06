import SwiftUI

struct SmallView: View {
    var pokemon: Pokemon
    var image: UIImage
    
    var body: some View {
        VStack {
            Text("#\(formatNumber(id: pokemon.id))")
                .font(.title3)
                .bold()
                .foregroundColor(.black)
                .opacity(0.6)
            Text("\(pokemon.name.capitalized)")
                .font(.title3)
                .bold()
                .foregroundColor(.white)
                .opacity(0.8)
            
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

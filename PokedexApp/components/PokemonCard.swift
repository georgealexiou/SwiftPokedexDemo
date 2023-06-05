import Foundation
import SwiftUI

struct PokemonCard: View {
    var pokemon: Pokemon
    let imageURL = "https://assets.pokemon.com/assets/cms2/img/pokedex/full/"
    
    var body: some View {
        VStack {
            VStack {
                Text("#\(formatNumber(id: pokemon.id))")
                    .bold()
                    .foregroundColor(Color.black)
                    .font(.title)
                    .opacity(0.6)
                    .multilineTextAlignment(.leading)
            }
            Spacer()

            AsyncImage(url: URL(string: "\(imageURL)\(formatNumber(id: pokemon.id)).png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                LoadingView(size: 60)
            }
            Text("\(pokemon.name.capitalized)")
                .bold()
                .foregroundColor(Color.white)
                .font(.title)
                .opacity(0.8)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, maxHeight: 200)
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(
                    colors: [typeColorsBackground[pokemon.types[0].lowercased()] ?? .clear,
                             pokemonTypeColors[pokemon.types[0].lowercased()] ?? .clear]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(10)
        .padding(.bottom)
    }
}

struct PokemonCardPreview: PreviewProvider {
    static var previews: some View {
        PokemonCard(pokemon: Pokemon(id: 570, name: "Zorua", types: ["Dark"]))
            .padding()
    }
}

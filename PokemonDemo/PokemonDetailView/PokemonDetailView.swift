import SwiftUI

struct PokemonDetailView: View {
    var pokemon:Pokemon
    
    let imageURL = "https://assets.pokemon.com/assets/cms2/img/pokedex/full/"
    
    var body: some View {
        VStack{
            VStack{
                Text("#\(formatNumber(id: pokemon.id))")
                    .bold()
                    .foregroundColor(Color.black)
                    .font(.system(size: 30))
                    .opacity(0.6)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
            
            AsyncImage(url: URL(string: "\(imageURL)\(formatNumber(id: pokemon.id)).png")) { image in
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
            } placeholder: {
                LoadingView(size:60)
            }
            Text("\(pokemon.name.capitalized)")
                .bold()
                .foregroundColor(Color.white)
                .font(.system(size: 25))
                .opacity(0.8)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, maxHeight: 200)
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [typeColorsBackground[pokemon.types[0].lowercased()] ?? .clear, pokemonTypeColors[pokemon.types[0].lowercased()] ?? .clear]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(10)
        .padding()
        Types(types:pokemon.types)
    }
}

struct PokemonPreviewPreview: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(pokemon: Pokemon(id:1, name:"Bulbasaur", types:["Grass","Poison"]))
    }
}

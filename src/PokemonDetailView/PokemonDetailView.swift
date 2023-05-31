import SwiftUI
import Combine

struct PokemonDetailView: View {
    var pokemon:Pokemon
    
    let imageURL = "https://assets.pokemon.com/assets/cms2/img/pokedex/full/"
    @StateObject var viewModel: PokemonDetailViewModel
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
        _viewModel = StateObject(wrappedValue: PokemonDetailViewModel(pokemon: pokemon))
    }
    
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

class PokemonDetailViewModel: ObservableObject {
    @Published var pokemonDetail: PokemonDetail?

    var cancellables = Set<AnyCancellable>()

    init(pokemon: Pokemon) {
        fetchPokemonData(for: pokemon.name.lowercased())
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching data: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { pokemonDetail in
                self.pokemonDetail = pokemonDetail
            }
            .store(in: &cancellables)
    }
    
    func fetchPokemonData(for pokemonName: String) -> Future<PokemonDetail, Error> {
        return Future { promise in
            let urlString = "https://pokeapi.co/api/v2/pokemon/\(pokemonName)"
            guard let url = URL(string: urlString) else {
                promise(.failure(URLError(.badURL)))
                return
            }
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                do {
                    let pokemonDetail = try JSONDecoder().decode(PokemonDetail.self, from: data!)
                    promise(.success(pokemonDetail))
                } catch {
                    promise(.failure(error))
                }
            }
            task.resume()
        }
    }
}


struct PokemonPreviewPreview: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(pokemon: Pokemon(id:63, name:"Abra", types:["Psychic"]))
    }
}

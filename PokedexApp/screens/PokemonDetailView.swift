import Combine
import SwiftUI

struct PokemonDetailView: View {
    var pokemon: Pokemon
    @StateObject var viewModel = PokemonDetailViewModel()
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
        _viewModel = StateObject(wrappedValue: PokemonDetailViewModel(pokemon: pokemon))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            PokemonCard(pokemon: pokemon)
            Types(types: pokemon.types)
            
            if let pokemonDetail = viewModel.pokemonDetail {
                HStack {
                    Text("Stats")
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                
                VStack {
                    ForEach(pokemonDetail.stats, id: \.stat.name) { stat in
                        StatBar(
                            title: stat.stat.name,
                            value: stat.base,
                            max: 255, color:
                                pokemonTypeColors[pokemon.types[0].lowercased()]
                        )
                    }
                }
                .padding(.bottom)
                
                HStack {
                    Text("Sprites")
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                HStack {
                    Sprite(
                        spriteURL: pokemonDetail.sprites.frontDefault!,
                        text: "Front",
                        backgroundColor: Color(UIColor.systemGray5))
                    Sprite(spriteURL:
                            pokemonDetail.sprites.backDefault!,
                           text: "Back",
                           backgroundColor: Color(UIColor.systemGray5))
                    Sprite(
                        spriteURL: pokemonDetail.sprites.frontShiny!,
                        text: "Shiny",
                        backgroundColor: Color(UIColor.systemGray5)
                    )
                }
                
                VStack {
                    DetailRow(title: "Height", content: "\(pokemonDetail.height)")
                    DetailRow(title: "Weight", content: "\(pokemonDetail.weight)")
                    DetailRow(title: "Base Experience", content: "\(pokemonDetail.baseExperience)")
                }
                .padding(.vertical)
            } else {
                Text("Information about this Pokemon could not be accessed at this time")
            }
            
            Spacer()
        }
        .navigationBarTitle(pokemon.name)
        .padding()
    }
}

class PokemonDetailViewModel: ObservableObject {
    @Published var pokemonDetail: PokemonDetail?
    
    var cancellables = Set<AnyCancellable>()
    
    init(pokemon: Pokemon? = nil) {
        if let pokemon = pokemon {
            fetchPokemonData(for: pokemon.name.lowercased())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching data: \(error)")
                    case .finished:
                        break
                    }
                }, receiveValue: { pokemonDetail in
                    self.pokemonDetail = pokemonDetail
                })
                .store(in: &cancellables)
        } else {
            self.pokemonDetail = nil
        }
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

struct PokemonDetailsPreview: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(pokemon: Pokemon(id: 280, name: "Ralts", types: ["Psychic", "Fairy"]))
    }
}

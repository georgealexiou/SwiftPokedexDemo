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

        ScrollView(showsIndicators:false){
            VStack{
                VStack{
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
                        .frame(width:.infinity)
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    LoadingView(size:60)
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
                    gradient: Gradient(colors: [typeColorsBackground[pokemon.types[0].lowercased()] ?? .clear, pokemonTypeColors[pokemon.types[0].lowercased()] ?? .clear]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(10)
            .padding(.bottom)
            
            Types(types:pokemon.types)
            
            
            if let pokemonDetail = viewModel.pokemonDetail {
                
                HStack{
                    Text("Stats")
                        .font(.title2)
                        .bold()
                    Spacer()
                }

                VStack {
                    ForEach(pokemonDetail.stats, id: \.stat.name) { stat in
                        StatBar(title: stat.stat.name, value:stat.base_stat, max:255, color: pokemonTypeColors[pokemon.types[0].lowercased()])
                    }
                }
                .padding(.bottom)
                
                HStack{
                    Text("Sprites")
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                HStack{
                    Sprite(spriteURL: pokemonDetail.sprites.front_default!, text: "Front", backgroundColor: Color(UIColor.systemGray5))
                    Sprite(spriteURL: pokemonDetail.sprites.back_default!, text: "Back", backgroundColor: Color(UIColor.systemGray5))
                    Sprite(spriteURL: pokemonDetail.sprites.front_shiny!, text: "Shiny", backgroundColor: Color(UIColor.systemGray5))
                }
                
                VStack{
                    DetailRow(title: "Height", content: "\(pokemonDetail.height)")
                    DetailRow(title: "Weight", content: "\(pokemonDetail.weight)")
                    DetailRow(title: "Base Experience", content: "\(pokemonDetail.base_experience)")
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

private struct StatBar:View{
    var title:String
    var value:Int
    var max:Int
    var color:Color?
    
    var body: some View {
        HStack{
            HStack{
                Text(title.capitalized)
                Spacer()
            }
            .frame(width:135)
            ProgressView(value:Float(value)/Float(max))
                .tint(color ?? .clear)
            
            HStack{
                Spacer()
                Text("\(Int(value))")
            }
            .frame(width:40)

        }
    }
}

private struct Sprite: View {
    var spriteURL: String
    var text: String
    var backgroundColor: Color?
    
    var body: some View {
        VStack{
            AsyncImage(url: URL(string: spriteURL)) { image in
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .background(backgroundColor != nil ? color : .clear)
                    .cornerRadius(10)
            } placeholder: {
                LoadingView(size:50)
            }
            Text(text)
        }
    }
}

private struct DetailRow: View{
    var title:String
    var content: String
    var color: Color?
    
    var body: some View {
        HStack{
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


struct PokemonDetailsPreview: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(pokemon: Pokemon(id:280, name:"Ralts", types:["Psychic","Fairy"]))
    }
}

import Foundation
import SwiftUI

struct Pokemon: Codable {
    let id: Int
    let name: String
    let types: [String]
}

struct PokemonSearchBar: View {
    @State private var searchText = ""
    @State private var filteredPokemon: [Pokemon] = []
    @State private var isSearching = false
    
    private var imageURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"
    
    var body: some View {
        NavigationView{
            VStack {
                SearchBar(text: $searchText, isSearching: $isSearching, onSearchButtonClicked: {})
                    .padding(.horizontal)
                
                List(filteredPokemon, id: \.name) { pokemon in
                    NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                        HStack{
                            AsyncImage(url: URL(string: "\(imageURL)\(pokemon.id).png")) { image in
                                image
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                LoadingView(size: 60)
                            }
                            VStack(alignment: .leading) {
                                Text(pokemon.name.capitalized)
                                    .font(.headline)
                                Text("#\(formatNumber(id: pokemon.id))")
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(pokemonTypeColors[pokemon.types[0]])
                            }
                        }
                    }
                }
            }
            .onChange(of: searchText) { _ in
                if (searchText.isEmpty) {
                    getInitialList()
                    return
                }
                
                searchPokemon()
            }
            .onAppear {
                getInitialList()
            }
        }
    }
    
    private func getInitialList() {
        guard let fileURL = Bundle.main.url(forResource: "pokemonData", withExtension: "json") else {
            return
        }
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            filteredPokemon = try JSONDecoder().decode([Pokemon].self, from: jsonData)
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    private func searchPokemon() {
        guard let fileURL = Bundle.main.url(forResource: "pokemonData", withExtension: "json") else {
            return
        }
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let decodedData = try JSONDecoder().decode([Pokemon].self, from: jsonData)
            
            filteredPokemon = decodedData.filter {
                let range = $0.name.range(of: searchText, options: .caseInsensitive)
                return range != nil
            }
            
            isSearching = false
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    @Binding var isSearching: Bool
    var onSearchButtonClicked: () -> Void
    
    var body: some View {
        HStack {
            TextField("Search", text: $text, onEditingChanged: { isEditing in
                isSearching = isEditing
            }, onCommit: {
                onSearchButtonClicked()
            })
            .padding(.leading, 8)
            .padding(.vertical, 12)
        }
        .background(Color(.systemGray5))
        .cornerRadius(10)
    }
}


struct SearchBarPreview: PreviewProvider {
    static var previews: some View {
        PokemonSearchBar()
    }
}

import SwiftUI

@main
struct PokemonDemoApp: App {
    @StateObject var viewModel = PokemonDetailViewModel()
    
    var body: some Scene {
        WindowGroup {
            PokemonSearchBar()
                .onOpenURL { url in
                    handle(url)
                }
        }
    }
    
    func handle(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems,
              let pokemonId = queryItems.first(where: { $0.name == "id" })?.value,
              let id = Int(pokemonId) else {
            return
        }
        
        let pokemon = Pokemon(id: id, name: "", types: [""]) // Initialize with id, name and types should be filled later in viewModel
    }
}

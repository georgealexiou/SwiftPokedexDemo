import Intents
import SwiftUI
import WidgetKit

struct Provider: IntentTimelineProvider {
    let pokemons = readPokemonsFromFile()
    
    static func readPokemonsFromFile() -> [Pokemon] {
        var pokemon: [Pokemon] = []
        guard let fileURL = Bundle.main.url(forResource: "pokemonData", withExtension: "json") else {
            return [Pokemon(id: 1, name: "Bulbasaur", types: ["Grass", "Poison"])]
        }
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            pokemon = try JSONDecoder().decode([Pokemon].self, from: jsonData)
            
        } catch {
            print("Error decoding JSON: \(error)")
        }
        
        return pokemon
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        let placeholderImage = UIImage(named: "fuecoco") // Replace "Placeholder" with the name of your placeholder image
        return SimpleEntry(
            date: Date(),
            configuration: ConfigurationIntent(),
            pokemon: Pokemon(id: 909, name: "Fuecoco", types: ["Fire"]),
            pokemonImage: placeholderImage ?? UIImage()) // If the placeholder image doesn't exist, use a blank image
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        guard let randomPokemon = pokemons.randomElement() else {
            return
        }
        let imageURL = "https://assets.pokemon.com/assets/cms2/img/pokedex/full/\(formatNumber(id: randomPokemon.id)).png"
        URLSession.shared.dataTask(with: URL(string: imageURL)!) { (data, _, _) in
            if let data = data, let pokemonImage = UIImage(data: data) {
                let entry = SimpleEntry(date: Date(), configuration: configuration, pokemon: randomPokemon, pokemonImage: pokemonImage)
                completion(entry)
            }
        }.resume()
    }
    
    func getTimeline(
        for configuration: ConfigurationIntent,
        in context: Context,
        completion: @escaping (Timeline<Entry>) -> Void
    ) {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        let endOfDay = calendar.startOfDay(for: currentDate).addingTimeInterval(24 * 60 * 60 - 1)
        
        guard let entryDate = calendar.date(byAdding: .day, value: 1, to: endOfDay) else {
            completion(Timeline(entries: [], policy: .atEnd))
            return
        }
        
        guard let randomPokemon = pokemons.randomElement() else {
            return
        }
        
        let imageURL = "https://assets.pokemon.com/assets/cms2/img/pokedex/full/\(formatNumber(id: randomPokemon.id)).png"
        
        URLSession.shared.dataTask(with: URL(string: imageURL)!) { (data, _, _) in
            if let data = data, let pokemonImage = UIImage(data: data) {
                let entry = SimpleEntry(date: entryDate, configuration: configuration, pokemon: randomPokemon, pokemonImage: pokemonImage)
                entries.append(entry)
                let timeline = Timeline(entries: entries, policy: .after(endOfDay))
                completion(timeline)
            }
        }.resume()
    }
    
}

struct FeaturedPokemonWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

        @ViewBuilder
        var body: some View {
            
            switch family {
            case .systemSmall:
                SmallView(pokemon: entry.pokemon, image: entry.pokemonImage)
            case .systemMedium:
                MediumView(pokemon: entry.pokemon, image: entry.pokemonImage)
            case .systemLarge:
                LargeView(pokemon: entry.pokemon, image: entry.pokemonImage)
            default:
                Text("Some other WidgetFamily in the future.")
            }

        }
    
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let pokemon: Pokemon
    let pokemonImage: UIImage // Add this property
}

struct FeaturedPokemonWidget: Widget {
    let kind: String = "FeaturedPokemonWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            FeaturedPokemonWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct FeaturedPokemonWidget_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedPokemonWidgetEntryView(
            entry: SimpleEntry(
                date: Date(),
                configuration: ConfigurationIntent(),
                pokemon: Pokemon(id: 1000, name: "Gholdengo", types: ["Steel", "Ghost"]),
                pokemonImage: UIImage(named: "gholdengo") ?? UIImage()
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

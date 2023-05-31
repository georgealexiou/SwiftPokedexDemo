import Foundation

struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let base_experience: Int
    let height: Int
    let weight: Int
    let sprites: PokemonSprites
    let types: [PokemonType]
    let abilities: [PokemonAbility]
    let stats: [PokemonStat]
}

struct PokemonSprites: Codable {
    let front_default: String?
    let front_shiny: String?
    let front_female: String?
    let front_shiny_female: String?
    let back_default: String?
    let back_shiny: String?
    let back_female: String?
    let back_shiny_female: String?
}

struct PokemonType: Codable {
    let slot: Int
    let type: TypeDetail
}

struct TypeDetail: Codable {
    let name: String
    let url: String
}

struct PokemonAbility: Codable {
    let ability: AbilityDetail
    let is_hidden: Bool
    let slot: Int
}

struct AbilityDetail: Codable {
    let name: String
    let url: String
}

struct PokemonStat: Codable {
    let base_stat: Int
    let effort: Int
    let stat: StatDetail
}

struct StatDetail: Codable {
    let name: String
    let url: String
}

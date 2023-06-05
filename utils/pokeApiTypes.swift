import Foundation

struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let baseExperience: Int
    let height: Int
    let weight: Int
    let sprites: PokemonSprites
    let types: [PokemonType]
    let abilities: [PokemonAbility]
    let stats: [PokemonStat]
}

struct PokemonSprites: Codable {
    let frontDefault: String?
    let frontShiny: String?
    let frontFemale: String?
    let frontFemaleShiny: String?
    let backDefault: String?
    let backShiny: String?
    let backFemale: String?
    let backFemaleShiny: String?
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
    let isHidden: Bool
    let slot: Int
}

struct AbilityDetail: Codable {
    let name: String
    let url: String
}

struct PokemonStat: Codable {
    let base: Int
    let effort: Int
    let stat: StatDetail
}

struct StatDetail: Codable {
    let name: String
    let url: String
}

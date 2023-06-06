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

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case baseExperience = "base_experience"
        case height
        case weight
        case sprites
        case types
        case abilities
        case stats
    }
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

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
        case frontFemale = "front_female"
        case frontFemaleShiny = "front_female_shiny"
        case backDefault = "back_default"
        case backShiny = "back_shiny"
        case backFemale = "back_female"
        case backFemaleShiny = "back_female_shiny"
    }
}

struct PokemonType: Codable {
    let slot: Int
    let type: TypeDetail

    enum CodingKeys: String, CodingKey {
        case slot
        case type
    }
}

struct TypeDetail: Codable {
    let name: String
    let url: String
}

struct PokemonAbility: Codable {
    let ability: AbilityDetail
    let isHidden: Bool
    let slot: Int

    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }
}

struct AbilityDetail: Codable {
    let name: String
    let url: String
}

struct PokemonStat: Codable {
    let base: Int
    let effort: Int
    let stat: StatDetail

    enum CodingKeys: String, CodingKey {
        case base = "base_stat"
        case effort
        case stat
    }
}

struct StatDetail: Codable {
    let name: String
    let url: String
}

import SwiftUI
import WidgetKit

@main
struct FeaturedPokemonWidgetBundle: WidgetBundle {
    var body: some Widget {
        FeaturedPokemonWidget()
        FeaturedPokemonWidgetLiveActivity()
    }
}

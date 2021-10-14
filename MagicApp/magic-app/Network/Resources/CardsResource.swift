import Foundation
import MagicNetwork

enum CardsResource {
    static func cards(from set: String) -> Resource {
        return Resource(url: "https://api.magicthegathering.io/v1/cards?set=\(set)",
                        method: .get,
                        body: nil)
    }
}

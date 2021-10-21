import Foundation
import MagicNetwork

enum CardsResource {
    static func cards(from set: String, atPage page: Int) -> Resource {
        return Resource(url: "https://api.magicthegathering.io/v1/cards?set=\(set)&page=\(page)",
                        method: .get,
                        body: nil)
    }
}

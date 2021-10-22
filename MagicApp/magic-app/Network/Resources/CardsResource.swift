import Foundation
import MagicNetwork

enum CardsResource {
    static func cards(from set: String, atPage page: Int) -> Resource {
        return Resource(
            url: "https://api.magicthegathering.io/v1/cards",
            method: .get,
            body: nil,
            queryParameters: [
                URLQueryItem(name: "set", value: set),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        )
    }
}

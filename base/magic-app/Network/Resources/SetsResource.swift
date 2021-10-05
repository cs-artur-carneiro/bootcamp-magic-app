import Foundation
import MagicNetwork

enum SetsResource {
    static var all: Resource {
        return Resource(url: "https://api.magicthegathering.io/v1/sets",
                        method: .get,
                        body: nil)
    }
}

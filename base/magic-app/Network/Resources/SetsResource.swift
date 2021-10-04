import Foundation
import MagicNetwork

enum SetsResource {
    case all
}

extension SetsResource: Resource {
    var url: String {
        return "https://api.magicthegathering.io/v1/sets"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var body: Data? {
        return nil
    }
}

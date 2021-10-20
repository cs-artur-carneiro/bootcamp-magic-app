import Foundation

struct Card: Decodable {
    let name: String
    let set: String
    let imageUrl: String
    let id: String
    let type: String
}

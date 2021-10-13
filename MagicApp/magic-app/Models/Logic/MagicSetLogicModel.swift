import Foundation

struct MagicSetLogicModel: Equatable {
    let set: String
    let cards: [MagicSetLogicModel.Card]
    
    struct Card: Equatable {
        let name: String
        let set: String
        let imageUrl: String
        let id: String
        let type: String
        let isFavorite: Bool
    }
}

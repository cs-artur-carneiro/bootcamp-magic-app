import Foundation

struct MagicSetLogicModel: Equatable {
    let setId: String
    let setName: String
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

extension MagicSetLogicModel.Card {
    init(card: Card, isFavorite: Bool) {
        self.id = card.id
        self.name = card.name
        self.set = card.set
        self.type = card.type
        self.imageUrl = card.imageUrl
        self.isFavorite = isFavorite
    }
}

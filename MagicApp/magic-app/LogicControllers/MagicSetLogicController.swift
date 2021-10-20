import Foundation

protocol MagicSetLogicControllerProtocol {
    func update(_ model: MagicSetLogicModel, _ event: MagicSetLogicControllerEvent) -> MagicSetLogicControllerUpdate
}

struct MagicSetLogicController: MagicSetLogicControllerProtocol {
    func update(_ model: MagicSetLogicModel, _ event: MagicSetLogicControllerEvent) -> MagicSetLogicControllerUpdate {
        switch event {
        case .cardsRequested:
            return MagicSetLogicControllerUpdate(model: model, effect: .loadCards)
        case .cardsLoaded(let cards):
            let cards = cards.map { MagicSetLogicModel.Card(card: $0, isFavorite: false) }
            let model = MagicSetLogicModel(setId: model.setId, setName: model.setName, cards: cards)
            return MagicSetLogicControllerUpdate(model: model, effect: .none)
        case .cardsRequestFailed:
            return MagicSetLogicControllerUpdate(model: model, effect: .none)
        }
    }
}

enum MagicSetLogicControllerEvent {
    case cardsRequested
    case cardsLoaded([Card])
    case cardsRequestFailed
}

enum MagicSetLogicControllerEffect: Equatable {
    case loadCards
    case none
}

struct MagicSetLogicControllerUpdate: Equatable {
    let model: MagicSetLogicModel
    let effect: MagicSetLogicControllerEffect
}

import Foundation

protocol MagicSetLogicControllerProtocol {
    func update(_ model: MagicSetLogicModel, _ event: MagicSetLogicControllerEvent) -> MagicSetLogicControllerUpdate
}

struct MagicSetLogicController: MagicSetLogicControllerProtocol {
    func update(_ model: MagicSetLogicModel, _ event: MagicSetLogicControllerEvent) -> MagicSetLogicControllerUpdate {
        switch event {
        case .cardsRequested:
            return MagicSetLogicControllerUpdate(model: model, effect: .loadCards)
        case .cardsLoaded(let cards, let page, let total):
            return handleCardsLoaded(cards, atPage: page, ofTotal: total, with: model)
        case .cardsRequestFailed:
            return MagicSetLogicControllerUpdate(model: model, effect: .none)
        }
    }
    
    private func handleCardsLoaded(_ cards: [Card],
                                   atPage page: Int,
                                   ofTotal total: Int,
                                   with model: MagicSetLogicModel) -> MagicSetLogicControllerUpdate {
        guard !cards.isEmpty else {
            return MagicSetLogicControllerUpdate(model: model, effect: .none)
        }
        
        let cards = cards.map { MagicSetLogicModel.Card(card: $0, isFavorite: false) }
        let allCards = [cards, model.cards].flatMap { $0 }
        if allCards.count < total {
            let model = MagicSetLogicModel(setId: model.setId,
                                           setName: model.setName,
                                           cards: allCards,
                                           currentPage: page + 1,
                                           numberOfCards: total)
            return MagicSetLogicControllerUpdate(model: model, effect: .loadCards)
        } else {
            let model = MagicSetLogicModel(setId: model.setId,
                                           setName: model.setName,
                                           cards: allCards,
                                           currentPage: 0,
                                           numberOfCards: total)
            return MagicSetLogicControllerUpdate(model: model, effect: .none)
        }
    }
}

enum MagicSetLogicControllerEvent {
    case cardsRequested
    case cardsLoaded([Card], atPage: Int, ofTotal: Int)
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

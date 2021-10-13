import Foundation

struct MagicSetLogicController {
    func update(_ model: MagicSetLogicModel, _ event: Event) -> Update {
        switch event {
        case .cardsRequested:
            return Update(model: model, effect: .loadCards)
        }
    }
    
    enum Event {
        case cardsRequested
    }
    
    enum Effect: Equatable {
        case loadCards
        case none
    }
    
    struct Update: Equatable {
        let model: MagicSetLogicModel
        let effect: Effect
    }
}

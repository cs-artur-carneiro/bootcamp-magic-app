import Foundation

protocol MagicSetLogicControllerProtocol {
    func update(_ model: MagicSetLogicModel, _ event: MagicSetLogicControllerEvent) -> MagicSetLogicControllerUpdate
}

struct MagicSetLogicController: MagicSetLogicControllerProtocol {
    func update(_ model: MagicSetLogicModel, _ event: MagicSetLogicControllerEvent) -> MagicSetLogicControllerUpdate {
        switch event {
        case .cardsRequested:
            return MagicSetLogicControllerUpdate(model: model, effect: .loadCards)
        }
    }
}

enum MagicSetLogicControllerEvent {
    case cardsRequested
}

enum MagicSetLogicControllerEffect: Equatable {
    case loadCards
    case none
}

struct MagicSetLogicControllerUpdate: Equatable {
    let model: MagicSetLogicModel
    let effect: MagicSetLogicControllerEffect
}

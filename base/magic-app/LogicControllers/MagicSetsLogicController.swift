import Foundation

struct MagicSetsLogicController {
    func update(_ model: MagicSetsLogicModel, _ event: Event) -> (model: MagicSetsLogicModel, effect: Effect) {
        switch event {
        case .setsRequested:
            return (model: model, effect: .loadSets)
        case .setsLoaded(let sets):
            let model = MagicSetsLogicModel(sets: sets, canFetch: model.canFetch)
            return (model: model, effect: .none)
        case .setsRequestFailed:
            return (model: model, effect: .none)
        case .connectionLost:
            return (model: model, effect: .none)
        }
    }
    
    enum Event {
        case setsRequested
        case setsLoaded([MagicSet])
        case setsRequestFailed
        case connectionLost
    }

    enum Effect {
        case loadSets
        case none
    }
}

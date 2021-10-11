import Foundation

struct MagicSetsLogicController {
    func update(_ model: MagicSetsLogicModel, _ event: Event) -> Update {
        switch event {
        case .setSelected(let index):
            return Update(model: model, effect: .loadSet(at: index))
        case .setsRequested:
            return Update(model: model, effect: .loadSets)
        case .setsLoaded(let sets):
            let model = MagicSetsLogicModel(sets: sets, canFetch: model.canFetch)
            return Update(model: model, effect: .none)
        case .setsRequestFailed:
            return Update(model: model, effect: .none)
        case .connectionLost:
            let model = MagicSetsLogicModel(sets: model.sets, canFetch: false)
            return Update(model: model, effect: .none)
        }
    }
    
    enum Event {
        case setSelected(IndexPath)
        case setsRequested
        case setsLoaded([MagicSet])
        case setsRequestFailed
        case connectionLost
    }

    enum Effect: Equatable {
        case loadSet(at: IndexPath)
        case loadSets
        case none
    }
    
    struct Update: Equatable {
        let model: MagicSetsLogicModel
        let effect: Effect
    }
}

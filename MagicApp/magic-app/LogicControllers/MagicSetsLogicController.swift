import Foundation

protocol MagicSetsLogicControllerProtocol {
    func update(_ model: MagicSetsLogicModel, _ event: MagicSetsLogicControllerEvent) -> MagicSetsLogicControllerUpdate
}

struct MagicSetsLogicController: MagicSetsLogicControllerProtocol {
    func update(_ model: MagicSetsLogicModel, _ event: MagicSetsLogicControllerEvent) -> MagicSetsLogicControllerUpdate {
        switch event {
        case .setSelected(let index):
            return MagicSetsLogicControllerUpdate(model: model, effect: .loadSet(at: index))
        case .setsRequested:
            return MagicSetsLogicControllerUpdate(model: model, effect: .loadSets)
        case .setsLoaded(let sets):
            guard !sets.isEmpty else {
                return MagicSetsLogicControllerUpdate(model: model, effect: .displayError("No expansions have been found."))
            }
            let model = MagicSetsLogicModel(sets: sets, canFetch: model.canFetch)
            return MagicSetsLogicControllerUpdate(model: model, effect: .none)
        case .setsRequestFailed:
            return MagicSetsLogicControllerUpdate(model: model, effect: .displayError("Request for expansions failed. Check your internet connection and try again."))
        case .connectionLost:
            let model = MagicSetsLogicModel(sets: model.sets, canFetch: false)
            return MagicSetsLogicControllerUpdate(model: model, effect: .none)
        }
    }
}

enum MagicSetsLogicControllerEvent {
    case setSelected(IndexPath)
    case setsRequested
    case setsLoaded([MagicSet])
    case setsRequestFailed
    case connectionLost
}

enum MagicSetsLogicControllerEffect: Equatable {
    case loadSet(at: IndexPath)
    case loadSets
    case displayError(String)
    case none
}

struct MagicSetsLogicControllerUpdate: Equatable {
    let model: MagicSetsLogicModel
    let effect: MagicSetsLogicControllerEffect
}

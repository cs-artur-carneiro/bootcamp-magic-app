import Foundation
import MagicNetwork
import Combine

protocol MagicSetsViewModelInput: AnyObject {
    func requestSets()
}

final class MagicSetsViewModel {
    private let network: MagicNetworkProtocol
    private let logicController: MagicSetsLogicController
    private var model: MagicSetsLogicModel = MagicSetsLogicModel(sets: [], canFetch: true)
    
    init(network: MagicNetworkProtocol = MagicNetwork(),
         logicController: MagicSetsLogicController = MagicSetsLogicController()) {
        self.network = network
        self.logicController = logicController
    }
    
    private func handle(update: MagicSetsLogicController.Update) {
        switch update.effect {
        case .loadSets:
            model = update.model
            loadSets()
        case .none:
            model = update.model
            sets = model.sets.sorted(by: { $0.name < $1.name })
        }
    }
    
    private func handle(event: MagicSetsLogicController.Event) {
        let update = logicController.update(model, event)
        handle(update: update)
    }
    
    private func loadSets() {
        network.request(SetsResource.all, ofType: MagicSetResponse.self) { [weak self] result in
            switch result {
            case .success(let sets):
                if let sets = sets {
                    self?.handle(event: .setsLoaded(sets.sets))
                } else {
                    // TODO: Pensar em um evento para quando não retornar sets
                }
            case .failure:
                self?.handle(event: .setsRequestFailed)
            }
        }
    }
    
    @Published private(set) var sets: [MagicSet] = []
}

extension MagicSetsViewModel: MagicSetsViewModelInput {
    func requestSets() {
        let update = logicController.update(model, .setsRequested)
        handle(update: update)
    }
    
}

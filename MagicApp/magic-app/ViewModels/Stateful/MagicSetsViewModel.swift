import Foundation
import MagicNetwork
import Combine

protocol StatefulViewModel: AnyObject {}

protocol MagicSetsViewModelProtocol: StatefulViewModel {
    func requestSets()
    func setSelected(at index: IndexPath)
    var sets: Published<[MagicSetsListViewModel]>.Publisher { get }
    
}

final class MagicSetsViewModel {
    private let network: MagicNetworkProtocol
    private let logicController: MagicSetsLogicController
    private var model: MagicSetsLogicModel = MagicSetsLogicModel(sets: [], canFetch: true)
    @Published private var setsViewModels: [MagicSetsListViewModel] = []
    
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
            setsViewModels = map(sets: model.sets)
        }
    }
    
    private func handle(event: MagicSetsLogicController.Event) {
        let update = logicController.update(model, event)
        handle(update: update)
    }
    
    private func map(sets: [MagicSet]) -> [MagicSetsListViewModel] {
        let initials = Set(sets.compactMap { $0.name.first }).sorted(by: <)
        
        return initials.map { header in
            var setsCount = 0
            let setsForHeader = sets.filter { $0.name.first == header }
            let sets = setsForHeader.map { (set) -> MagicSetsCellViewModel in
                setsCount += 1
                return MagicSetsCellViewModel(title: set.name, lastInSection: setsCount == setsForHeader.count)
            }
            
            let section = MagicSetsSection(title: String(header).uppercased())
            
            return MagicSetsListViewModel(section: section, sets: sets)
        }
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
}

extension MagicSetsViewModel: MagicSetsViewModelProtocol {
    func requestSets() {
        let update = logicController.update(model, .setsRequested)
        handle(update: update)
    }
    
    func setSelected(at index: IndexPath) {
    }
    
    var sets: Published<[MagicSetsListViewModel]>.Publisher {
        return $setsViewModels
    }
}

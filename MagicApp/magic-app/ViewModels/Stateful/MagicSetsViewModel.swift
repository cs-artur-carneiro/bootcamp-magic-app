import Foundation
import MagicNetwork
import Combine

protocol MagicSetsViewModelProtocol: StatefulViewModel {
    func requestSets()
    func setSelected(at index: IndexPath)
    var sets: Published<[MagicSetsListViewModel]>.Publisher { get }
    var selectedSet: PassthroughSubject<MagicSetsCellViewModel, Never> { get }
}

final class MagicSetsViewModel {
    private let network: MagicNetworkProtocol
    private let logicController: MagicSetsLogicController
    private var model: MagicSetsLogicModel = MagicSetsLogicModel(sets: [], canFetch: true)
    @Published private var setsViewModelsPublisher: [MagicSetsListViewModel] = []
    private var selectedSetSubject = PassthroughSubject<MagicSetsCellViewModel, Never>()
    
    init(network: MagicNetworkProtocol = MagicNetwork(),
         logicController: MagicSetsLogicController = MagicSetsLogicController()) {
        self.network = network
        self.logicController = logicController
    }
    
    private func handle(update: MagicSetsLogicController.Update) {
        switch update.effect {
        case .loadSet(at: let index):
            model = update.model
            selectedSetSubject.send(setsViewModelsPublisher[index.section].sets[index.row])
        case .loadSets:
            model = update.model
            loadSets()
        case .none:
            model = update.model
            setsViewModelsPublisher = map(sets: model.sets)
        }
    }
    
    private func handle(event: MagicSetsLogicController.Event) {
        let update = logicController.update(model, event)
        handle(update: update)
    }
    
    private func map(sets: [MagicSet]) -> [MagicSetsListViewModel] {
        let initials = Set(sets.compactMap { (sets) -> Character? in
            guard let char = sets.name.first else { return nil }
            if char.isLetter {
                return char
            } else if char.isNumber {
                return "#"
            } else {
                return nil
            }
        }).sorted(by: <)
        
        return order(sets: sets, basedOn: initials)
    }
    
    private func order(sets: [MagicSet], basedOn initials: [Character]) -> [MagicSetsListViewModel] {
        var sectionIds: Int = -1
        return initials.map { header in
            var setsCount: Int = -1
            let setsForHeader = sets.filter {
                if header == "#" {
                    guard let firstCharacter = $0.name.first else { return false }
                    return firstCharacter.isNumber || !firstCharacter.isLetter
                } else {
                    return $0.name.first == header
                }
            }.sorted(by: { $0.name < $1.name } )
            
            let sets = setsForHeader.map { (set) -> MagicSetsCellViewModel in
                setsCount += 1
                return MagicSetsCellViewModel(id: setsCount,
                                              title: set.name,
                                              lastInSection: setsCount == setsForHeader.count - 1)
            }
            
            sectionIds += 1
            
            let section = MagicSetsSection(id: sectionIds, title: String(header).uppercased())
            
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
        handle(event: .setsRequested)
    }
    
    func setSelected(at index: IndexPath) {
        handle(event: .setSelected(index))
    }
    
    var sets: Published<[MagicSetsListViewModel]>.Publisher {
        return $setsViewModelsPublisher
    }
    
    var selectedSet: PassthroughSubject<MagicSetsCellViewModel, Never> {
        return selectedSetSubject
    }
}

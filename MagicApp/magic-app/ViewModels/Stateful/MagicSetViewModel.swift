import Foundation
import MagicNetwork

protocol MagicSetViewModelProtocol: StatefulViewModel {
    func fetchCards()
    var cardsPublisher: Published<[MagicSetListViewModel]>.Publisher { get }
    var setName: String { get }
    var state: Published<MagicSetState>.Publisher { get }
}

final class MagicSetViewModel  {
    private let network: MagicNetworkProtocol
    private let logicController: MagicSetLogicControllerProtocol
    private var model: MagicSetLogicModel
    @Published private var listViewModel: [MagicSetListViewModel] = []
    @Published private var statePublisher: MagicSetState = .loading
    
    init(setModel: MagicSetLogicModel,
         network: MagicNetworkProtocol = MagicNetwork(),
         logicController: MagicSetLogicControllerProtocol = MagicSetLogicController()) {
        self.model = setModel
        self.network = network
        self.logicController = logicController
    }
    
    private func loadCards(from set: String, atPage page: Int) {
        network.request(CardsResource.cards(from: set, atPage: model.currentPage), ofType: CardsResponse.self) { [weak self] (result) in
            switch result {
            case .success(let response):
                if let cardResponse = response.data,
                   let numberOfCards = Int(response.metadata?["total-count"] as? String ?? "") {
                    self?.handle(event: .cardsLoaded(cardResponse.cards, atPage: page, ofTotal: numberOfCards))
                } else {
                    self?.handle(event: .cardsLoaded([], atPage: 1, ofTotal: 0))
                }
            case .failure:
                self?.handle(event: .cardsRequestFailed)
            }
        }
    }
    
    private func handle(update: MagicSetLogicControllerUpdate) {
        switch update.effect {
        case .loadCards:
            model = update.model
            statePublisher = .loading
            loadCards(from: model.setId, atPage: model.currentPage)
        case .displayError(let message):
            model = update.model
            statePublisher = .error(message)
        case .none:
            statePublisher = .usable
            model = update.model
            listViewModel = map(cards: model.cards)
        }
    }
    
    private func handle(event: MagicSetLogicControllerEvent) {
        let update = logicController.update(model, event)
        handle(update: update)
    }
    
    private func map(cards: [MagicSetLogicModel.Card]) -> [MagicSetListViewModel] {
        let types = uniqueTypes(from: cards)
        return makeListViewModel(from: cards, usingTypes: types)
    }
    
    private func uniqueTypes(from cards: [MagicSetLogicModel.Card]) -> [String] {
        let types: [String] = cards.map { [weak self] in self?.format(type: $0.type) ?? $0.type }
        return Set(types).sorted(by: <)
    }
    
    private func makeListViewModel(from cards: [MagicSetLogicModel.Card], usingTypes types: [String]) -> [MagicSetListViewModel] {
        var sectionId: Int = -1
        return types.map { [weak self] type in
            let cardsForHeader = cards
                .filter { self?.format(type: $0.type) == type }
                .sorted(by: { $0.name < $1.name })
            
            let cards: [MagicSetCardCellViewModel] = cardsForHeader.map {
                MagicSetCardCellViewModel(id: $0.id,
                                          imageUrl: $0.imageUrl,
                                          isFavorite: $0.isFavorite)
            }
            
            sectionId += 1
            let section = MagicSetSection(id: sectionId, name: type)
            return MagicSetListViewModel(section: section, cards: cards)
        }
    }
    
    private func format(type: String) -> String? {
        let split = type.split(separator: "—")
        let spaceSplit = split.first?.split(separator: " ")
        let hasExtraSpace = spaceSplit?.last == " "
        if hasExtraSpace {
            return spaceSplit?.dropLast().joined(separator: " ")
        } else {
            return spaceSplit?.joined(separator: " ")
        }
    }
}

extension MagicSetViewModel: MagicSetViewModelProtocol {
    func fetchCards() {
        let update = logicController.update(model, .cardsRequested)
        handle(update: update)
    }
    
    var cardsPublisher: Published<[MagicSetListViewModel]>.Publisher {
        return $listViewModel
    }
    
    var state: Published<MagicSetState>.Publisher {
        return $statePublisher
    }
    
    var setName: String {
        return model.setName
    }
}

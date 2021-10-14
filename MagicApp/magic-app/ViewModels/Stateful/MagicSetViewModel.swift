import Foundation
import MagicNetwork

protocol MagicSetViewModelProtocol: StatefulViewModel {
    func fetchCards()
}

final class MagicSetViewModel  {
    private let network: MagicNetworkProtocol
    private let logicController: MagicSetLogicControllerProtocol
    private var model: MagicSetLogicModel

    init(set: String,
         network: MagicNetworkProtocol = MagicNetwork(),
         logicController: MagicSetLogicControllerProtocol = MagicSetLogicController()) {
        self.model = MagicSetLogicModel(set: set, cards: [])
        self.network = network
        self.logicController = logicController
    }
    
    private func loadCards(from set: String) {
        network.request(CardsResource.cards(from: set), ofType: CardsResponse.self) { (result) in
            switch result {
            case .success:
                break
            case .failure:
                break
            }
        }
    }
    
    private func handle(update: MagicSetLogicControllerUpdate) {
        switch update.effect {
        case .loadCards:
            model = update.model
            loadCards(from: model.set)
        case .none:
            model = update.model
        }
    }
}

extension MagicSetViewModel: MagicSetViewModelProtocol {
    func fetchCards() {
        let update = logicController.update(model, .cardsRequested)
        handle(update: update)
    }
}

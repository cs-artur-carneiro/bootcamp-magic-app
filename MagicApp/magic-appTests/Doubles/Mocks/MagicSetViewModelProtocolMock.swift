import MagicMock
import Combine
@testable import magic_app

final class MagicSetViewModelProtocolMock: MagicSetViewModelProtocol, MagicMock {
    typealias Action = MagicSetViewModelProtocolMockAction
    typealias Arrangement = MagicSetViewModelProtocolMockArrangement
    
    @Published private var listViewModel: [MagicSetListViewModel] = []
    private var requestedCards: [MagicSetListViewModel]?
    private var setInfo: (name: String, id: String)? = nil
    
    var actions: [MagicSetViewModelProtocolMockAction] = []
    
    func setUp() -> ArrangementProxy<MagicSetViewModelProtocolMockArrangement> {
        let proxy = ArrangementProxy<MagicSetViewModelProtocolMockArrangement>([]) { [weak self] arrangements in
            arrangements.forEach {
                switch $0 {
                case .cards(let viewModels):
                    self?.requestedCards = viewModels
                case .set(let name, let id):
                    self?.setInfo = (name, id)
                }
            }
        }
        return proxy
    }
    
    func clearArrangements() {
        listViewModel = []
        setInfo = nil
    }
    
    func fetchCards() {
        actions.append(.requestCards)
        if let cards = requestedCards {
            listViewModel = cards
        }
    }
    
    var cardsPublisher: Published<[MagicSetListViewModel]>.Publisher {
        return $listViewModel
    }
    
    var setName: String {
        return setInfo?.name ?? ""
    }
}

enum MagicSetViewModelProtocolMockAction: Equatable {
    case requestCards
}

enum MagicSetViewModelProtocolMockArrangement {
    case set(name: String, id: String)
    case cards([MagicSetListViewModel])
}

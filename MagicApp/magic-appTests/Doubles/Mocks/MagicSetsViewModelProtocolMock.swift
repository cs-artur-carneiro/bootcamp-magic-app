import MagicMock
import Foundation
import Combine
@testable import magic_app

final class MagicSetsViewModelProtocolMock: MagicMock {
    typealias Action = MagicSetsViewModelProtocolMockAction
    typealias Arrangement = MagicSetsViewModelProtocolMockArrangement
    
    @Published private var setsViewModels: [MagicSetsListViewModel] = []
    private var selectedSetPublisher = PassthroughSubject<MagicSetsCellViewModel, Never>()
    private var requestedSets: [MagicSetsListViewModel]?
    
    var actions: [MagicSetsViewModelProtocolMockAction] = []
    
    func setUp() -> ArrangementProxy<MagicSetsViewModelProtocolMockArrangement> {
        let proxy = ArrangementProxy<MagicSetsViewModelProtocolMockArrangement>([]) { arrangements in
            arrangements.forEach {
                switch $0 {
                case .sets(let sets):
                    self.requestedSets = sets
                }
            }
        }
        
        return proxy
    }
    
    func clearArrangements() {
        setsViewModels = []
        requestedSets = nil
    }
}

extension MagicSetsViewModelProtocolMock: MagicSetsViewModelProtocol {
    func requestSets() {
        actions.append(.requestSets)
        if let sets = requestedSets {
            setsViewModels = sets
        }
    }
    
    func setSelected(at index: IndexPath) {
        actions.append(.setSelected(index))
        selectedSetPublisher.send(setsViewModels[index.section].sets[index.row])
    }
    
    var sets: Published<[MagicSetsListViewModel]>.Publisher {
        return $setsViewModels
    }
    
    var selectedSet: Publishers.ReceiveOn<PassthroughSubject<MagicSetsCellViewModel, Never>, RunLoop> {
        return selectedSetPublisher
            .receive(on: RunLoop.main)
    }
}

enum MagicSetsViewModelProtocolMockAction: Equatable {
    case requestSets
    case setSelected(IndexPath)
    
    static func == (lhs: MagicSetsViewModelProtocolMockAction, rhs: MagicSetsViewModelProtocolMockAction) -> Bool {
        switch (lhs, rhs) {
        case (.requestSets, .setSelected),
             (.setSelected, .requestSets):
            return false
        default:
            return lhs == rhs
        }
    }
}

enum MagicSetsViewModelProtocolMockArrangement {
    case sets([MagicSetsListViewModel])
}

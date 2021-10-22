import MagicMock
import Foundation
import Combine
@testable import magic_app

final class MagicSetsViewModelProtocolMock: MagicMock {
    typealias Action = MagicSetsViewModelProtocolMockAction
    typealias Arrangement = MagicSetsViewModelProtocolMockArrangement
    
    @Published private var setsViewModels: [MagicSetsListViewModel] = []
    @Published private var statePublisher: MagicSetsState = .loading
    private var selectedSetPublisher = PassthroughSubject<MagicSetsCellViewModel, Never>()
    private var requestedSets: [MagicSetsListViewModel]?
    
    var actions: [MagicSetsViewModelProtocolMockAction] = []
    
    func setUp() -> ArrangementProxy<MagicSetsViewModelProtocolMockArrangement> {
        let proxy = ArrangementProxy<MagicSetsViewModelProtocolMockArrangement>([]) { arrangements in
            arrangements.forEach {
                switch $0 {
                case .sets(let sets):
                    self.requestedSets = sets
                case .state(let state):
                    self.statePublisher = state
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
    var state: Published<MagicSetsState>.Publisher {
        return $statePublisher
    }
    
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
    
    var selectedSet: PassthroughSubject<MagicSetsCellViewModel, Never> {
        return selectedSetPublisher
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
        case (.requestSets, .requestSets):
            return true
        case (.setSelected(let lhsIndex),
              .setSelected(let rhsIndex)):
            return lhsIndex == rhsIndex
        }
    }
}

enum MagicSetsViewModelProtocolMockArrangement {
    case sets([MagicSetsListViewModel])
    case state(MagicSetsState)
}

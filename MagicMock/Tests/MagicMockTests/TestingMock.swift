import Foundation
import MagicMock

final class TestingMock: MagicMock {
    typealias Action = TestingMockAction
    typealias Arrangement = TestingMockArrangement
    
    private var addition: Int?
    private var thought: String?
    
    var actions: [TestingMockAction] = []
    
    func setUp() -> ArrangementProxy<TestingMockArrangement> {
        let proxy = ArrangementProxy<TestingMockArrangement>([]) { _ in }
        
        return proxy
    }
    
    func clearArrangements() {
        addition = nil
        thought = nil
    }
}

enum TestingMockAction: Equatable {
    case add(Int)
    case think(String)
}

enum TestingMockArrangement {
    case addition(Int?)
    case thought(String?)
}

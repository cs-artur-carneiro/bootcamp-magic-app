import Foundation
import MagicMock

final class TestingMock: MagicMock {
    typealias Action = TestingMockAction
    typealias Arrangement = TestingMockArrangement
    
    private var addition: Int?
    private var thought: String?
    
    var actions: [TestingMockAction] = []
    
    func setUp() -> ArrangementProxy<TestingMockArrangement> {
        let proxy = ArrangementProxy<TestingMockArrangement>([]) { arrangements in
            arrangements.forEach {
                switch $0 {
                case .addition(let addition):
                    self.addition = addition
                case .thought(let thought):
                    self.thought = thought
                }
            }
        }
        
        return proxy
    }
    
    func clearArrangements() {
        addition = nil
        thought = nil
    }
    
    func add(_ number: Int) {
        actions.append(.add(number))
        if let addition = addition {
            self.addition = addition + number
        }
    }
    
    func think(_ thought: String) {
        actions.append(.think(thought))
        if let currentThought = self.thought {
            self.thought = "\(currentThought)-\(thought)"
        }
    }
    
    func state() -> (Int?, String?) {
        return (addition, thought)
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

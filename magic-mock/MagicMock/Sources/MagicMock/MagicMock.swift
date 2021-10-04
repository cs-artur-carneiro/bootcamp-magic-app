public protocol MagicMock: AnyObject {
    associatedtype Action: Equatable
    associatedtype Arrangement
    var actions: [Action] { get set }
    func setUp() -> ArrangementProxy<Arrangement>
    func clearArrangements()
    func clearActions()
    func assert(_ actions: [Action]) -> Bool
}

public extension MagicMock {
    func clearActions() {
        actions = []
    }
    
    func assert(_ actions: [Action]) -> Bool {
        return actions == self.actions
    }
}

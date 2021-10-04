import Foundation

public struct ArrangementProxy<T> {
    let arrangements: [T]
    let executionHandler: ([T]) -> Void
    
    public init(_ arrangements: [T], executionHandler: @escaping ([T]) -> Void) {
        self.arrangements = arrangements
        self.executionHandler = executionHandler
    }
    
    public func act(_ arrangement: T) -> ArrangementProxy<T> {
        var mutableArrangements = arrangements
        mutableArrangements.append(arrangement)
        return ArrangementProxy<T>(mutableArrangements, executionHandler: executionHandler)
    }
    
    public func execute() {
        executionHandler(arrangements)
    }
}

import Foundation

public protocol Resource {
    var url: String { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
    var headers: [String: String]? { get }
    var successCodeRange: ClosedRange<Int> { get }
}

public extension Resource {
    var successCodeRange: ClosedRange<Int> {
        return 200...299
    }
    
    var headers: [String: String]? {
        return nil
    }
}

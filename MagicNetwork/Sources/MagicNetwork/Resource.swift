import Foundation

public struct Resource: Equatable {
    let url: String
    let method: HTTPMethod
    let body: Data?
    let headers: [String: String]?
    let successCodeRange: ClosedRange<Int>
    
    public init(url: String,
                method: HTTPMethod = .get,
                body: Data? = nil,
                headers: [String: String]? = nil,
                successCodeRange: ClosedRange<Int> = 200...299) {
        self.url = url
        self.method = method
        self.body = body
        self.headers = headers
        self.successCodeRange = successCodeRange
    }
}

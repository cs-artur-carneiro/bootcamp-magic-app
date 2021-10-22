import Foundation

public struct Resource: Equatable {
    let url: String
    let method: HTTPMethod
    let body: Data?
    let headers: [String: String]?
    let queryParameters: [URLQueryItem]?
    let successCodeRange: ClosedRange<Int>
    
    public init(url: String,
                method: HTTPMethod = .get,
                body: Data? = nil,
                headers: [String: String]? = nil,
                queryParameters: [URLQueryItem]? = nil,
                successCodeRange: ClosedRange<Int> = 200...299) {
        self.url = url
        self.method = method
        self.body = body
        self.headers = headers
        self.queryParameters = queryParameters
        self.successCodeRange = successCodeRange
    }
}

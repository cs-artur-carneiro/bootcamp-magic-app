import Foundation
import MagicNetwork
import MagicMock

final class HTTPServiceMock: HTTPService, MagicMock {
    typealias Action = HTTPServiceMockAction
    typealias Arrangement = HTTPServiceMockArrangement
    
    var actions: [Action] = []
    
    private var data: Data?
    private var urlResponse: URLResponse?
    private var error: Error?

    func setUp() -> ArrangementProxy<Arrangement> {
        let proxy = ArrangementProxy<Arrangement>([]) { [weak self] arrangements in
            arrangements.forEach { [weak self] in
                switch $0 {
                case .data(let data):
                    self?.data = data
                case .urlResponse(let response):
                    self?.urlResponse = response
                case .error(let error):
                    self?.error = error
                }
            }
        }
        return proxy
    }
    
    func clearArrangements() {
        data = nil
        urlResponse = nil
        error = nil
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        actions.append(.request(request))
        actions.append(.payload(data, urlResponse, error))
        completionHandler(data, urlResponse, error)
        clearArrangements()
        return URLSessionDataTaskDummy()
    }
}

// MARK: - Action
enum HTTPServiceMockAction: Equatable {
    case request(URLRequest)
    case payload(Data?, URLResponse?, Error?)
    
    static func == (lhs: HTTPServiceMockAction, rhs: HTTPServiceMockAction) -> Bool {
        switch (lhs, rhs) {
        case (.payload(let lhsData, let lhsResponse, let lhsError),
              .payload(let rhsData, let rhsResponse, let rhsError)):
            return lhsData == rhsData && lhsResponse == rhsResponse && (lhsError == nil) == (rhsError == nil)
        case (.request, payload):
            return false
        case (.payload, .request):
            return false
        case (.request(let lhsReq), .request(let rhsReq)):
            return lhsReq == rhsReq
        }
    }
}


// MARK: - Arrangement
enum HTTPServiceMockArrangement {
    case data(Data?)
    case urlResponse(URLResponse?)
    case error(Error?)
}

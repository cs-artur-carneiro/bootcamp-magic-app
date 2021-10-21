import MagicNetwork
import MagicMock
import Foundation

final class MagicNetworkProtocolMock: MagicNetworkProtocol, MagicMock {
    typealias Action = MagicNetworkProtocolMockAction
    typealias Arrangement = MagicNetworkProtocolMockArrangement
    
    var actions: [Action] = []
    
    private var result: Result<Decodable?, MagicNetworkError> = .failure(.requestFailed)
    private var responseHeaders: [AnyHashable: Any]?
    
    func setUp() -> ArrangementProxy<Arrangement> {
        let proxy = ArrangementProxy<Arrangement>([]) { arrangements in
            arrangements.forEach { [weak self] in
                switch $0 {
                case .result(let result):
                    self?.result = result
                case .responseHeaders(let headers):
                    self?.responseHeaders = headers
                }
            }
        }
        
        return proxy
    }
    
    func clearArrangements() {
        result = .failure(.requestFailed)
    }
    
    func request<T>(_ resource: Resource, ofType type: T.Type, completion: @escaping (Result<Response<T>, MagicNetworkError>) -> Void) where T : Decodable {
        actions.append(.request(resource))
        actions.append(.response(result))
        switch result {
        case .success(let response):
            if let response = response as? T {
                completion(.success(.init(data: response, metadata: responseHeaders)))
            } else {
                completion(.success(.init(data: nil, metadata: nil)))
            }
        case .failure(let error):
            completion(.failure(error))
        }
        clearArrangements()
    }
}

// MARK: - Action
enum MagicNetworkProtocolMockAction: Equatable {
    case request(Resource)
    case response(Result<Decodable?, MagicNetworkError>)
    
    static func == (lhs: MagicNetworkProtocolMockAction, rhs: MagicNetworkProtocolMockAction) -> Bool {
        switch (lhs, rhs) {
        case (.response, request):
            return false
        case (.request, .response):
            return false
        case (.response(let lhsResult), .response(let rhsResult)):
            // TODO: Pensar em algo melhor para comparação em caso de successo
            switch (lhsResult, rhsResult) {
            case (.success(let lhsValue),
                  .success(let rhsValue)):
                return (lhsValue != nil) == (rhsValue != nil)
            case (.success, .failure):
                return false
            case (.failure, .success):
                return false
            case (.failure(let lhsError), .failure(let rhsError)):
                return lhsError == rhsError
            }
        case (.request(let lhsResource), .request(let rhsResource)):
            return lhsResource == rhsResource
        }
    }
}

// MARK: - Arrangement
enum MagicNetworkProtocolMockArrangement {
    case responseHeaders([AnyHashable: Any]?)
    case result(Result<Decodable?, MagicNetworkError>)
}

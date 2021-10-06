import MagicNetwork
import MagicMock
import Foundation

final class MagicNetworkProtocolMock: MagicNetworkProtocol, MagicMock {
    typealias Action = MagicNetworkProtocolMockAction
    typealias Arrangement = MagicNetworkProtocolMockArrangement
    
    var actions: [Action] = []
    
    private var result: Result<Decodable?, MagicNetworkError> = .failure(.requestFailed)
    
    func setUp() -> ArrangementProxy<Arrangement> {
        let proxy = ArrangementProxy<Arrangement>([]) { arrangements in
            arrangements.forEach { [weak self] in
                switch $0 {
                case .result(let result):
                    self?.result = result
                }
            }
        }
        
        return proxy
    }
    
    func clearArrangements() {
        result = .failure(.requestFailed)
    }
    
    func request<T>(_ resource: Resource, ofType type: T.Type, completion: @escaping (Result<T?, MagicNetworkError>) -> Void) where T : Decodable {
        actions.append(.request(resource))
        actions.append(.response(result))
        switch result {
        case .success(let value):
            if let value = value as? T {
                completion(.success(value))
            } else {
                completion(.success(nil))
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
    case result(Result<Decodable?, MagicNetworkError>)
}

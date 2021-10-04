import Foundation

public enum MagicNetworkError: Error {
    case invalidResource
    case requestFailed
    case unexpectedResponseType
    case statusCodeOutOfSuccessRange
}

public protocol MagicNetworkProtocol {
    func request(_ resource: Resource, completion: @escaping (Result<Data, MagicNetworkError>) -> Void)
}

public struct MagicNetwork: MagicNetworkProtocol {
    private let http: HTTPService
    
    public init(http: HTTPService = URLSession.shared) {
        self.http = http
    }
    
    public func request(_ resource: Resource, completion: @escaping (Result<Data, MagicNetworkError>) -> Void) {
        guard let request = makeURLRequest(from: resource) else {
            return completion(.failure(.invalidResource))
        }
        
        http.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(.failure(.requestFailed))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                guard resource.successCodeRange ~= httpResponse.statusCode else {
                    return completion(.failure(.statusCodeOutOfSuccessRange))
                }
                
                guard let data = data else {
                    return completion(.success(Data()))
                }
                
                completion(.success(data))
            } else {
                completion(.failure(.unexpectedResponseType))
            }
        }.resume()
    }

    private func makeURLRequest(from resource: Resource) -> URLRequest? {
        guard let url = URL(string: resource.url) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = resource.method
        request.httpBody = resource.body
        resource.headers?.forEach {
            request.addValue($1, forHTTPHeaderField: $0)
        }
        
        return request
    }
}

public protocol HTTPService {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: HTTPService {}

public protocol Resource {
    var url: String { get }
    var method: String { get }
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

import Foundation

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
                return completion(.failure(.requestFailed))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                guard resource.successCodeRange ~= httpResponse.statusCode else {
                    return completion(.failure(.statusCodeOutOfSuccessRange))
                }
                
                guard let data = data else {
                    return completion(.success(Data()))
                }
                
                return completion(.success(data))
            } else {
                return completion(.failure(.unexpectedResponseType))
            }
        }.resume()
    }

    private func makeURLRequest(from resource: Resource) -> URLRequest? {
        guard let url = URL(string: resource.url) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = resource.method.rawValue
        request.httpBody = resource.body
        resource.headers?.forEach {
            request.addValue($1, forHTTPHeaderField: $0)
        }
        
        return request
    }
}

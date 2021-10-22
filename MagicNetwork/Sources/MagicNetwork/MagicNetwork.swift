import Foundation

public protocol MagicNetworkProtocol {
    func request<T: Decodable>(_ resource: Resource, ofType type: T.Type, completion: @escaping (Result<Response<T>, MagicNetworkError>) -> Void)
}

public struct MagicNetwork: MagicNetworkProtocol {
    private let http: HTTPService
    private let decoder: JSONDecoder
    
    public init(http: HTTPService = URLSession.shared,
                decoder: JSONDecoder = JSONDecoder()) {
        self.http = http
        self.decoder = decoder
    }
    
    public func request<T: Decodable>(_ resource: Resource, ofType type: T.Type, completion: @escaping (Result<Response<T>, MagicNetworkError>) -> Void) {
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
                    return completion(.success(Response(data: nil, metadata: httpResponse.allHeaderFields)))
                }
                
                do {
                    let decoded = try decoder.decode(T.self, from: data)
                    return completion(.success(Response(data: decoded, metadata: httpResponse.allHeaderFields)))
                } catch {
                    return completion(.failure(.decodingFailed))
                }
            } else {
                return completion(.failure(.unexpectedResponseType))
            }
        }.resume()
    }

    private func makeURLRequest(from resource: Resource) -> URLRequest? {
        guard !resource.url.isEmpty,
              var urlComponents = URLComponents(string: resource.url) else {
            return nil
        }
    
        urlComponents.queryItems = resource.queryParameters
        
        guard let url = urlComponents.url else {
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

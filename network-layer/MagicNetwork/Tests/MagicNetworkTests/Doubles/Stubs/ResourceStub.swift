import Foundation
import MagicNetwork

struct ResourceStub: Resource {
    var url: String
    
    var method: HTTPMethod
    
    var body: Data?
    
    init(url: String,
         method: HTTPMethod = .get,
         body: Data? = nil) {
        self.url = url
        self.method = method
        self.body = body
    }
}

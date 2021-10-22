import Foundation

public struct Response<T: Decodable> {
    public let data: T?
    public let metadata: [AnyHashable: Any]?
    
    public init(data: T?, metadata: [AnyHashable: Any]?) {
        self.data = data
        self.metadata = metadata
    }
}

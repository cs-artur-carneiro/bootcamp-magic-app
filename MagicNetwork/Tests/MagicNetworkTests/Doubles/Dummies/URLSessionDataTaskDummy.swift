import Foundation

final class URLSessionDataTaskDummy: URLSessionDataTask {
    init(name: String = "Dummy") {}
    
    override func resume() {}
}

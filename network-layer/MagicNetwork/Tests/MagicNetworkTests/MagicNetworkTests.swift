import XCTest
@testable import MagicNetwork

final class MagicNetworkTests: XCTestCase {
    var sut: MagicNetwork!
    var httpMock: HTTPServiceMock!
    
    override func setUp() {
        httpMock = HTTPServiceMock()
        sut = MagicNetwork(http: httpMock)
    }
    
    override func tearDown() {
        httpMock = nil
        sut = nil
    }
    
    func test_request_when_itSucceeds() throws {
        let url = try XCTUnwrap(URL(string: "URL"))
        let expectedResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let expectedData = Data()
        
        httpMock
            .arrange()
            .act(.data(expectedData))
            .act(.urlResponse(expectedResponse))
            .act(.error(nil))
            .execute()
        
        
        let expectedActions: [HTTPServiceMockAction] = [.request(URLRequest(url: url)),
                                                        .payload(expectedData, expectedResponse, nil)]
        var dataFromResult: Data?
        
        sut.request(ResourceStub(url: "URL")) {
            if case .success(let result) = $0 {
                dataFromResult = result
            }
        }
        
        XCTAssertNotNil(dataFromResult)
        XCTAssertEqual(dataFromResult, expectedData)
        XCTAssertTrue(httpMock.assert(expectedActions))
    }
    
    func test_request_when_itSucceeds_withoutData() throws {
        let url = try XCTUnwrap(URL(string: "URL"))
        let expectedResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let expectedData = Data()
        
        httpMock
            .arrange()
            .act(.data(nil))
            .act(.urlResponse(expectedResponse))
            .act(.error(nil))
            .execute()
        
        
        let expectedActions: [HTTPServiceMockAction] = [.request(URLRequest(url: url)),
                                                        .payload(nil, expectedResponse, nil)]
        var dataFromResult: Data?
        
        sut.request(ResourceStub(url: "URL")) {
            if case .success(let result) = $0 {
                dataFromResult = result
            }
        }
        
        XCTAssertNotNil(dataFromResult)
        XCTAssertEqual(dataFromResult, expectedData)
        XCTAssertTrue(httpMock.assert(expectedActions))
    }
    
    func test_request_when_itFails_dueTo_invalidResource() throws {
        let expectedError = MagicNetworkError.invalidResource
        
        httpMock
            .arrange()
            .act(.data(nil))
            .act(.urlResponse(nil))
            .act(.error(MagicNetworkError.invalidResource))
            .execute()
        
        
        let expectedActions: [HTTPServiceMockAction] = []
        var errorFromResult: MagicNetworkError?
        
        sut.request(ResourceStub(url: "")) {
            if case .failure(let result) = $0 {
                errorFromResult = result
            }
        }
        
        XCTAssertNotNil(errorFromResult)
        XCTAssertEqual(errorFromResult, expectedError)
        XCTAssertTrue(httpMock.assert(expectedActions))
    }
    
    func test_request_when_itFails_dueTo_requestFailure() throws {
        let url = try XCTUnwrap(URL(string: "URL"))
        let expectedError = MagicNetworkError.requestFailed
        
        httpMock
            .arrange()
            .act(.data(nil))
            .act(.urlResponse(nil))
            .act(.error(NSError()))
            .execute()
        
        
        let expectedActions: [HTTPServiceMockAction] = [.request(URLRequest(url: url)),
                                                        .payload(nil, nil, NSError())]
        var errorFromResult: MagicNetworkError?
        
        sut.request(ResourceStub(url: "URL")) {
            if case .failure(let result) = $0 {
                errorFromResult = result
            }
        }
        
        XCTAssertNotNil(errorFromResult)
        XCTAssertEqual(errorFromResult, expectedError)
        XCTAssertTrue(httpMock.assert(expectedActions))
    }
    
    func test_request_when_itFails_dueTo_unexpectedResponseType() throws {
        let url = try XCTUnwrap(URL(string: "URL"))
        let expectedResponse = URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        let expectedError = MagicNetworkError.unexpectedResponseType
        
        httpMock
            .arrange()
            .act(.data(nil))
            .act(.urlResponse(expectedResponse))
            .act(.error(nil))
            .execute()
        
        
        let expectedActions: [HTTPServiceMockAction] = [.request(URLRequest(url: url)),
                                                        .payload(nil, expectedResponse, nil)]
        var errorFromResult: MagicNetworkError?
        
        sut.request(ResourceStub(url: "URL")) {
            if case .failure(let result) = $0 {
                errorFromResult = result
            }
        }
        
        XCTAssertNotNil(errorFromResult)
        XCTAssertEqual(errorFromResult, expectedError)
        XCTAssertTrue(httpMock.assert(expectedActions))
    }
    
    func test_request_when_itFails_dueTo_statusCodeOutOfSuccessRange() throws {
        let url = try XCTUnwrap(URL(string: "URL"))
        let expectedResponse = HTTPURLResponse(url: url, statusCode: 300, httpVersion: nil, headerFields: nil)
        let expectedError = MagicNetworkError.statusCodeOutOfSuccessRange
        
        httpMock
            .arrange()
            .act(.data(Data()))
            .act(.urlResponse(expectedResponse))
            .act(.error(nil))
            .execute()
        
        
        let expectedActions: [HTTPServiceMockAction] = [.request(URLRequest(url: url)),
                                                        .payload(Data(), expectedResponse, nil)]
        var errorFromResult: MagicNetworkError?
        
        sut.request(ResourceStub(url: "URL")) {
            if case .failure(let result) = $0 {
                errorFromResult = result
            }
        }
        
        XCTAssertNotNil(errorFromResult)
        XCTAssertEqual(errorFromResult, expectedError)
        XCTAssertTrue(httpMock.assert(expectedActions))
    }
}


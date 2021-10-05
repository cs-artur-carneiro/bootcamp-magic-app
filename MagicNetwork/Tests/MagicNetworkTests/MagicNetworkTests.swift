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
        let expectedDummy = DecodingDummy(dummy: true)
        let expectedData = try JSONEncoder().encode(expectedDummy)
        
        httpMock
            .setUp()
            .arrange(.data(expectedData))
            .arrange(.urlResponse(expectedResponse))
            .arrange(.error(nil))
            .execute()
        
        
        let expectedActions: [HTTPServiceMockAction] = [.request(URLRequest(url: url)),
                                                        .payload(expectedData, expectedResponse, nil)]
        var dataFromResult: DecodingDummy?
        
        sut.request(Resource(url: "URL"), ofType: DecodingDummy.self) {
            if case .success(let result) = $0 {
                dataFromResult = result
            }
        }
        
        XCTAssertNotNil(dataFromResult)
        XCTAssertEqual(dataFromResult, expectedDummy)
        XCTAssertTrue(httpMock.assert(expectedActions))
    }
    
    func test_request_when_itSucceeds_withoutData() throws {
        let url = try XCTUnwrap(URL(string: "URL"))
        let expectedResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        httpMock
            .setUp()
            .arrange(.data(nil))
            .arrange(.urlResponse(expectedResponse))
            .arrange(.error(nil))
            .execute()
        
        
        let expectedActions: [HTTPServiceMockAction] = [.request(URLRequest(url: url)),
                                                        .payload(nil, expectedResponse, nil)]
        var dataFromResult: Data?
        
        sut.request(Resource(url: "URL"), ofType: Data.self) {
            if case .success(let result) = $0 {
                dataFromResult = result
            }
        }
        
        XCTAssertNil(dataFromResult)
        XCTAssertTrue(httpMock.assert(expectedActions))
    }
    
    func test_request_when_itFails_dueTo_invalidResource() throws {
        let expectedError = MagicNetworkError.invalidResource
        
        httpMock
            .setUp()
            .arrange(.data(nil))
            .arrange(.urlResponse(nil))
            .arrange(.error(MagicNetworkError.invalidResource))
            .execute()
        
        
        let expectedActions: [HTTPServiceMockAction] = []
        var errorFromResult: MagicNetworkError?
        
        sut.request(Resource(url: ""), ofType: Data.self) {
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
            .setUp()
            .arrange(.data(nil))
            .arrange(.urlResponse(nil))
            .arrange(.error(NSError()))
            .execute()
        
        
        let expectedActions: [HTTPServiceMockAction] = [.request(URLRequest(url: url)),
                                                        .payload(nil, nil, NSError())]
        var errorFromResult: MagicNetworkError?
        
        sut.request(Resource(url: "URL"), ofType: Data.self) {
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
            .setUp()
            .arrange(.data(nil))
            .arrange(.urlResponse(expectedResponse))
            .arrange(.error(nil))
            .execute()
        
        
        let expectedActions: [HTTPServiceMockAction] = [.request(URLRequest(url: url)),
                                                        .payload(nil, expectedResponse, nil)]
        var errorFromResult: MagicNetworkError?
        
        sut.request(Resource(url: "URL"), ofType: Data.self) {
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
            .setUp()
            .arrange(.data(Data()))
            .arrange(.urlResponse(expectedResponse))
            .arrange(.error(nil))
            .execute()
        
        
        let expectedActions: [HTTPServiceMockAction] = [.request(URLRequest(url: url)),
                                                        .payload(Data(), expectedResponse, nil)]
        var errorFromResult: MagicNetworkError?
        
        sut.request(Resource(url: "URL"), ofType: Data.self) {
            if case .failure(let result) = $0 {
                errorFromResult = result
            }
        }
        
        XCTAssertNotNil(errorFromResult)
        XCTAssertEqual(errorFromResult, expectedError)
        XCTAssertTrue(httpMock.assert(expectedActions))
    }
}


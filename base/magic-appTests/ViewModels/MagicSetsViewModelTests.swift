import XCTest
import MagicNetwork
import MagicMock
import Combine
@testable import magic_app

final class MagicSetsViewModelTests: XCTestCase {
    var sut: MagicSetsViewModel!
    var networkMock: MagicNetworkProtocolMock!
    var cancellableStore: Set<AnyCancellable>!
    
    override func setUp() {
        networkMock = MagicNetworkProtocolMock()
        sut = MagicSetsViewModel(network: networkMock)
        cancellableStore = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        networkMock = nil
        sut = nil
        cancellableStore = nil
    }
    
    func test_requireSets_whenIt_succeeds() {
        let expectedValue = MagicSetResponse(sets: Array(repeating: MagicSet(name: "Teste"), count: 10))
        
        networkMock
            .setUp()
            .arrange(.result(.success(expectedValue)))
            .execute()
        
        let expectedActions: [MagicNetworkProtocolMockAction] = [.request(SetsResource.all),
                                                                 .response(.success(expectedValue))]
        
        sut.requestSets()
        
        XCTAssertTrue(networkMock.assert(expectedActions))
    }
    
    func test_requireSets_whenIt_fails() {
        let expectedError = MagicNetworkError.requestFailed
        
        networkMock
            .setUp()
            .arrange(.result(.failure(expectedError)))
            .execute()
        
        let expectedActions: [MagicNetworkProtocolMockAction] = [.request(SetsResource.all),
                                                                 .response(.failure(expectedError))]
        
        sut.requestSets()
        
        XCTAssertTrue(networkMock.assert(expectedActions))
    }
    
    func test_setsBinding_whenRequest_succeeds() {
        let expectedValue = MagicSetResponse(sets: Array(repeating: MagicSet(name: "Teste"), count: 10))
        
        networkMock
            .setUp()
            .arrange(.result(.success(expectedValue)))
            .execute()
        
        let expectation = XCTestExpectation(description: #function)
        
        var setsFromBinding: [[MagicSet]] = []
        
        sut.$sets.sink { sets in
            setsFromBinding.append(sets)
            expectation.fulfill()
        }.store(in: &cancellableStore)
        
        sut.requestSets()
        
        let expectedSecondValue = MagicSetResponse(sets: Array(repeating: MagicSet(name: "Teste"), count: 4))
        
        networkMock
            .setUp()
            .arrange(.result(.success(expectedSecondValue)))
            .execute()
        
        sut.requestSets()
        
        let expectedTimeline: [[MagicSet]] = [[], expectedValue.sets, expectedSecondValue.sets]
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertNotNil(setsFromBinding)
        XCTAssertEqual(setsFromBinding, expectedTimeline)
    }
    
    func test_setsBinding_whenRequest_fails() {
        let expectedError = MagicNetworkError.requestFailed
        
        networkMock
            .setUp()
            .arrange(.result(.failure(expectedError)))
            .execute()
        
        let expectation = XCTestExpectation(description: #function)
        
        var setsFromBinding: [[MagicSet]] = []
        
        sut.$sets.sink { sets in
            setsFromBinding.append(sets)
            expectation.fulfill()
        }.store(in: &cancellableStore)
        
        sut.requestSets()
        
        let expectedTimeline: [[MagicSet]] = [[], []]
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertNotNil(setsFromBinding)
        XCTAssertEqual(setsFromBinding, expectedTimeline)
    }
}

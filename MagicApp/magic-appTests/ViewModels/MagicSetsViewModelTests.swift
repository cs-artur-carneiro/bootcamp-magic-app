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
        let viewModelFactory = MagicSetsListViewModelFactory()
        let expectedFirstResult = MagicSetResponse(sets: [MagicSet(name: "Teste"),
                                                          MagicSet(name: "Teste"),
                                                          MagicSet(name: "10th Edition"),
                                                          MagicSet(name: "2017 Set")])
        
        networkMock
            .setUp()
            .arrange(.result(.success(expectedFirstResult)))
            .execute()
        
        let expectation = XCTestExpectation(description: #function)
        
        let firstViewModel = viewModelFactory.makeNumbersAndLetters()
        
        var viewModelsFromBinding: [[MagicSetsListViewModel]] = []
        
        sut.sets.sink { viewModels in
            viewModelsFromBinding.append(viewModels)
            expectation.fulfill()
        }.store(in: &cancellableStore)
        
        sut.requestSets()
        
        let expectedSecondResult = MagicSetResponse(sets: Array(repeating: MagicSet(name: "Exemplo"), count: 2))
        
        let secondViewModel = viewModelFactory.makeLettersOnly()
        
        networkMock
            .setUp()
            .arrange(.result(.success(expectedSecondResult)))
            .execute()
        
        sut.requestSets()
        
        let expectedTimeline: [[MagicSetsListViewModel]] = [[], firstViewModel, secondViewModel]
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(viewModelsFromBinding, expectedTimeline)
    }
    
    func test_setsBinding_whenRequest_fails() {
        let expectedError = MagicNetworkError.requestFailed
        
        networkMock
            .setUp()
            .arrange(.result(.failure(expectedError)))
            .execute()
        
        let expectation = XCTestExpectation(description: #function)
        
        var setsFromBinding: [[MagicSetsListViewModel]] = []
        
        sut.sets.sink { sets in
            setsFromBinding.append(sets)
            expectation.fulfill()
        }.store(in: &cancellableStore)
        
        sut.requestSets()
        
        let expectedTimeline: [[MagicSetsListViewModel]] = [[], []]
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(setsFromBinding, expectedTimeline)
    }
    
    func test_setSelected() {
        let expectedResult = MagicSetResponse(sets: [MagicSet(name: "Teste"),
                                                          MagicSet(name: "Teste"),
                                                          MagicSet(name: "10th Edition"),
                                                          MagicSet(name: "2017 Set")])
        
        networkMock
            .setUp()
            .arrange(.result(.success(expectedResult)))
            .execute()
        
        sut.requestSets()
        
        let expectation = XCTestExpectation(description: #function)
        
        var selectedSetFromBinding: [MagicSetsCellViewModel] = []
        
        sut.selectedSet
            .sink { (set) in
                selectedSetFromBinding.append(set)
                expectation.fulfill()
            }.store(in: &cancellableStore)
        
        sut.setSelected(at: IndexPath(row: 0, section: 0))
        
        let expectedTimeline = [MagicSetsCellViewModel(id: 0, title: "10th Edition", lastInSection: false)]
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(expectedTimeline, selectedSetFromBinding)
    }
}

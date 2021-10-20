import XCTest
import MagicNetwork
import Combine
@testable import magic_app

final class MagicSetViewModelTests: XCTestCase {
    var sut: MagicSetViewModel!
    var networkMock: MagicNetworkProtocolMock!
    var cancellableStore: Set<AnyCancellable>!
    
    override func setUp() {
        networkMock = MagicNetworkProtocolMock()
        sut = MagicSetViewModel(setId: "ID", setName: "NAME", network: networkMock)
        cancellableStore = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        networkMock = nil
        sut = nil
        cancellableStore = nil
    }
    
    func test_fetchCards_whenIt_succeeds() {
        let expectedResponse = CardsResponse(
            cards: [
                Card(name: "Carta", set: "NAME", imageUrl: "url", id: "AAA", type: "Creature"),
                Card(name: "Cartinha", set: "NAME", imageUrl: "url", id: "BBB", type: "Creature"),
                Card(name: "Card", set: "NAME", imageUrl: "url", id: "CCC", type: "Creature"),
                Card(name: "Big card", set: "NAME", imageUrl: "url", id: "DDD", type: "Creature"),
                Card(name: "Cartão", set: "NAME", imageUrl: "url", id: "EEE", type: "Creature")
            ]
        )
        
        networkMock
            .setUp()
            .arrange(.result(.success(expectedResponse)))
            .execute()
        
        let expectedActions: [MagicNetworkProtocolMockAction] = [.request(CardsResource.cards(from: "ID")),
                                                                 .response(.success(expectedResponse))]
        
        sut.fetchCards()
        
        XCTAssertTrue(networkMock.assert(expectedActions))
    }
    
    func test_fetchCards_whenIt_fails() {
        let expectedError = MagicNetworkError.requestFailed
        
        networkMock
            .setUp()
            .arrange(.result(.failure(expectedError)))
            .execute()
        
        let expectedActions: [MagicNetworkProtocolMockAction] = [.request(CardsResource.cards(from: "ID")),
                                                                 .response(.failure(expectedError))]
        
        sut.fetchCards()
        
        XCTAssertTrue(networkMock.assert(expectedActions))
    }
    
    func test_cardsBinding_whenRequest_succeeds() {
        let viewModelFactory = MagicSetListViewModelFactory()
        let expectedFirstResponse = CardsResponse(
            cards: [
                Card(name: "AAA", set: "NAME", imageUrl: "url", id: "AAA", type: "Creature"),
                Card(name: "BBB", set: "NAME", imageUrl: "url", id: "BBB", type: "Creature"),
                Card(name: "CCC", set: "NAME", imageUrl: "url", id: "CCC", type: "Creature")
            ]
        )
        
        networkMock
            .setUp()
            .arrange(.result(.success(expectedFirstResponse)))
            .execute()
        
        let expectation = XCTestExpectation(description: #function)
        
        let firstViewModel = viewModelFactory.makeCreatureOnly()
        
        var viewModelsFromBinding: [[MagicSetListViewModel]] = []
        
        sut.cardsPublisher.sink { viewModels in
            viewModelsFromBinding.append(viewModels)
            expectation.fulfill()
        }.store(in: &cancellableStore)
        
        sut.fetchCards()
        
        let expectedSecondReponse = CardsResponse(
            cards: [
                Card(name: "AAA", set: "NAME", imageUrl: "url", id: "AAA", type: "Creature"),
                Card(name: "BBB", set: "NAME", imageUrl: "url", id: "BBB", type: "Creature"),
                Card(name: "CCC", set: "NAME", imageUrl: "url", id: "CCC", type: "Creature"),
                Card(name: "TTT", set: "NAME", imageUrl: "url", id: "TTT", type: "Enchantment"),
                Card(name: "UUU", set: "NAME", imageUrl: "url", id: "UUU", type: "Enchantment"),
                Card(name: "VVV", set: "NAME", imageUrl: "url", id: "VVV", type: "Enchantment")
            ]
        )
        
        let secondViewModel = viewModelFactory.make()
        
        networkMock
            .setUp()
            .arrange(.result(.success(expectedSecondReponse)))
            .execute()
        
        sut.fetchCards()
        
        let expectedTimeline: [[MagicSetListViewModel]] = [[], firstViewModel, secondViewModel]
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(viewModelsFromBinding, expectedTimeline)
    }
    
    func test_cardsBinding_whenRequest_fails() {
        let expectedError = MagicNetworkError.requestFailed
        
        networkMock
            .setUp()
            .arrange(.result(.failure(expectedError)))
            .execute()
        
        let expectation = XCTestExpectation(description: #function)
        
        var viewModelsFromBinding: [[MagicSetListViewModel]] = []
        
        sut.cardsPublisher.sink { viewModels in
            viewModelsFromBinding.append(viewModels)
            expectation.fulfill()
        }.store(in: &cancellableStore)
        
        sut.fetchCards()
        
        let expectedTimeline: [[MagicSetListViewModel]] = [[], []]
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(viewModelsFromBinding, expectedTimeline)
    }
}

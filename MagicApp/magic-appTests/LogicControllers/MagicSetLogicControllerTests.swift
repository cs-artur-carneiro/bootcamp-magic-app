import XCTest
@testable import magic_app

final class MagicSetLogicControllerTests: XCTestCase {
    typealias Effect = MagicSetLogicControllerEffect
    typealias Event = MagicSetLogicControllerEvent
    typealias Update = MagicSetLogicControllerUpdate
    
    var sut: MagicSetLogicController!
    
    override func setUp() {
        sut = MagicSetLogicController()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func test_update_when_eventIs_cardsRequested() {
        let model = MagicSetLogicModel(setId: "SET", setName: "NAME", cards: [], currentPage: 0, numberOfCards: 0)
        
        let expectedModel = MagicSetLogicModel(setId: "SET", setName: "NAME", cards: [], currentPage: 0, numberOfCards: 0)
        let expectedUpdate = Update(model: expectedModel, effect: .loadCards)
        
        let sutUpdate = sut.update(model, .cardsRequested)
        
        XCTAssertEqual(sutUpdate, expectedUpdate)
    }
    
    func test_update_when_eventIs_cardsLoaded() {
        let cards = [Card(name: "Carta",
                          set: "SET",
                          imageUrl: "url",
                          id: "ID",
                          type: "Creature"),
                     Card(name: "Cartinha",
                          set: "SET",
                          imageUrl: "urlDaImagem",
                          id: "IDD",
                          type: "Creature")]
        
        
        let expectedCards: [MagicSetLogicModel.Card] = cards.map { MagicSetLogicModel.Card(card: $0, isFavorite: false) }
        
        let model = MagicSetLogicModel(setId: "SET", setName: "NAME", cards: [], currentPage: 0, numberOfCards: 2)
        
        let expectedModel = MagicSetLogicModel(setId: "SET", setName: "NAME", cards: expectedCards, currentPage: 0, numberOfCards: 2)
        let expectedUpdate = Update(model: expectedModel, effect: .none)
        
        let sutUpdate = sut.update(model, .cardsLoaded(cards, atPage: 0, ofTotal: 2))
        
        XCTAssertEqual(sutUpdate, expectedUpdate)
    }
    
    func test_update_when_eventIs_cardsRequestFailed() {
        let model = MagicSetLogicModel(setId: "SET", setName: "NAME", cards: [], currentPage: 0, numberOfCards: 0)
        
        let expectedModel = MagicSetLogicModel(setId: "SET", setName: "NAME", cards: [], currentPage: 0, numberOfCards: 0)
        let expectedUpdate = Update(model: expectedModel, effect: .none)
        
        let sutUpdate = sut.update(model, .cardsRequestFailed)
        
        XCTAssertEqual(sutUpdate, expectedUpdate)
    }
}

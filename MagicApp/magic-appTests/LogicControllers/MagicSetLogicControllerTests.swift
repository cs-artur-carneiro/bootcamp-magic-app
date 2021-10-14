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
        let model = MagicSetLogicModel(set: "SET", cards: [])
        
        let expectedModel = MagicSetLogicModel(set: "SET", cards: [])
        let expectedUpdate = Update(model: expectedModel, effect: .loadCards)
        
        let sutUpdate = sut.update(model, .cardsRequested)
        
        XCTAssertEqual(sutUpdate, expectedUpdate)
    }
}

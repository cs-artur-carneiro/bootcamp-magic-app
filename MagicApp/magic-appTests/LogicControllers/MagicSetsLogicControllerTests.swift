import XCTest
import MagicNetwork
@testable import magic_app

final class MagicSetsLogicControllerTests: XCTestCase {
    typealias Effect = MagicSetsLogicController.Effect
    typealias Event = MagicSetsLogicController.Event
    typealias Update = MagicSetsLogicController.Update
    
    var sut: MagicSetsLogicController!
    
    override func setUp() {
        sut = MagicSetsLogicController()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func test_update_when_eventIs_setsRequested() {
        let model = MagicSetsLogicModel(sets: Array(repeating: MagicSet(name: "Teste"), count: 10), canFetch: true)
        
        let expectedModel = MagicSetsLogicModel(sets: Array(repeating: MagicSet(name: "Teste"), count: 10), canFetch: true)
        let expectedUpdate = Update(model: expectedModel, effect: Effect.loadSets)
        
        let sutUpdate = sut.update(model, .setsRequested)
        
        XCTAssertEqual(sutUpdate, expectedUpdate)
    }
    
    func test_update_when_eventIs_setsLoaded() {
        let model = MagicSetsLogicModel(sets: [], canFetch: true)
        let loadedModels = Array(repeating: MagicSet(name: "Teste"), count: 10)
        
        let expectedModel = MagicSetsLogicModel(sets: Array(repeating: MagicSet(name: "Teste"), count: 10), canFetch: true)
        let expectedUpdate = Update(model: expectedModel, effect: Effect.none)
        
        let sutUpdate = sut.update(model, .setsLoaded(loadedModels))
        
        XCTAssertEqual(sutUpdate, expectedUpdate)
    }
    
    func test_update_when_eventIs_setsRequestFailed() {
        let model = MagicSetsLogicModel(sets: [], canFetch: true)
        
        let expectedModel = MagicSetsLogicModel(sets: [], canFetch: true)
        let expectedUpdate = Update(model: expectedModel, effect: Effect.none)
        
        let sutUpdate = sut.update(model, .setsRequestFailed)
        
        XCTAssertEqual(sutUpdate, expectedUpdate)
    }
    
    func test_update_when_eventIs_connectionLost() {
        let model = MagicSetsLogicModel(sets: [], canFetch: false)
        
        let expectedModel = MagicSetsLogicModel(sets: [], canFetch: false)
        let expectedUpdate = Update(model: expectedModel, effect: Effect.none)
        
        let sutUpdate = sut.update(model, .connectionLost)
        
        XCTAssertEqual(sutUpdate, expectedUpdate)
    }
    
    func test_update_when_eventIs_setSelected() {
        let model = MagicSetsLogicModel(sets: Array(repeating: MagicSet(name: "Teste"), count: 10), canFetch: true)
        let index = IndexPath(row: 1, section: 0)
        
        let expectedModel = MagicSetsLogicModel(sets: Array(repeating: MagicSet(name: "Teste"), count: 10), canFetch: true)
        let expectedUpdate = Update(model: expectedModel, effect: Effect.loadSet(at: index))
        
        let sutUpdate = sut.update(model, .setSelected(index))
        
        XCTAssertEqual(sutUpdate, expectedUpdate)
    }
}

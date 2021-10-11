import XCTest
@testable import MagicMock

final class MagicMockTests: XCTestCase {
    var sut: TestingMock!
    
    override func setUp() {
        sut = TestingMock()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func test_arrange_with_setUp_and_execute() {
        sut
            .setUp()
            .arrange(.addition(32))
            .arrange(.thought("Olá"))
            .execute()
        
        let expectedState = (32, "Olá")
        let currentState = sut.state()
        
        XCTAssertEqual(currentState.0, expectedState.0)
        XCTAssertEqual(currentState.1, expectedState.1)
    }
    
    func test_arrange_with_setUp_and_without_execute() {
        sut
            .setUp()
            .arrange(.addition(32))
            .arrange(.thought("Olá"))
        
        let expectedState: (Int?, String?) = (nil, nil)
        let currentState = sut.state()
        
        XCTAssertEqual(currentState.0, expectedState.0)
        XCTAssertEqual(currentState.1, expectedState.1)
    }
    
    func test_clearArrangements() {
        sut
            .setUp()
            .arrange(.addition(32))
            .arrange(.thought("Olá"))
            .execute()
        
        let expectedState: (Int?, String?) = (nil, nil)
        sut.clearArrangements()
        
        let currentState = sut.state()
        
        XCTAssertEqual(currentState.0, expectedState.0)
        XCTAssertEqual(currentState.1, expectedState.1)
    }
    
    func test_assertActions() {
        sut
            .setUp()
            .arrange(.addition(32))
            .arrange(.thought("Olá"))
            .execute()
        
        sut.add(4)
        sut.think("Como vai você?")
        
        let expectedActions: [TestingMockAction] = [.add(4),
                                                    .think("Como vai você?")]
        
        XCTAssertEqual(expectedActions, sut.actions)
        XCTAssertTrue(sut.assert(expectedActions))
    }
    
    func test_clearActions() {
        sut
            .setUp()
            .arrange(.addition(32))
            .arrange(.thought("Olá"))
            .execute()
        
        sut.add(4)
        sut.think("Como vai você?")
        
        sut.clearActions()
        
        let expectedActions: [TestingMockAction] = []
        
        XCTAssertEqual(expectedActions, sut.actions)
        XCTAssertTrue(sut.assert(expectedActions))
    }
}

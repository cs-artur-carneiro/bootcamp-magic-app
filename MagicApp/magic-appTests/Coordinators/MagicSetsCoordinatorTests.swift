import Foundation
import XCTest
import MagicMock
@testable import magic_app

final class MagicSetsCoordinatorTests: XCTestCase {
    var sut: MagicSetsCoordinator!
    var navigationControllerStub: UINavigationControllerStub!
    
    override func setUp() {
        navigationControllerStub = UINavigationControllerStub()
        sut = MagicSetsCoordinator(navigationController: navigationControllerStub)
    }
    
    override func tearDown() {
        navigationControllerStub = nil
        sut = nil
    }
    
    func test_start() throws {
        sut.start()
        
        let currentViewController = try XCTUnwrap(sut.navigationController.topViewController)
        
        let expectedActions: [UINavigationControllerStubAction] = [.pushedViewController(currentViewController)]
        
        XCTAssertEqual(expectedActions, navigationControllerStub.actions)
    }
}

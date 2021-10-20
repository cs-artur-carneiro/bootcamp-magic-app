import XCTest
import SnapshotTesting
@testable import magic_app

final class MagicSetViewControllerTests: XCTestCase {
    var sut: MagicSetViewController!
    var setView: MagicSetViewProtocol!
    var viewModel: MagicSetViewModelProtocolMock!
    
    override func setUp() {
        setView = MagicSetView(widthReference: 375)
        viewModel = MagicSetViewModelProtocolMock()
        sut = MagicSetViewController(setView: setView,
                                     viewModel: viewModel)
    }
    
    override func tearDown() {
        setView = nil
        viewModel = nil
        sut = nil
    }
    
    func test_initial_state() {
        viewModel
            .setUp()
            .arrange(.set(name: "SET", id: "ID"))
            .arrange(.cards(MagicSetListViewModelFactory().make()))
            .execute()
        
        sut.beginAppearanceTransition(true, animated: false)
        
        assertSnapshot(matching: sut, as: .wait(for: 1.0, on: Snapshotting.image(on: .iPhoneSe)))
    }
    
    func test_initial_state_onMaxSize() {
        viewModel
            .setUp()
            .arrange(.set(name: "SET", id: "ID"))
            .arrange(.cards(MagicSetListViewModelFactory().make()))
            .execute()
        
        sut.beginAppearanceTransition(true, animated: false)
        
        assertSnapshot(matching: sut, as: .wait(for: 1.0, on: Snapshotting.image(on: .iPhoneXsMax)))
    }
    
    func test_initial_state_navigationTitle() throws {
        let navController = UINavigationController(rootViewController: sut)
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        window.rootViewController = navController
        window.makeKeyAndVisible()
        
        viewModel
            .setUp()
            .arrange(.set(name: "SET", id: "ID"))
            .arrange(.cards(MagicSetListViewModelFactory().make()))
            .execute()
        
        sut.beginAppearanceTransition(true, animated: false)
        
        let windowController = try XCTUnwrap(window.rootViewController)
        
        assertSnapshot(matching: windowController, as: .wait(for: 1.0, on: Snapshotting.image(on: .iPhoneXsMax)))
    }
    
    func test_navigationController_configuredCorrectly_atViewWillAppear() {
        _ = UINavigationController(rootViewController: sut)
        
        viewModel
            .setUp()
            .arrange(.set(name: "SET", id: "ID"))
            .arrange(.cards(MagicSetListViewModelFactory().make()))
            .execute()
        
        sut.beginAppearanceTransition(true, animated: false)
        
        XCTAssertTrue(sut.navigationController?.navigationBar.prefersLargeTitles ?? false)
        XCTAssertEqual(sut.navigationItem.largeTitleDisplayMode, .always)
    }
}

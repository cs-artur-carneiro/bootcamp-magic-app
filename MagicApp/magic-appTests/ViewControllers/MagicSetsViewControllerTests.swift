import XCTest
import SnapshotTesting
@testable import magic_app

final class MagicSetsViewControllerTests: XCTestCase {
    var sut: MagicSetsViewController!
    var viewModel: MagicSetsViewModelProtocolMock!
    var setsView: MagicSetsViewProtocol!
    var delegateStub: MagicSetsViewControllerDelegateStub!
    
    override func setUp() {
        viewModel = MagicSetsViewModelProtocolMock()
        setsView = MagicSetsView()
        delegateStub = MagicSetsViewControllerDelegateStub()
        sut = MagicSetsViewController(setsView: setsView, viewModel: viewModel)
        sut.delegate = delegateStub
    }
    
    override func tearDown() {
        viewModel = nil
        setsView = nil
        delegateStub = nil
        sut = nil
    }
    
    func test_initial_state() {
        viewModel
            .setUp()
            .arrange(.sets(MagicSetsListViewModelFactory().makeNumbersAndLetters()))
            .execute()
        
        sut.beginAppearanceTransition(true, animated: false)
        
        assertSnapshot(matching: sut, as: .wait(for: 1.0, on: Snapshotting.image(on: .iPhoneSe)))
    }
    
    func test_initial_state_onMaxSize() {
        viewModel
            .setUp()
            .arrange(.sets(MagicSetsListViewModelFactory().makeNumbersAndLetters()))
            .execute()
        
        sut.beginAppearanceTransition(true, animated: false)
        
        assertSnapshot(matching: sut, as: .wait(for: 1.0, on: Snapshotting.image(on: .iPhoneXsMax)))
    }
    
    func test_binding_for_setSelected() {
        let index = IndexPath(row: 0, section: 0)
        
        viewModel
            .setUp()
            .arrange(.sets(MagicSetsListViewModelFactory().makeNumbersAndLetters()))
            .execute()
        
        sut.beginAppearanceTransition(true, animated: false)
        
        setsView.didSelectSetAt?(index)
        
        let expectedActions: [MagicSetsViewModelProtocolMockAction] = [.requestSets, .setSelected(index)]
        
        XCTAssertTrue(viewModel.assert(expectedActions))
    }
    
    func test_setSelected_calls_delegate() {
        let index = IndexPath(row: 0, section: 0)
        let expectedSet = MagicSetsCellViewModel(id: "AAA",
                                                 title: "10th Edition",
                                                 lastInSection: false)
        
        let expectation = XCTestExpectation(description: #function)
        
        viewModel
            .setUp()
            .arrange(.sets(MagicSetsListViewModelFactory().makeNumbersAndLetters()))
            .execute()
        
        sut.beginAppearanceTransition(true, animated: false)
        
        viewModel.setSelected(at: index)
        
        delegateStub.didSelectCallback = {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(delegateStub.setSelected, expectedSet)
    }
    
    func test_navigationController_configuredCorrectly_atViewWillAppear() {
        _ = UINavigationController(rootViewController: sut)
        
        viewModel
            .setUp()
            .arrange(.sets(MagicSetsListViewModelFactory().makeNumbersAndLetters()))
            .execute()
        
        sut.beginAppearanceTransition(true, animated: false)
        
        XCTAssertTrue(sut.navigationController?.navigationBar.prefersLargeTitles ?? false)
        XCTAssertEqual(sut.navigationItem.largeTitleDisplayMode, .always)
    }
}

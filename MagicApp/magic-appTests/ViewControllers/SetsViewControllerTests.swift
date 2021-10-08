import XCTest
import SnapshotTesting
@testable import magic_app

final class MagicSetsViewControllerTests: XCTestCase {
    var sut: MagicSetsViewController!
    var viewModel: MagicSetsViewModelProtocolMock!
    
    override func setUp() {
        viewModel = MagicSetsViewModelProtocolMock()
        let view = MagicSetsView(setsPublisher: viewModel.sets)
        sut = MagicSetsViewController(setsView: view, viewModel: viewModel)
    }
    
    override func tearDown() {
        viewModel = nil
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
}

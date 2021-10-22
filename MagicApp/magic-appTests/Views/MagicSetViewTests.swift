import Combine
import XCTest
import SnapshotTesting
@testable import magic_app

final class MagicSetViewTests: XCTestCase {
    var sut: MagicSetView!
    var viewModel: MagicSetViewModelProtocolMock!
    
    override func setUp() {
        viewModel = MagicSetViewModelProtocolMock()
        sut = MagicSetView(widthReference: 375)
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func test_configureDataSource() {
        sut.frame.size = CGSize(width: 375, height: 667)
        
        sut.configureDataSource(for: viewModel.cardsPublisher)
        
        viewModel
            .setUp()
            .arrange(.state(.usable))
            .arrange(.cards(MagicSetListViewModelFactory().make()))
            .execute()
        
        viewModel.fetchCards()
        
        assertSnapshot(matching: sut, as: .wait(for: 1.0, on: Snapshotting.image))
    }
}

import Foundation
import XCTest
import SnapshotTesting
import Combine
@testable import magic_app

final class MagicSetsViewTests: XCTestCase {
    var sut: MagicSetsView!
    var viewModelMock: MagicSetsViewModelProtocolMock!
    
    override func setUp() {
        viewModelMock = MagicSetsViewModelProtocolMock()
        sut = MagicSetsView()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func test_configureSetsDataSource() {
        sut.frame.size = CGSize(width: 320, height: 568)
        
        sut.configureSetsDataSource(for: viewModelMock.sets)
        
        viewModelMock
            .setUp()
            .arrange(.state(.usable))
            .arrange(.sets(MagicSetsListViewModelFactory().makeLettersOnly()))
            .execute()
        
        viewModelMock.requestSets()
        
        assertSnapshot(matching: sut, as: .wait(for: 1.0, on: Snapshotting.image))
    }
    
    func test_didSelectSetAt() {
        sut.configureSetsDataSource(for: viewModelMock.sets)
        
        viewModelMock
            .setUp()
            .arrange(.sets(MagicSetsListViewModelFactory().makeLettersOnly()))
            .execute()
        
        viewModelMock.requestSets()
    
        var didSelectIndex: IndexPath?
        
        sut.didSelectSetAt = {
            didSelectIndex = $0
        }
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        let sutTableView = sut.subviews.first(where: { $0 is UITableView }) as? UITableView
        
        sut.tableView(sutTableView ?? UITableView(), didSelectRowAt: indexPath)
        
        XCTAssertEqual(didSelectIndex, indexPath)
    }
}

import Foundation
@testable import magic_app

final class MagicSetsViewControllerDelegateStub: MagicSetsViewControllerDelegate {
    var didSelectCallback: (() -> Void)?
    private(set) var setSelected: MagicSetsCellViewModel?
    
    func didSelectSet(_ set: MagicSetsCellViewModel) {
        setSelected = set
        didSelectCallback?()
    }
}

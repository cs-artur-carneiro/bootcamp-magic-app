import UIKit

final class MagicSetViewController: UIViewController {
    private let viewModel: MagicSetViewModelProtocol
    
    init(viewModel: MagicSetViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

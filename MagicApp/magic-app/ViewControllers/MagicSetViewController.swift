import UIKit

final class MagicSetViewController: UIViewController {
    private let viewModel: MagicSetViewModelProtocol
    private let setView: MagicSetViewProtocol
    
    init(setView: MagicSetViewProtocol = MagicSetView(),
         viewModel: MagicSetViewModelProtocol) {
        self.viewModel = viewModel
        self.setView = setView
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = setView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.setName
        setView.configureDataSource(for: viewModel.cardsPublisher)
        viewModel.fetchCards()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
}

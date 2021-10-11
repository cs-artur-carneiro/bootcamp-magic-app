import UIKit
import Combine

protocol MagicSetsViewControllerDelegate: AnyObject {
    func didSelectSet(_ set: MagicSetsCellViewModel)
}

final class MagicSetsViewController: UIViewController {
    private let viewModel: MagicSetsViewModelProtocol
    private let setsView: MagicSetsViewProtocol
    private var cancellableStore = Set<AnyCancellable>()
    
    weak var delegate: MagicSetsViewControllerDelegate?
    
    init(setsView: MagicSetsViewProtocol,
         viewModel: MagicSetsViewModelProtocol) {
        self.setsView = setsView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = setsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Expansions"
        setUpBindings()
        
        viewModel.requestSets()
    }
    
    private func setUpBindings() {
        setsView.didSelectSetAt = { [weak self] index in
            self?.viewModel.setSelected(at: index)
        }
        
        viewModel.selectedSet
            .receive(on: RunLoop.main)
            .sink { [weak self] (set) in
                self?.delegate?.didSelectSet(set)
            }.store(in: &cancellableStore)
        
        setsView.configureSetsDataSource(for: viewModel.sets)
    }
}


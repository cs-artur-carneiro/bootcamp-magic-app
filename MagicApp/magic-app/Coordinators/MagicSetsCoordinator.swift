import UIKit

final class MagicSetsCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = MagicSetsViewModel()
        let setsView = MagicSetsView()
        let controller = MagicSetsViewController(setsView: setsView,
                                                 viewModel: viewModel)
        controller.delegate = self
        navigationController.pushViewController(controller, animated: true)
    }
}

extension MagicSetsCoordinator: MagicSetsViewControllerDelegate {
    func didSelectSet(_ set: MagicSetsCellViewModel) {
        let viewModel = MagicSetViewModel(setId: set.id, setName: set.title)
        let setView = MagicSetView()
        let controller = MagicSetViewController(setView: setView,
                                                viewModel: viewModel)
        navigationController.pushViewController(controller, animated: true)
    }
}

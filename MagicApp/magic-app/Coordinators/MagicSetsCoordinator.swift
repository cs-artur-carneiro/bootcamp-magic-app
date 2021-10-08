import UIKit

final class MagicSetsCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = MagicSetsViewModel()
        let setsView = MagicSetsView(setsPublisher: viewModel.sets)
        let controller = MagicSetsViewController(setsView: setsView,
                                                 viewModel: viewModel)
        controller.delegate = self
        navigationController.pushViewController(controller, animated: true)
    }
}

extension MagicSetsCoordinator: MagicSetsViewControllerDelegate {
    func didSelectSet(_ set: MagicSetsCellViewModel) {
        navigationController.pushViewController(UIViewController(), animated: true)
    }
}

import UIKit

final class UINavigationControllerStub: UINavigationController {
    private(set) var actions: [UINavigationControllerStubAction] = []
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        actions.append(.pushedViewController(viewController))
        super.pushViewController(viewController, animated: animated)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        actions.append(.presentedViewController(viewControllerToPresent))
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}

enum UINavigationControllerStubAction: Equatable {
    case pushedViewController(UIViewController)
    case presentedViewController(UIViewController)
    
    static func == (lhs: UINavigationControllerStubAction, rhs: UINavigationControllerStubAction) -> Bool {
        switch (lhs, rhs) {
        case let (.presentedViewController(lhsViewController),
                  .presentedViewController(rhsViewController)):
            return lhsViewController === rhsViewController
        case let(.pushedViewController(lhsViewController),
                 .pushedViewController(rhsViewController)):
            return lhsViewController === rhsViewController
        default:
            return false
        }
    }
}

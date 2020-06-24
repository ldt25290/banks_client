import UIKit

protocol ModalTransitioningDelegate: UIViewControllerTransitioningDelegate {
    init(onDismiss: ((Self) -> Void)?)
}

protocol Router: Presentable {
    func hasRootModule() -> Bool

    func present(_ module: Presentable?)
    func present(_ module: Presentable?, animated: Bool)
    func presentAutomaticStyle(_ module: Presentable?, animated: Bool)
    func present(_ module: Presentable?, animated: Bool, style: UIModalPresentationStyle)
    func present(_ module: Presentable?, transitioning delegate: UIViewControllerTransitioningDelegate?)

    func push(_ module: Presentable?)
    func push(_ module: Presentable?, hideBottomBar: Bool)
    func push(_ module: Presentable?, animated: Bool)
    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?)
    func push(_ module: Presentable?, animated: Bool, hideBottomBar: Bool, completion: (() -> Void)?)
    func push(_ module: Presentable?, transitioning delegate: (UINavigationControllerDelegate & UIViewControllerAnimatedTransitioning)?)

    func popModule()
    func popModule(animated: Bool)

    func dismissModule()
    func dismissModule(animated: Bool, completion: (() -> Void)?)

    func setRootModule(_ module: Presentable?)
    func setRootModule(_ module: Presentable?, hideBar: Bool)

    func popToRootModule(animated: Bool)
}

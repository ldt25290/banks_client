import UIKit

class RouterImp: NSObject, Router {
    private weak var rootController: UINavigationController?
    private var completions: [UIViewController: () -> Void] = [:]
    private var animators: [UIViewController: UIViewControllerTransitioningDelegate] = [:]

    init(rootController: UINavigationController) {
        self.rootController = rootController
        super.init()
    }

    func hasRootModule() -> Bool {
        (rootController?.viewControllers.count) ?? 0 > 0
    }

    func toPresent() -> UIViewController? {
        rootController
    }

    func present(_ module: Presentable?) {
        present(module, animated: true)
    }

    func present(_ module: Presentable?, animated: Bool) {
        present(module, animated: animated, style: .overFullScreen)
    }

    func presentAutomaticStyle(_ module: Presentable?, animated: Bool) {
        if #available(iOS 13.0, *) {
            present(module, animated: animated, style: .automatic)
        } else {
            present(module, animated: animated, style: .overFullScreen)
        }
    }

    func present(_ module: Presentable?, animated: Bool, style: UIModalPresentationStyle) {
        guard let controller = module?.toPresent() else { return }
        controller.modalPresentationStyle = style
        rootController?.present(controller, animated: animated, completion: nil)
    }

    func present(_ module: Presentable?, transitioning delegate: UIViewControllerTransitioningDelegate?) {
        guard let controller = module?.toPresent() else { return }
        controller.transitioningDelegate = delegate
        controller.modalPresentationStyle = .custom
        rootController?.present(controller, animated: true, completion: nil)
    }

    func dismissModule() {
        dismissModule(animated: true, completion: nil)
    }

    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        rootController?.dismiss(animated: animated, completion: completion)
    }

    func push(_ module: Presentable?) {
        push(module, animated: true)
    }

    func push(_ module: Presentable?, transitioning delegate: (UINavigationControllerDelegate & UIViewControllerAnimatedTransitioning)?) {
        push(module, animated: true, hideBottomBar: false, transitioning: delegate, completion: { [weak self] in
            self?.rootController?.delegate = nil
		})
    }

    func push(_ module: Presentable?, hideBottomBar: Bool) {
        push(module, animated: true, hideBottomBar: hideBottomBar, completion: nil)
    }

    func push(_ module: Presentable?, animated: Bool) {
        push(module, animated: animated, completion: nil)
    }

    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) {
        push(module, animated: animated, hideBottomBar: false, completion: completion)
    }

    func push(_ module: Presentable?, animated: Bool, hideBottomBar: Bool, completion: (() -> Void)?) {
        push(module, animated: animated, hideBottomBar: hideBottomBar, transitioning: nil, completion: completion)
    }

    // swiftlint:disable vertical_parameter_alignment
    func push(_ module: Presentable?, animated: Bool, hideBottomBar: Bool,
              transitioning delegate: (UINavigationControllerDelegate & UIViewControllerAnimatedTransitioning)? = nil,
              completion: (() -> Void)?) {
        guard
            let controller = module?.toPresent(),
            controller is UINavigationController == false
        else { assertionFailure("Deprecated push UINavigationController."); return }

        if let completion = completion {
            completions[controller] = completion
        }
        controller.hidesBottomBarWhenPushed = hideBottomBar
        rootController?.delegate = delegate
        rootController?.pushViewController(controller, animated: animated)
    }

    func popModule() {
        popModule(animated: true)
    }

    func popModule(animated: Bool) {
        if let controller = rootController?.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }

    func setRootModule(_ module: Presentable?) {
        setRootModule(module, hideBar: false)
    }

    func setRootModule(_ module: Presentable?, hideBar: Bool) {
        guard let controller = module?.toPresent() else { return }
        rootController?.setViewControllers([controller], animated: false)
        rootController?.isNavigationBarHidden = hideBar
    }

    func popToRootModule(animated: Bool) {
        if let controllers = rootController?.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                runCompletion(for: controller)
            }
        }
    }

    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}

extension RouterImp: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        runCompletion(for: presentationController.presentedViewController)
    }
}

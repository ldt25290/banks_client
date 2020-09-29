import Swinject
import UIKit

protocol TabContainerCoordinatorOutput: AnyObject {}

final class TabContainerCoordinator: BaseCoordinator, TabContainerCoordinatorOutput {
    var finishFlow: ((Bool) -> Void)?

    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    private let container: Container

    private var controller: UITabBarController?

    init(router: Router, coordinatorFactory: CoordinatorFactory, container: Container) {
        self.coordinatorFactory = coordinatorFactory
        self.router = router
        self.container = container

        super.init()
    }

    deinit {
        print("\(self) deinit")
    }

    override func start() {
        let controller = UITabBarController()
        controller.viewControllers = []

        let dashboardController = assembleDashboard(on: controller)
        let accountsController = assembleAccounts(on: controller)

        controller.viewControllers = [
            dashboardController,
            accountsController
        ]

        controller.selectedIndex = 1

        router.setRootModule(controller, hideBar: true)
        self.controller = controller
    }

    private func assembleDashboard(on _: UITabBarController) -> UIViewController {
        let rootController = UINavigationController()

        let coordinator = coordinatorFactory.makeDashboardCoordinatorOutput(container: container,
                                                                            rootController: rootController)

        addDependency(coordinator)
        coordinator.start()

        return rootController
    }

    private func assembleAccounts(on _: UITabBarController) -> UIViewController {
        let rootController = UINavigationController()

        let coordinator = coordinatorFactory.makeAccountsCoordinatorOutput(container: container,
                                                                           rootController: rootController)

        addDependency(coordinator)
        coordinator.start()

        return rootController
    }
}

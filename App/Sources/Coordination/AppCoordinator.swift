import Swinject
import UIKit

final class AppCoordinator: BaseCoordinator {
    private let router: Router
    private let coordinatorFactory: CoordinatorFactory
    private let container: Container

    init(window: UIWindow, container: Container, coordinatorFactory: CoordinatorFactory) {
        let navigationController = UINavigationController()

        self.coordinatorFactory = coordinatorFactory
        self.container = container

        router = RouterImp(rootController: navigationController)
        window.rootViewController = navigationController
    }

    override func start() {
        let coordinator = TabContainerCoordinator(router: router, coordinatorFactory: CoordinatorFactoryImpl(), container: container)

        addDependency(coordinator)
        coordinator.start()
    }
}

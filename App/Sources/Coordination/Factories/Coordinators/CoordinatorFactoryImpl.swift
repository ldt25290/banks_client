import Swinject
import UIKit

final class CoordinatorFactoryImpl: CoordinatorFactory {
    func makeAccountsCoordinatorOutput(container: Container, rootController: UINavigationController) -> AccountsCoordinatorOutput & Coordinator {
        let router = RouterImp(rootController: rootController)

        return AccountsCoordinator(router: router, container: container,
                                   coordinatorFactory: CoordinatorFactoryImpl(), moduleFactory: ModuleFactoryImpl())
    }

    func makeDashboardCoordinatorOutput(container: Container, rootController: UINavigationController) -> Coordinator & DashboardCoordinatorOutput {
        let router = RouterImp(rootController: rootController)

        return DashboardCoordinator(router: router, container: container,
                                    coordinatorFactory: CoordinatorFactoryImpl(), moduleFactory: ModuleFactoryImpl())
    }
}

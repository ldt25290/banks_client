import UIKit
import Swinject

final class CoordinatorFactoryImpl: CoordinatorFactory {
    func makeAccountsCoordinatorOutput(container: Container, rootController: UINavigationController) -> AccountsCoordinatorOutput & Coordinator {
        let router = RouterImp(rootController: rootController)
        
        return AccountsCoordinator(router: router, container: container,
                                   coordinatorFactory: CoordinatorFactoryImpl(), moduleFactory: ModuleFactoryImpl())
    }
}

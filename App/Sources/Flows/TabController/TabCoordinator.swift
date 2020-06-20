import UIKit
import Swinject

protocol TabContainerCoordinatorOutput: class {
    
}

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
        
        router.setRootModule(controller, hideBar: true)
        self.controller = controller
    }
    
    private func assembleDashboard(on tabController: UITabBarController) -> UIViewController {
        let rootController = UINavigationController()
        
        let coordinator = coordinatorFactory.makeAccountsCoordinatorOutput(container: container,
                                                                           rootController: rootController)
        
        addDependency(coordinator)
        coordinator.start()
        
        return rootController
    }
    
    private func assembleAccounts(on tabController: UITabBarController) -> UIViewController {
        let rootController = UINavigationController()
        
        let coordinator = coordinatorFactory.makeAccountsCoordinatorOutput(container: container,
                                                                           rootController: rootController)
        
        addDependency(coordinator)
        coordinator.start()
        
        return rootController
    }
}

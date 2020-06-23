import Swinject

protocol DashboardCoordinatorOutput: class {
    
}

final class DashboardCoordinator: BaseCoordinator, DashboardCoordinatorOutput {
    var onAddRoomRequest: (() -> Void)?
    
    private let router: Router
    private let container: Container
    private let coordinatorFactory: CoordinatorFactory
    private let moduleFactory: DashboardModuleFactory
    
    init(router: Router, container: Container, coordinatorFactory: CoordinatorFactory, moduleFactory: DashboardModuleFactory) {
        self.router = router
        self.container = container
        self.coordinatorFactory = coordinatorFactory
        self.moduleFactory = moduleFactory
        super.init()
    }
    
    override func start() {
        let presentable = moduleFactory.makeDashboardModuleOutput(container: container)
        
        router.setRootModule(presentable, hideBar: false)
    }
}

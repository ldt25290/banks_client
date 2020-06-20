import Swinject

protocol AccountsCoordinatorOutput: class {
    
}

final class AccountsCoordinator: BaseCoordinator, AccountsCoordinatorOutput {
    var onAddRoomRequest: (() -> Void)?
    
    private let router: Router
    private let container: Container
    private let coordinatorFactory: CoordinatorFactory
    private let moduleFactory: AccountsModuleFactory
    
    init(router: Router, container: Container, coordinatorFactory: CoordinatorFactory, moduleFactory: AccountsModuleFactory) {
        self.router = router
        self.container = container
        self.coordinatorFactory = coordinatorFactory
        self.moduleFactory = moduleFactory
        super.init()
    }
    
    override func start() {
        let presentable = moduleFactory.makeAccountsModuleOutput(container: container)
        
        router.setRootModule(presentable, hideBar: false)
    }
}

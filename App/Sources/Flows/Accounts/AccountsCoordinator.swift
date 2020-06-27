import Swinject

protocol AccountsCoordinatorOutput: AnyObject {}

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
        showAccountsScreen()
    }

    private func showAccountsScreen() {
        let (output, presentable) = moduleFactory.makeAccountsModuleOutput(container: container)

        output.openTransactionsList = { [weak self] accountID in
            self?.showTransactionsList(accountID: accountID)
        }

        router.setRootModule(presentable, hideBar: false)
    }

    private func showTransactionsList(accountID: String) {
        let (output, presentable) = moduleFactory.makeTransactionsModuleOutput(accountID: accountID, container: container)

        router.push(presentable)
    }
}

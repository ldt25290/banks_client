import Swinject
import SwinjectAutoregistration

extension ObjectScope {
    static let sessionScope = ObjectScope(storageFactory: PermanentStorage.init)
}

struct AppDependencies {
    static func setup() -> (Assembler, Container) {
        let container = Container()

        let assembler = Assembler(container: container)

        assembler.apply(assemblies: [
            CoreDependencies(),
            WrapperDependencies(),
            ViewModels()
        ])

        return (assembler, container)
    }

    static func reset(container: Container, scope: ObjectScope) {
        container.resetObjectScope(scope)
    }
}

// swiftlint:disable force_try
struct CoreDependencies: Assembly {
    func assemble(container: Container) {
        container.register(DatabaseService.self, factory: { _ in
            try! DatabaseServiceImpl()
        }).inObjectScope(.sessionScope)

        container.register(NetworkService.self, factory: { _ in
            NetworkServiceImpl()
        }).inObjectScope(.sessionScope)

        container.register(EventDispatcher.self, factory: { _ in
            EventDispatcherImpl()
        }).inObjectScope(.sessionScope)
    }
}

struct WrapperDependencies: Assembly {
    func assemble(container: Container) {
        container.autoregister(AccountsService.self,
                               initializer: AccountsServiceImpl.init)
            .initCompleted { res, service in
                let dispatcher = res.resolve(EventDispatcher.self)!
                dispatcher.addListener(service)
            }
            .inObjectScope(.sessionScope)
    }
}

struct ViewModels: Assembly {
    func assemble(container: Container) {
        container.autoregister((AccountsViewModel & AccountsModuleOutput).self, initializer: AccountsViewModelImpl.init)

        container.register((TransactionsViewModel & TransactionsModuleOutput).self) { res, accountID in
            TransactionsViewModelImpl(accountID: accountID,
                                      network: res.resolve(NetworkService.self)!)
        }
    }
}

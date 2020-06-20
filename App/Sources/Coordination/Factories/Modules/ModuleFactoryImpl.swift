import Swinject

final class ModuleFactoryImpl {
    
}

extension ModuleFactoryImpl: AccountsModuleFactory {
    func makeAccountsModuleOutput(container: Container) -> (Presentable) {
        let controller = AccountsViewController.controllerInStoryboard(R.storyboard.accounts())
        
        return controller
    }
}

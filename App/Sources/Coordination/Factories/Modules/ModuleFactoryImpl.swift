import Swinject

final class ModuleFactoryImpl {
    
}

extension ModuleFactoryImpl: AccountsModuleFactory {
    func makeAccountsModuleOutput(container: Container) -> (Presentable) {
        let controller = AccountsViewController.controllerInStoryboard(R.storyboard.accounts())
        
        return controller
    }
}

extension ModuleFactoryImpl: DashboardModuleFactory {
    func makeDashboardModuleOutput(container: Container) -> (Presentable) {
        let controller = DashboardViewController.controllerInStoryboard(R.storyboard.dashboard())
        
        return controller
    }
}

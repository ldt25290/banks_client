import Swinject

final class ModuleFactoryImpl {}

extension ModuleFactoryImpl: AccountsModuleFactory {
    func makeAccountsModuleOutput(container: Container) -> (AccountsModuleOutput, Presentable) {
        let model = container.resolve((AccountsViewModel & AccountsModuleOutput).self)!

        let controller = AccountsViewController.controllerInStoryboard(R.storyboard.accounts())
        controller.viewModel = model

        return (model, controller)
    }
}

extension ModuleFactoryImpl: DashboardModuleFactory {
    func makeDashboardModuleOutput(container _: Container) -> (Presentable) {
        let controller = DashboardViewController.controllerInStoryboard(R.storyboard.dashboard())

        return controller
    }
}

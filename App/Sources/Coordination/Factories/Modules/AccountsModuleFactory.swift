import Swinject

protocol AccountsModuleFactory {
    func makeAccountsModuleOutput(container: Container) -> (Presentable)
}

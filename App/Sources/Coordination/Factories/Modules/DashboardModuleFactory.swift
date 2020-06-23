import Swinject

protocol DashboardModuleFactory {
    func makeDashboardModuleOutput(container: Container) -> (Presentable)
}

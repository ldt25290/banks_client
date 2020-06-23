import Swinject

protocol CoordinatorFactory {
    func makeAccountsCoordinatorOutput(container: Container, rootController: UINavigationController) -> Coordinator & AccountsCoordinatorOutput
    
    func makeDashboardCoordinatorOutput(container: Container, rootController: UINavigationController) -> Coordinator & DashboardCoordinatorOutput
}

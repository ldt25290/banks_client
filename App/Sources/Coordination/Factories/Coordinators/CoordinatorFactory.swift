import Swinject

protocol CoordinatorFactory {
    func makeAccountsCoordinatorOutput(container: Container, rootController: UINavigationController) -> Coordinator & AccountsCoordinatorOutput
}

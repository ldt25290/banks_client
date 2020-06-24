import UIKit

class BaseCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    func start() {}

    func addDependency(_ coordinator: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else {
            return
        }
        childCoordinators.append(coordinator)
    }

    func removeDependency(_ coordinator: Coordinator?) {
        guard let coordinator = coordinator, !childCoordinators.isEmpty else {
            return
        }

        if let coordinator = coordinator as? BaseCoordinator, !coordinator.childCoordinators.isEmpty {
            coordinator.childCoordinators
                .filter { $0 !== coordinator }
                .forEach { coordinator.removeDependency($0) }
        }

        for (idx, child) in childCoordinators.enumerated() where child === coordinator {
            childCoordinators.remove(at: idx)
            break
        }
    }
}

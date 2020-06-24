import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var coordinator: AppCoordinator!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene),
            let container = session.container else { return }

        window = UIWindow(windowScene: windowScene)

        coordinator = AppCoordinator(window: window!,
                                     container: container,
                                     coordinatorFactory: CoordinatorFactoryImpl())
        coordinator.start()

        window?.makeKeyAndVisible()
    }
}

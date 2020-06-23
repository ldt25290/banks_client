import UIKit
import Swinject
//import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var container: Container!
    private var assembler: Assembler!
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        FirebaseApp.configure()
        
        let (assembler, container) = AppDependencies.setup()
        self.container = container
        self.assembler = assembler
        
        let db = container.resolve(DatabaseService.self)
        
        application.openSessions.forEach { session in
            session.container = container
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        connectingSceneSession.container = container
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

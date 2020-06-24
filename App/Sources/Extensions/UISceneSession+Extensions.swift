import Swinject
import UIKit

extension UISceneSession {
    private struct Keys {
        static var container = "container"
    }

    var container: Container? {
        get {
            objc_getAssociatedObject(self, &Keys.container) as? Container
        }

        set {
            objc_setAssociatedObject(self, &Keys.container, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

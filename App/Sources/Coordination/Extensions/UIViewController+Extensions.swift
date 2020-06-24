import UIKit

// swiftlint:disable force_cast
extension UIViewController {
    private class func instantiateControllerInStoryboard<T: UIViewController>(_ storyboard: UIStoryboard, identifier: String) -> T {
        storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }

    class func controllerInStoryboard(_ storyboard: UIStoryboard, identifier: String) -> Self {
        instantiateControllerInStoryboard(storyboard, identifier: identifier)
    }

    class func controllerInStoryboard(_ storyboard: UIStoryboard) -> Self {
        controllerInStoryboard(storyboard, identifier: nameOfClass)
    }
}

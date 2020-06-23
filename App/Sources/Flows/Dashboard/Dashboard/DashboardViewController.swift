import UIKit

final class DashboardViewController: UIViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        tabBarItem = UITabBarItem(title: R.string.localizable.accounts_screen_title(),
                                  image: R.image.pieChart(), tag: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = R.string.localizable.dashboard_screen_title()
    }
}

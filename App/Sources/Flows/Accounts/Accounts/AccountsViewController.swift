import UIKit

final class AccountsViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        tabBarItem = UITabBarItem(title: R.string.localizable.accounts_screen_title(), image: UIImage(systemName: "heart.fill"), tag: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = R.string.localizable.accounts_screen_title()
    }
}

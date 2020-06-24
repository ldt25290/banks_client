import UIKit

final class AccountsViewController: UIViewController {
    var viewModel: AccountsViewModel!
    private var mediator: AccountsMediator!

    @IBOutlet var contentCollectionView: UICollectionView!

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
                                  image: R.image.save(), tag: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        title = R.string.localizable.accounts_screen_title()

        mediator = AccountsMediatorImpl(collectionView: contentCollectionView,
                                        viewModel: viewModel)
    }

    @IBAction func sortAccounts(_: Any) {
        let options = viewModel.groupingOptions()

        let controller = UIAlertController(title: R.string.localizable.account_sort_selection_title(),
                                           message: R.string.localizable.account_sort_selection_message(),
                                           preferredStyle: .actionSheet)

        for (idx, option) in options.enumerated() {
            let action = UIAlertAction(title: option, style: .default) { [weak self] _ in
                self?.viewModel.applyGroupingOption(at: idx)
            }
            controller.addAction(action)
        }

        let cancelAction = UIAlertAction(title: R.string.localizable.action_cancel(), style: .cancel, handler: nil)
        controller.addAction(cancelAction)

        present(controller, animated: true, completion: nil)
    }
}

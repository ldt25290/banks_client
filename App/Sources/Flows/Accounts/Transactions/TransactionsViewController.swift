import UIKit

final class TransactionsViewController: UIViewController {
    var viewModel: TransactionsViewModel!
    private var mediator: TransactionsMediator!

    @IBOutlet var contentCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mediator = TransactionsMediatorImpl(collectionView: contentCollectionView,
                                            viewModel: viewModel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if isMovingToParent {
            refreshTransactions()
        }
    }

    @objc private func refreshTransactions() {
        viewModel.refreshTransactions { _ in
        }
    }
}

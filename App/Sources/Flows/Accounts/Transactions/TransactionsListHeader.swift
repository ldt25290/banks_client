import UIKit

final class TransactionsListHeader: UICollectionReusableView {
    @IBOutlet var titleLabel: UILabel!

    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}

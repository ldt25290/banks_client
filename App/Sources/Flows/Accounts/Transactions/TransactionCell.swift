import UIKit

final class TransactionCell: UICollectionViewCell {
    @IBOutlet var aliasLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var amountBadgeLabel: UIView!
    @IBOutlet var blockAmountLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()

        let cornerRadius = floor(amountBadgeLabel.bounds.height / 2.0)
        if amountBadgeLabel.layer.cornerRadius != cornerRadius {
            amountBadgeLabel.layer.cornerRadius = cornerRadius
        }
    }

    func setup(with model: TransactionCellModel) {
        let amountColor = model.amountPositive ? R.color.positive_text() : R.color.negative_text()
        let amountBadgeColor = model.amountPositive ? R.color.positive_background() : R.color.negative_background()

        aliasLabel.text = model.alias
        categoryLabel.text = model.category
        blockAmountLabel.text = model.blockAmount

        amountLabel.text = model.amount

        amountLabel.textColor = amountColor
        amountBadgeLabel.backgroundColor = amountBadgeColor
    }
}

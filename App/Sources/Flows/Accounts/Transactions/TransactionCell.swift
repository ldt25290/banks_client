import UIKit

final class TransactionCell: UICollectionViewCell {
    @IBOutlet var aliasLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var amountBadgeLabel: UIView!
    @IBOutlet var blockAmountLabel: UILabel!
    @IBOutlet var separator: UIView!

    override func layoutSubviews() {
        super.layoutSubviews()

        let cornerRadius = floor(amountBadgeLabel.bounds.height / 2.0)
        if amountBadgeLabel.layer.cornerRadius != cornerRadius {
            amountBadgeLabel.layer.cornerRadius = cornerRadius
        }
    }

    func setup(with model: TransactionCellModel, showSeparator: Bool) {
        let amountColor = model.amountPositive ? R.color.positive_text() : R.color.negative_text()
        let amountBadgeColor = model.amountPositive ? R.color.positive_background() : R.color.negative_background()

        aliasLabel.text = model.alias
        categoryLabel.text = model.category
        blockAmountLabel.text = model.blockAmount

        amountLabel.text = model.amount

        amountLabel.textColor = amountColor
        amountBadgeLabel.backgroundColor = amountBadgeColor

        separator.isHidden = !showSeparator
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        var frame = layoutAttributes.frame

        let bounding = CGSize(width: frame.width, height: UIView.layoutFittingExpandedSize.height)

        var size = contentView.systemLayoutSizeFitting(bounding,
                                                       withHorizontalFittingPriority: .required,
                                                       verticalFittingPriority: .fittingSizeLevel)

        size.width = bounding.width
        size.height = max(100.0, ceil(size.height))

        frame.size = size
        layoutAttributes.frame = frame
        return layoutAttributes
    }
}

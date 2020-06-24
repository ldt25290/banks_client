import UIKit

final class AccountCell: UICollectionViewCell {
    @IBOutlet var accountLabel: UILabel!
    @IBOutlet var bankLabel: UILabel!
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var balanceBadgeView: UIView!
    @IBOutlet var creditCardStackView: UIStackView!
    @IBOutlet var availableBalanceLabel: UILabel!
    @IBOutlet var creditLimitLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()

        let cornerRadius = floor(balanceBadgeView.bounds.height / 2.0)
        if balanceBadgeView.layer.cornerRadius != cornerRadius {
            balanceBadgeView.layer.cornerRadius = cornerRadius
        }
    }

    func setup(model: AccountCellModel) {
        let balanceColor = model.balancePositive ? R.color.positive_text() : R.color.negative_text()

        let balanceBadgeColor = model.balancePositive ? R.color.positive_background() : R.color.negative_background()

        accountLabel.text = model.number
        bankLabel.text = model.bank

        balanceLabel.text = model.realBalance
        balanceLabel.textColor = balanceColor
        balanceBadgeView.backgroundColor = balanceBadgeColor

        availableBalanceLabel.text = model.availableBalance
        creditLimitLabel.text = model.creditLimit
    }
}

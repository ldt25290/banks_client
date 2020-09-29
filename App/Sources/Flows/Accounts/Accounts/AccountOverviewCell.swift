import UIKit

final class AccountOverviewCell: UICollectionViewCell {
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var realBalanceBadgeView: UIView!
    @IBOutlet var realBalanceLabel: UILabel!
    @IBOutlet var availableBalanceLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()

        let cornerRadius = floor(realBalanceBadgeView.bounds.height / 2.0)
        if realBalanceBadgeView.layer.cornerRadius != cornerRadius {
            realBalanceBadgeView.layer.cornerRadius = cornerRadius
        }
    }

    func setup(model: AccountOverviewCellModel) {
        let balanceColor = model.balancePositive ? R.color.positive_text() : R.color.negative_text()

        let balanceBadgeColor = model.balancePositive ? R.color.positive_background() : R.color.negative_background()

        currencyLabel.text = model.currency

        realBalanceBadgeView.backgroundColor = balanceBadgeColor

        realBalanceLabel.text = model.realBalance
        realBalanceLabel.textColor = balanceColor

        availableBalanceLabel.text = model.availableBalance
    }
}

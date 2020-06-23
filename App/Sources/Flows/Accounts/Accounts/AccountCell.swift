import UIKit

final class AccountCell: UICollectionViewCell {
    
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var bankLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var balanceBadgeView: UIView!
    @IBOutlet weak var creditCardStackView: UIStackView!
    @IBOutlet weak var availableBalanceLabel: UILabel!
    @IBOutlet weak var creditLimitLabel: UILabel!
    
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

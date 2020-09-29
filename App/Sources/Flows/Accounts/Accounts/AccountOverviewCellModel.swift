import Foundation

struct AccountOverviewCellModel {
    private let balance: TotalAccountBalance
    private let formatter: NumberFormatter

    init(balance: TotalAccountBalance, formatter: NumberFormatter) {
        self.balance = balance
        self.formatter = formatter
    }

    var currency: String {
        balance.currency.localized
    }

    var realBalance: String? {
        let value = NSNumber(value: balance.real.doubleValue)
        let components = [formatter.string(from: value), currency]
        return components.compactMap { $0 }.joined(separator: " ")
    }

    var availableBalance: String {
        let value = NSNumber(value: balance.available.doubleValue)
        let components = [formatter.string(from: value), currency]
        return components.compactMap { $0 }.joined(separator: " ")
    }

    var balancePositive: Bool {
        balance.real.positive
    }
}

import Foundation

struct TransactionCellModel {
    private let transaction: BankTransaction
    private let formatter: NumberFormatter

    init(transaction: BankTransaction, formatter: NumberFormatter) {
        self.transaction = transaction
        self.formatter = formatter
    }

    var alias: String {
        transaction.alias
    }

    var currency: String {
        transaction.currency.localized
    }

    var amount: String? {
        format(amount: transaction.amount, currency: currency)
    }

    var category: String? {
        transaction.category
    }

    var amountPositive: Bool {
        switch transaction.type {
        case .expense:
            return false
        case .income:
            return true
        }
    }

    var blockAmount: String? {
        if let blockAmount = transaction.blockAmount, let currency = transaction.blockCurrency {
            return format(amount: blockAmount, currency: currency.localized)
        }

        if let postAmount = transaction.postAmount, let currency = transaction.postCurrency {
            return format(amount: postAmount, currency: currency.localized)
        }

        return nil
    }

    private func format(amount: Balance, currency: String) -> String {
        let value = NSNumber(value: amount.doubleValue)
        let components = [formatter.string(from: value), currency]

        return components.compactMap { $0 }.joined(separator: " ")
    }
}

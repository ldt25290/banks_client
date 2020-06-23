import Foundation

struct AccountCellModel {
    
    private let account: BankAccount
    private let formatter: NumberFormatter
    
    init(account: BankAccount, formatter: NumberFormatter) {
        self.account = account
        self.formatter = formatter
    }
    
    var bank: String {
        return account.bank.localized
    }
    
    var number: String {
        let components = account.number.components(separatedBy: .whitespacesAndNewlines).joined()
        let suffix = components.suffix(4)
        return ["****", suffix].joined()
    }
    
    var currency: String {
        return account.currency.localized
    }
    
    var realBalance: String? {
        let value = NSNumber(value: account.realBalance.doubleValue)
        let components = [formatter.string(from: value), currency]
        return components.compactMap { $0 }.joined(separator: " ")
    }
    
    var availableBalance: String {
        let value = NSNumber(value: account.balance.doubleValue)
        let components = [formatter.string(from: value), currency]
        return components.compactMap { $0 }.joined(separator: " ")
    }
    
    var creditLimit: String {
        guard account.isCredit else {
            return "--"
        }
        
        let value = NSNumber(value: account.limit.doubleValue)
        let components = [formatter.string(from: value), currency]
        return components.compactMap { $0 }.joined(separator: " ")
    }
    
    var balancePositive: Bool {
        return account.balancePositive
    }
}

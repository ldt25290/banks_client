import GRDB

struct BankAccount {
    let id: String
    let bank: Bank
    let number: String
    let name: String
    let balance: Balance
    let currency: Currency
    let limit: Balance
    let isCredit: Bool
}

extension BankAccount: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case bank
        case number
        case name
        case balance
        case currency
        case limit
        case isCredit = "is_credit"
    }
}

extension BankAccount: TableRecord, PersistableRecord, FetchableRecord {
    static let databaseTableName = "bank_accounts"
}

extension BankAccount: Equatable {}

extension BankAccount {
    var realBalance: Balance {
        if isCredit {
            return (balance - limit)
        }
        return balance
    }

    var balancePositive: Bool {
        !isCredit || balance >= limit
    }
}

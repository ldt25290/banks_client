import Foundation

enum TransactionType: String, Codable {
    case income = "INCOME"
    case expense = "EXPENSE"
}

struct BankTransaction {
    let id: String
    let date: Date
    let category: String?
    let alias: String
    let amount: Balance
    let type: TransactionType
    let postAmount: Balance?
    let blockAmount: Balance?
    let currency: Currency
    let postCurrency: Currency?
    let blockCurrency: Currency?
}

extension BankTransaction: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case category
        case alias
        case amount
        case currency
        case type
        case postAmount = "post_amount"
        case postCurrency = "post_currency"
        case blockAmount = "block_amount"
        case blockCurrency = "block_currency"
    }
}

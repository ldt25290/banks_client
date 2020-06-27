import Foundation
import UIKit

struct TransactionsStorage {
    private var storage: [Date: [BankTransaction]] = [:]

    private let calendar = Calendar(identifier: .gregorian)

    private(set) var sections: [Date] = []

    private mutating func _append(_ transaction: BankTransaction) -> Bool {
        let comparison: (Date) -> Bool = {
            self.calendar.compare($0, to: transaction.date, toGranularity: .day) == .orderedSame
        }

        var key = storage.keys.first(where: comparison)
        let keyExisted = (key != nil)
        key = key ?? transaction.date

        var values = storage[key!] ?? []
        values.append(transaction)
        storage[key!] = values

        return keyExisted
    }

    mutating func append(_ transaction: BankTransaction) {
        let keysMutated = _append(transaction)

        if keysMutated {
            sections = storage.keys.sorted(by: >)
        }
    }

    mutating func append(contentsOf transactions: [BankTransaction]) {
        guard !transactions.isEmpty else {
            return
        }

        var keysMutated = false

        for transaction in transactions {
            let mutated = _append(transaction)
            keysMutated = keysMutated || mutated
        }

        if keysMutated {
            sections = storage.keys.sorted(by: >)
        }
    }

    mutating func removeAll() {
        storage.removeAll()
        sections.removeAll()
    }

    var isEmpty: Bool {
        storage.isEmpty
    }

    var numberOfSections: Int {
        sections.count
    }

    func date(for section: Int) -> Date {
        sections[section]
    }

    func numberOfItems(in section: Int) -> Int {
        let key = sections[section]
        return storage[key]?.count ?? 0
    }

    func transaction(at indexPath: IndexPath) -> BankTransaction {
        let key = sections[indexPath.section]
        guard let items = storage[key] else {
            fatalError()
        }
        return items[indexPath.row]
    }
}

import Foundation

protocol AccountsModuleOutput: AnyObject {}

enum AccountsGrouping: CaseIterable {
    case currency
    case bank

    var localized: String {
        switch self {
        case .currency:
            return R.string.localizable.account_sort_currency()
        case .bank:
            return R.string.localizable.account_sort_bank_name()
        }
    }
}

protocol AccountsViewModel: AnyObject {
    var onDataSourceChange: (() -> Void)? { get set }

    func groupingOptions() -> [String]
    func applyGroupingOption(at index: Int)

    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func cellModelForItem(at indexPath: IndexPath) -> AccountCellModel
}

final class AccountsViewModelImpl: AccountsViewModel, AccountsModuleOutput {
    private let formatter: NumberFormatter
    private let accounts: [BankAccount]

    private var grouping: AccountsGrouping = .bank
    private var groups: [String: [BankAccount]] = [:]
    private var sortedKeys: [String] = []

    var onDataSourceChange: (() -> Void)?

    // swiftlint:disable force_try
    init() {
        formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.decimalSeparator = "."

        let url = R.file.accountsJson()!
        let data = try! Data(contentsOf: url)
        accounts = try! JSONDecoder().decode([BankAccount].self, from: data)

        applyGrouping(grouping, force: true)
    }

    func numberOfSections() -> Int {
        sortedKeys.count
    }

    func numberOfItems(in section: Int) -> Int {
        let key = sortedKeys[section]
        return groups[key]?.count ?? 0
    }

    func cellModelForItem(at indexPath: IndexPath) -> AccountCellModel {
        let key = sortedKeys[indexPath.section]
        guard let items = groups[key] else {
            fatalError()
        }

        let account = items[indexPath.row]
        return AccountCellModel(account: account, formatter: formatter)
    }

    private func applyGrouping(_ grouping: AccountsGrouping, force: Bool = false) {
        guard force || self.grouping != grouping else {
            return
        }

        self.grouping = grouping

        groups.removeAll()
        sortedKeys.removeAll()

        let sort: (String, String) -> Bool

        switch grouping {
        case .bank:
            sort = { $0 < $1 }
        case .currency:
            let currencyCode = Locale.autoupdatingCurrent.currencyCode

            sort = { lhs, rhs in
                if lhs == currencyCode {
                    return true
                }
                if rhs == currencyCode {
                    return false
                }
                return lhs < rhs
            }
        }

        for account in accounts {
            let key: String

            switch grouping {
            case .bank:
                key = account.bank.localized
            case .currency:
                key = account.currency.localized
            }

            var accounts = groups[key] ?? []
            accounts.append(account)
            groups[key] = accounts
        }

        sortedKeys = groups.keys.sorted(by: sort)
    }

    func groupingOptions() -> [String] {
        AccountsGrouping.allCases.map { $0.localized }
    }

    func applyGroupingOption(at index: Int) {
        let grouping = AccountsGrouping.allCases[index]
        applyGrouping(grouping)

        onDataSourceChange?()
    }
}

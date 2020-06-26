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

    func refreshAccounts(completion: @escaping (Result<Void, Error>) -> Void)
}

final class AccountsViewModelImpl: AccountsViewModel, AccountsModuleOutput {
    private let formatter: NumberFormatter
    private var accounts: [BankAccount] = []

    private var grouping: AccountsGrouping = .bank
    private var groups: [String: [BankAccount]] = [:]
    private var sortedKeys: [String] = []

    var onDataSourceChange: (() -> Void)?

    private let accountsService: AccountsService
    private let db: DatabaseService

    private var accountsListToken: DatabaseObserverToken?

    init(accountsService: AccountsService, db: DatabaseService) {
        self.accountsService = accountsService
        self.db = db

        formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.decimalSeparator = "."

        accountsListToken = db.trackAccountsListChange { [weak self] accounts in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.accounts = accounts
                self.applyGrouping(self.grouping, force: true)
                self.onDataSourceChange?()
            }
        }
    }

    deinit {
        accountsListToken = nil
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

    func refreshAccounts(completion: @escaping (Result<Void, Error>) -> Void) {
        accountsService.updateAccounts { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}

import Foundation

protocol AccountsModuleOutput: AnyObject {
    var openTransactionsList: ((String) -> Void)? { get set }
}

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

enum AccountsSection {
    case overview
    case account
}

struct TotalAccountBalance: Hashable {
    let currency: Currency
    var available: Balance
    var real: Balance
}

protocol AccountsViewModel: AnyObject {
    var onDataSourceChange: (() -> Void)? { get set }

    func groupingOptions() -> [String]
    func applyGroupingOption(at index: Int)

    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func sectionType(for section: Int) -> AccountsSection
    func balanceCellModelForItem(at indexPath: IndexPath) -> AccountOverviewCellModel
    func accountCellModelForItem(at indexPath: IndexPath) -> AccountCellModel

    func refreshAccounts(completion: @escaping (Result<Void, Error>) -> Void)

    func showTransactionsForAccount(at indexPath: IndexPath)

    func title(for section: Int) -> String
}

final class AccountsViewModelImpl: AccountsViewModel, AccountsModuleOutput {
    private let formatter: NumberFormatter
    private var accounts: [BankAccount] = []
    private var balances: [TotalAccountBalance] = []

    private var grouping: AccountsGrouping = .currency
    private var groups: [String: [BankAccount]] = [:]
    private var sortedKeys: [String] = []

    var onDataSourceChange: (() -> Void)?
    var openTransactionsList: ((String) -> Void)?

    private let accountsService: AccountsService
    private let db: DatabaseService

    private var accountsListToken: DatabaseObserverToken?

    init(accountsService: AccountsService, db: DatabaseService, notifications: UserNotifications) {
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
                self.calculateBalances(for: accounts)
                self.applyGrouping(self.grouping, force: true)
                self.onDataSourceChange?()
            }
        }

        notifications.registerNotifications()
    }

    deinit {
        accountsListToken = nil
    }

    func numberOfSections() -> Int {
        sortedKeys.count + 1
    }

    func sectionType(for section: Int) -> AccountsSection {
        switch section {
        case 0:
            return .overview
        default:
            return .account
        }
    }

    func numberOfItems(in section: Int) -> Int {
        switch sectionType(for: section) {
        case .overview:
            return balances.count
        case .account:
            let key = sortedKeys[section - 1]
            return groups[key]?.count ?? 0
        }
    }
    
    func balanceCellModelForItem(at indexPath: IndexPath) -> AccountOverviewCellModel {
        let balance = balances[indexPath.row]
        return AccountOverviewCellModel(balance: balance, formatter: formatter)
    }

    func accountCellModelForItem(at indexPath: IndexPath) -> AccountCellModel {
        let key = sortedKeys[indexPath.section - 1]
        guard let items = groups[key] else {
            fatalError()
        }

        let account = items[indexPath.row]
        return AccountCellModel(account: account, formatter: formatter)
    }

    func title(for section: Int) -> String {
        sortedKeys[section - 1]
    }
    
    private func calculateBalances(for accounts: [BankAccount]) {
        var balances: [Currency: TotalAccountBalance] = [:]
        
        for account in accounts {
            if var balance = balances[account.currency] {
                balance.available += account.balance
                balance.real += account.realBalance
                balances[account.currency] = balance
            } else {
                balances[account.currency] = TotalAccountBalance(currency: account.currency,
                                                                 available: account.balance,
                                                                 real: account.realBalance)
            }
        }
        
        let sort: (String, String) -> Bool = { lhs, rhs in
            let currencyCode = Locale.autoupdatingCurrent.currencyCode
            
            if lhs == currencyCode {
                return true
            }
            if rhs == currencyCode {
                return false
            }
            return lhs < rhs
            
        }
        
        self.balances = Array(balances.values)
                            .sorted(by: { sort($0.currency.rawValue, $1.currency.rawValue) })
        
        print(self.balances)
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
            if account.balance.isEmpty {
                continue
            }

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
        AccountsGrouping.allCases.map(\.localized)
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

    func showTransactionsForAccount(at indexPath: IndexPath) {
        let key = sortedKeys[indexPath.section - 1]
        guard let items = groups[key] else {
            fatalError()
        }

        let account = items[indexPath.row]
        openTransactionsList?(account.id)
    }
}

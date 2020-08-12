import Foundation
import UIKit

protocol TransactionsModuleOutput: AnyObject {}

enum TransactionSection {
    case data
    case loading
}

protocol TransactionsViewModel: AnyObject {
    var numberOfSections: Int { get }
    func sectionType(for section: Int) -> TransactionSection
    func numberOfItems(in section: Int) -> Int
    func cellModelForItem(at indexPath: IndexPath) -> TransactionCellModel
    func titleForHeader(in section: Int) -> String

    func refreshTransactions(completion: @escaping (Result<Void, Error>) -> Void)
    func loadMoreTransactions()

    var onDataSourceChange: (() -> Void)? { get set }
}

final class TransactionsViewModelImpl: TransactionsViewModel, TransactionsModuleOutput {
    private let accountID: String?
    private let network: NetworkService
    private let formatter: NumberFormatter

    private var cursor: String?
    private var storage = TransactionsStorage()

    private let transactionsBatch = 20

    private var isFetching: Bool = false

    var onDataSourceChange: (() -> Void)?

    private let dateFormatter: DateFormatter

    init(accountID: String? = nil, network: NetworkService) {
        self.accountID = accountID
        self.network = network

        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"

        formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.decimalSeparator = "."
    }

    func fetchTransactions(reset: Bool, completion: ((Result<Void, Error>) -> Void)?) {
        guard !isFetching || reset else {
            return
        }

        isFetching = true
        let cursor = reset ? nil : self.cursor

        network.fetchTransactions(accountID: accountID, cursor: cursor,
                                  count: transactionsBatch) { [weak self] result in
            defer {
                self?.isFetching = false
            }

            switch result {
            case let .failure(error):
                completion?(.failure(error))
            case let .success(response):
                self?.handleTransactions(response, reset: reset)
                completion?(.success(()))
            }
        }
    }

    func loadMoreTransactions() {
        fetchTransactions(reset: false, completion: nil)
    }

    func refreshTransactions(completion: @escaping (Result<Void, Error>) -> Void) {
        fetchTransactions(reset: true, completion: completion)
    }

    private func handleTransactions(_ response: PaginatedResponse<BankTransaction>, reset: Bool) {
        cursor = response.pagination.nextCursor

        var storage = reset ? TransactionsStorage() : self.storage
        storage.append(contentsOf: response.data)

        self.storage = storage
        onDataSourceChange?()
    }

    private var hasMoreData: Bool {
        cursor != nil && !storage.isEmpty
    }

    var numberOfSections: Int {
        storage.numberOfSections + 1
    }

    func numberOfItems(in section: Int) -> Int {
        if section < storage.numberOfSections {
            return storage.numberOfItems(in: section)
        }

        return hasMoreData ? 1 : 0
    }

    func sectionType(for section: Int) -> TransactionSection {
        if section < storage.numberOfSections {
            return .data
        }
        return .loading
    }

    func cellModelForItem(at indexPath: IndexPath) -> TransactionCellModel {
        assert(indexPath.section < storage.numberOfSections, "Section out of bounds")

        let transaction = storage.transaction(at: indexPath)
        return TransactionCellModel(transaction: transaction, formatter: formatter)
    }

    func titleForHeader(in section: Int) -> String {
        let date = storage.date(for: section)
        return dateFormatter.string(from: date)
    }
}

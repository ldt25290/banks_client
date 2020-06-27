import Foundation

protocol NetworkService: AnyObject {
    func fetchAccounts(completion: @escaping (Result<AccountsResponse, Error>) -> Void)

    func fetchTransactions(accountID: String?, cursor: String?, count: Int,
                           completion: @escaping (Result<PaginatedResponse<BankTransaction>, Error>) -> Void)
}

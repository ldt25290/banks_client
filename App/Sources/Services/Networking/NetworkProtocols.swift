import Foundation

protocol NetworkService: AnyObject {
    func fetchAccounts(completion: @escaping (Result<AccountsResponse, Error>) -> Void)
}

import Foundation
import GRDB

typealias DatabaseObserverToken = Any

protocol DatabaseService: AnyObject {
    func updateAccounts(_ accounts: [BankAccount], completion: @escaping (Result<Void, Error>) -> Void)

    func trackAccountsListChange(onChange: @escaping ([BankAccount]) -> Void) -> DatabaseObserverToken
}

import Foundation

protocol AccountsService: EventsListener {
    func updateAccounts(completion: @escaping (Result<Void, Error>) -> Void)
}

final class AccountsServiceImpl: AccountsService {
    private let db: DatabaseService
    private let network: NetworkService

    init(db: DatabaseService, network: NetworkService) {
        self.db = db
        self.network = network
    }

    func updateAccounts(completion: @escaping (Result<Void, Error>) -> Void) {
        network.fetchAccounts { [weak self] result in
            switch result {
            case let .success(stats):
                self?.db.updateAccounts(stats.accounts, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

extension AccountsServiceImpl {
    func handleEvent(_ event: Event, completion: @escaping (Result<Void, Error>) -> Void) {
        switch event {
        case .backgroundFetch:
            updateAccounts(completion: completion)
        default:
            completion(.success(Void()))
        }
    }
}

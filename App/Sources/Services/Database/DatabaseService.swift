import Foundation
import GRDB
import os.log

private typealias DatabaseWriteBlock = (GRDB.Database) throws -> GRDB.Database.TransactionCompletion
private typealias DatabaseReadBlock<T> = (GRDB.Database) throws -> T

final class DatabaseServiceImpl: DatabaseService {
    private let dbPool: DatabasePool

    private let queue = DispatchQueue(label: "banks.db-queue", attributes: .concurrent)

    init() throws {
        let url = try FileManager.default.url(for: .applicationSupportDirectory,
                                              in: .userDomainMask,
                                              appropriateFor: nil, create: true)

        let dbURL = url.appendingPathComponent("db.sqlite")

        os_log("Database url is %{private}@", log: OSLog.database, type: .info, dbURL.path)

        var config = Configuration()

        #if !DEBUG
            config.prepareDatabase = { db in
                try db.usePassphrase("")
            }
        #endif

        dbPool = try DatabasePool(path: dbURL.path, configuration: config)

        try Migrations.migrate(with: dbPool)
    }

    fileprivate func performWrite(_ block: @escaping DatabaseWriteBlock,
                                  completion: @escaping (Result<Void, Error>) -> Void)
    {
        queue.async {
            do {
                try self.dbPool.writeInTransaction(nil, block)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }

    fileprivate func performRead<T>(_ block: @escaping DatabaseReadBlock<T>,
                                    completion: @escaping (Result<T, Error>) -> Void)
    {
        queue.async {
            do {
                let result = try self.dbPool.read(block)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }

    fileprivate func addObservation<T, Reducer>(_ observation: ValueObservation<Reducer>,
                                                onChange: @escaping (T) -> Void) -> DatabaseCancellable
        where Reducer: ValueReducer, Reducer.Value == T
    {
        let observer = observation.start(in: dbPool,
                                         scheduling: .async(onQueue: .global()),
                                         onError: {
                                             print("Observation error \($0)")
                                         }, onChange: onChange)
        return observer
    }
}

extension DatabaseServiceImpl {
    func updateAccounts(_ accounts: [BankAccount],
                        completion: @escaping (Result<Void, Error>) -> Void)
    {
        performWrite({ db in
            for account in accounts {
                try account.save(db)
            }
            return .commit
        }, completion: completion)
    }

    func trackAccountsListChange(onChange: @escaping ([BankAccount]) -> Void) -> DatabaseObserverToken {
        let observation = ValueObservation.tracking(BankAccount.fetchAll).removeDuplicates()

        let observer = addObservation(observation, onChange: onChange)
        return observer
    }
}

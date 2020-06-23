import Foundation
import GRDB
import os.log

final class DatabaseServiceImpl: DatabaseService {
    private let dbPool: DatabasePool
    
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
    }
}

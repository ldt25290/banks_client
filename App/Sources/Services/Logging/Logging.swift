import os.log
import Foundation

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like viewDidLoad.
    static let database = OSLog(subsystem: subsystem, category: "database")
}

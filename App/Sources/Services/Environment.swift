import Foundation

private enum Keys {
    enum Plist {
        static let apiHost = "API_HOST"
    }
}

public enum Environment {
    // MARK: - Plist

    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    // MARK: - Plist values

    static let apiHost: String = {
        guard let apiHost = Environment.infoDictionary[Keys.Plist.apiHost] as? String else {
            fatalError("API URL not set in plist for this environment")
        }
        return apiHost
    }()
}

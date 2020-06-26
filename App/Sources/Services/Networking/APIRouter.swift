import Foundation

enum API {
    case fetchAccounts
}

extension API: TargetType {
    static var pinnedHosts: [String] {
        []
    }

    static var baseURL: URL {
        URL(string: Environment.apiHost)!
    }

    var path: String {
        switch self {
        case .fetchAccounts:
            return "/api/accounts"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchAccounts:
            return .get
        }
    }

    var headers: HTTPHeaders? {
        nil
    }

    var task: RequestTask? {
        switch self {
        default:
            return nil
        }
    }

    var authRequired: Bool {
        false
    }

    var timeout: TimeInterval? {
        60.0
    }
}

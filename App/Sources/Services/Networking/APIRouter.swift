import Foundation

enum API {
    case fetchAccounts
    case fetchTransactions(params: Parameters)
    case registerPushToken(params: Parameters)
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
        case .fetchTransactions:
            return "/api/transactions"
        case .registerPushToken:
            return "/api/push_tokens"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchAccounts, .fetchTransactions:
            return .get
        case .registerPushToken:
            return .post
        }
    }

    var headers: HTTPHeaders? {
        nil
    }

    var task: RequestTask? {
        switch self {
        case let .fetchTransactions(params):
            return .parameters(params, encoding: .url)
        case let .registerPushToken(params):
            return .parameters(params, encoding: .json)
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

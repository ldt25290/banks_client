import Foundation

typealias HTTPHeaders = [String: String]
typealias Parameters = [String: Any]

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

protocol TargetType: URLRequestConvertible {
    static var pinnedHosts: [String] { get }

    /// The targets' base URL
    static var baseURL: URL { get }

    /// The path to be appended to `baseURL` to form the full request URL
    var path: String { get }

    /// The HTTP method used in the request
    var method: HTTPMethod { get }

    /// The headers to be used in the request
    var headers: HTTPHeaders? { get }

    /// The task associated with the request
    var task: RequestTask? { get }

    /// Indicates if the target requires authorization
    var authRequired: Bool { get }

    var timeout: TimeInterval? { get }
}

extension TargetType {
    func asURLRequest() throws -> URLRequest {
        let endpoint = Self.baseURL.appendingPathComponent(path)

        var request = URLRequest(url: endpoint)
        request.httpMethod = method.rawValue

        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let task = self.task {
            request = try task.encode(to: request)
        }

        if let timeout = timeout {
            request.timeoutInterval = timeout
        }

        return request
    }
}

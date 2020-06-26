import Foundation

enum RequestTask {
    enum ParameterEncoding {
        case json
        case url
    }

    case plain
    case data(Data)
    case encodable(Encodable, encoder: JSONEncoder?)
    case parameters(Parameters?, encoding: ParameterEncoding)
}

extension RequestTask {
    func encode(to request: URLRequest) throws -> URLRequest {
        var result = request

        switch self {
        case .plain:
            return request
        case let .data(data):
            result.httpBody = data
        case let .encodable(value, encoder):
            let coder = encoder ?? JSONEncoder()
            result.httpBody = try coder.encode(AnyEncodable(value))
        case let .parameters(params?, .json) where !params.isEmpty:
            let body = try JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)
            result.httpBody = body
        case .parameters(let params?, encoding: .url) where !params.isEmpty:
            var items: [URLQueryItem] = []
            for (key, value) in params {
                let item = URLQueryItem(name: key, value: String(describing: value))
                items.append(item)
            }
            var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
            components?.queryItems = items
            result.url = components?.url
        default:
            break
        }

        switch self {
        case .encodable, .parameters(_, encoding: .json):
            result.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        default:
            break
        }

        return result
    }
}

struct AnyEncodable: Encodable {
    private let encodable: Encodable

    public init(_ encodable: Encodable) {
        self.encodable = encodable
    }

    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}

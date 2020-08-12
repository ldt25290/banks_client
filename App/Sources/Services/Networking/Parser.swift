import Foundation

struct SessionResponse {
    enum Error: Swift.Error {
        case invalidResponse
        case invalidStatusCode
        case emptyData
    }

    let statusCode: Int
    let result: Result<Data, Swift.Error>

    func data() throws -> Data {
        try result.get()
    }

    func validate<S: Sequence>(statusCodes: S) -> Result<Void, Error> where S.Element == Int {
        guard statusCodes.contains(where: { $0 == statusCode }) else {
            return .failure(.invalidStatusCode)
        }

        return .success(())
    }
}

struct APIError: Error, Decodable {}

struct Parser {
    static func parse(_ response: SessionResponse,
                      decoder: JSONDecoder? = nil,
                      queue: DispatchQueue = .global(),
                      completion: @escaping (Result<Void, Error>) -> Void)
    {
        queue.async {
            do {
                let data = try response.data()

                let jsonDecoder: JSONDecoder

                if let providedDecoder = decoder {
                    jsonDecoder = providedDecoder
                } else {
                    jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .secondsSince1970
                }

                let validationResult = response.validate(statusCodes: 200 ..< 300)

                if case .success = validationResult, data.isEmpty {
                    completion(.success(()))
                    return
                }

                switch validationResult {
                case .success:
                    completion(.success(()))
                case .failure:
                    let apiError = try jsonDecoder.decode(APIError.self, from: data)
                    throw apiError
                }
            } catch {
                print(error)
                completion(.failure(error))
            }
        }
    }

    static func parse<Output>(_ response: SessionResponse,
                              decoder: JSONDecoder? = nil,
                              queue: DispatchQueue = .global(),
                              completion: @escaping (Result<Output, Error>) -> Void) where Output: Decodable
    {
        queue.async {
            do {
                let data = try response.data()

                if data.isEmpty {
                    throw SessionResponse.Error.emptyData
                }

                let jsonDecoder: JSONDecoder

                if let providedDecoder = decoder {
                    jsonDecoder = providedDecoder
                } else {
                    jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .secondsSince1970
                }

                let validationResult = response.validate(statusCodes: 200 ..< 300)

                switch validationResult {
                case .success:
                    let decoded = try jsonDecoder.decode(Output.self, from: data)
                    completion(.success(decoded))
                case .failure:
                    let apiError = try jsonDecoder.decode(APIError.self, from: data)
                    throw apiError
                }
            } catch {
                print(error)
                completion(.failure(error))
            }
        }
    }
}

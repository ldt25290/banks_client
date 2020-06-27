import Foundation

struct PaginatedResponse<T>: Decodable where T: Decodable {
    let data: [T]
    let pagination: Pagination
}

struct Pagination: Decodable {
    let nextCursor: String?
    let previousCursor: String?

    enum CodingKeys: String, CodingKey {
        case nextCursor = "next_cursor"
        case previousCursor = "previous_cursor"
    }
}

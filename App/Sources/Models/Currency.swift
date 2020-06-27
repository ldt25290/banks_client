enum Currency: String, Codable {
    case uah = "UAH"
    case usd = "USD"
    case eur = "EUR"
    case rub = "RUB"

    var localized: String {
        switch self {
        case .uah:
            return "UAH"
        case .eur:
            return "EUR"
        case .usd:
            return "USD"
        case .rub:
            return "RUB"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        let rawValue = try container.decode(String.self)
        guard let currency = Currency(rawValue: rawValue.uppercased()) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid currency symbol \(rawValue)")
        }
        self = currency
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

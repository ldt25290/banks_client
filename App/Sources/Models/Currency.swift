enum Currency: String, Codable {
    case uah = "UAH"
    case usd = "USD"
    case eur = "EUR"

    var localized: String {
        switch self {
        case .uah:
            return "UAH"
        case .eur:
            return "EUR"
        case .usd:
            return "USD"
        }
    }
}

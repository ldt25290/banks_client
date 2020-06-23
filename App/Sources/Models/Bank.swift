enum Bank: String, Codable {
    case ukrsibbank
    case monobank
    case privat
    
    var localized: String {
        switch self {
        case .ukrsibbank:
            return R.string.localizable.bank_name_ukrsibbank()
        case .privat:
            return R.string.localizable.bank_name_privatbank()
        case .monobank:
            return R.string.localizable.bank_name_monobank()
        }
    }
}

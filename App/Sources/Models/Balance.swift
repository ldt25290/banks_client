struct Balance {
    let rawValue: Int
    
    init(value: Int) {
        self.rawValue = value
    }
    
    var doubleValue: Double {
        return Double(rawValue) / 100.0
    }
}

extension Balance: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        rawValue = try container.decode(Int.self)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

extension Balance: Equatable {}

extension Balance: Comparable {
    static func < (lhs: Balance, rhs: Balance) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

func - (left: Balance, right: Balance) -> Balance {
    return Balance(value: left.rawValue - right.rawValue)
}

func + (left: Balance, right: Balance) -> Balance {
    return Balance(value: left.rawValue + right.rawValue)
}

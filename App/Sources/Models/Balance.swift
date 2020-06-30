struct Balance {
    private(set) var rawValue: Int

    init(value: Int) {
        rawValue = value
    }

    var doubleValue: Double {
        Double(rawValue) / 100.0
    }

    var positive: Bool {
        rawValue >= 0
    }

    mutating func negate() {
        rawValue *= -1
    }

    var isEmpty: Bool {
        rawValue == 0
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
        lhs.rawValue < rhs.rawValue
    }
}

func - (left: Balance, right: Balance) -> Balance {
    Balance(value: left.rawValue - right.rawValue)
}

func + (left: Balance, right: Balance) -> Balance {
    Balance(value: left.rawValue + right.rawValue)
}

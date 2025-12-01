internal struct NRange<T: Numeric & Comparable & Hashable> : Hashable {
    let min: T?
    let max: T?
    let includeMin: Bool
    let includeMax: Bool

    func isInRange(_ value: T) -> Bool {
        let minCheck: Bool
        switch min {
        case .none:
            minCheck = true
        case .some(let minVal):
            minCheck = includeMin ? value.toDouble() >= minVal.toDouble() : value.toDouble() > minVal.toDouble()
        }

        let maxCheck: Bool
        switch max {
        case .none:
            maxCheck = true
        case .some(let maxVal):
            maxCheck = includeMax ? value.toDouble() <= maxVal.toDouble() : value.toDouble() < maxVal.toDouble()
        }

        return minCheck && maxCheck
    }
    
    static func fromMessageableWithExactType(args: Any) -> NRange<T> {
        guard let map = args as? [String: Any] else {
            fatalError("Invalid NRange type")
        }

        let rawMin = map["min"] as? T
        let rawMax = map["max"] as? T

        guard rawMin != nil && rawMax != nil else {
            fatalError("Invalid NRange type")
        }
        
        return NRange<T>(
            min: rawMin,
            max: rawMax,
            includeMin: map["inMin"] as! Bool,
            includeMax: map["inMax"] as! Bool
        )
    }
}

extension Numeric {
    func toDouble() -> Double {
        switch self {
        case let int as Int:
            return Double(int)
        case let double as Double:
            return double
        case let float as Float:
            return Double(float)
        default:
            fatalError("Unsupported Numeric type")
        }
    }
}

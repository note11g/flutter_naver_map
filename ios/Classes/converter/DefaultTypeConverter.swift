public func asBool(_ v: Any) -> Bool {
    v as! Bool
}

public func asDouble(_ v: Any) -> Double {
    v as! Double
}

public func asInt(_ v: Any) -> Int {
    v as! Int
}

public func asString(_ v: Any) -> String {
    v as! String
}

public func asStringWithNil(_ v: Any?) -> String? {
    (v is NSNull) ? nil : asString(v!) // todo : convert to (v == nil) condition
}

public func asDict(_ v: Any) -> Dictionary<String, Any> {
    v as! Dictionary<String, Any>
}

public func asArr<T>(_ v: Any, elementCaster: (Any) -> T) -> Array<T> {
    let list = v as! Array<Any>
    return list.map(elementCaster)
}


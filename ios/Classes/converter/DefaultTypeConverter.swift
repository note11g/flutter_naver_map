public func asBool(_ v: Any) -> Bool {
    v as! Bool
}

public func asFloat(_ v: Any) -> Float {
    v as! Float
}

public func asCGFloat(_ v: Any) -> CGFloat {
    CGFloat(asDouble(v))
}

public func asDouble(_ v: Any) -> Double {
    v as! Double
}

public func asRoundInt(rawFloat: Any) -> Int {
    Int(round(asDouble(rawFloat)))
}

public func asInt(_ v: Any) -> Int {
    v as! Int
}

public func asString(_ v: Any) -> String {
    v as! String
}

public func asDict(_ v: Any) -> Dictionary<String, Any> {
    v as! Dictionary<String, Any>
}

public func asDict<T>(_ v: Any, valueCaster: (Any) throws -> T) -> Dictionary<String, T> {
    let dict = asDict(v)
    var newDict: Dictionary<String, T> = [:]
    for (k, v) in dict {
        newDict[k] = try! valueCaster(v)
    }
    return newDict
}

public func asArr<T>(_ v: Any, elementCaster: (Any) throws -> T) -> Array<T> {
    let list = v as! Array<Any>
    return list.map(elementCaster)
}

public func castOrNull<T>(_ v: Any?, caster: (Any) throws -> T) -> T? {
    if v == nil || v is NSNull {
        return nil
    } else {
        return try! caster(v!)
    }
}

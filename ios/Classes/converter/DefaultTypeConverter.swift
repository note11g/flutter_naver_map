internal func asBool(_ v: Any) -> Bool {
    v as! Bool
}

internal func asFloat(_ v: Any) -> Float {
    Float(asDouble(v))
}

internal func asCGFloat(_ v: Any) -> CGFloat {
    CGFloat(asDouble(v))
}

internal func asDouble(_ v: Any) -> Double {
    v as! Double
}

internal func asRoundInt(rawFloat: Any) -> Int {
    Int(round(asDouble(rawFloat)))
}

internal func asInt(_ v: Any) -> Int {
    v as! Int
}

internal func asString(_ v: Any) -> String {
    v as! String
}

internal func asUint8Arr(_ v: Any) -> [UInt8] {
    v as! [UInt8]
}

internal func asDict(_ v: Any) -> Dictionary<String, Any> {
    v as! Dictionary<String, Any>
}

internal func asDict<T>(_ v: Any, valueCaster: (Any) throws -> T) -> Dictionary<String, T> {
    let dict = asDict(v)
    var newDict: Dictionary<String, T> = [:]
    for (k, v) in dict {
        newDict[k] = try! valueCaster(v)
    }
    return newDict
}

internal func asArr<T>(_ v: Any, elementCaster: (Any) throws -> T) -> Array<T> {
    let list = v as! Array<Any>
    return try! list.map(elementCaster)
}

internal func castOrNull<T>(_ v: Any?, caster: (Any) throws -> T) -> T? {
    if v == nil || v is NSNull {
        return nil
    } else {
        return try! caster(v!)
    }
}

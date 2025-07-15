import Foundation
import CoreGraphics

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

internal func asDict(_ v: Any) -> Dictionary<String, Any> {
    v as! Dictionary<String, Any>
}

internal func asNullableDict(_ v: Any) -> Dictionary<String, Any?> {
    v as! Dictionary<String, Any?>
}

internal func asDict<T>(_ v: Any, valueCaster: (Any) throws -> T) -> Dictionary<String, T> {
    let dict = asDict(v)
    var newDict: Dictionary<String, T> = [:]
    for (k, v) in dict {
        newDict[k] = try! valueCaster(v)
    }
    return newDict
}

internal func asStringDict(_ v: Any) -> Dictionary<String, String> {
    v as! Dictionary<String, String>
}

internal func asDictWithObjectKey<K, V>(_ v: Any, keyCaster: (Dictionary<String, Any>) throws -> K, valueCaster: (Any) throws -> V) -> Dictionary<K, V> {
    let dict = v as! Dictionary<AnyHashable, Any>
    var newDict: Dictionary<K, V> = [:]
    for (rawK, v) in dict {
        let k = try! keyCaster(rawK as! Dictionary<String, Any>)
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

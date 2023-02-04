struct NPoint {
    let x, y: Double

    var cgPoint: CGPoint {
        get {
            CGPoint.init(x: x, y: y)
        }
    }

    func toDict() -> Dictionary<String, Any> {
        [
            "x": x,
            "y": y
        ]
    }

    static func fromDict(_ args: Any) -> NPoint {
        let d = asDict(args, valueCaster: asDouble)
        return NPoint(x: d["x"]!, y: d["y"]!)
    }

    static func fromCGPoint(_ cgPoint: CGPoint) -> NPoint {
        NPoint(x: cgPoint.x, y: cgPoint.y)
    }
}
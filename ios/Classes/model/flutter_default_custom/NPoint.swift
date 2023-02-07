struct NPoint {
    let x, y: Double

    var cgPoint: CGPoint {
        CGPoint.init(x: x, y: y)
    }

    func toMessageable() -> Dictionary<String, Any> {
        [
            "x": x,
            "y": y
        ]
    }

    static func fromMessageable(_ args: Any) -> NPoint {
        let d = asDict(args, valueCaster: asDouble)
        return NPoint(x: d["x"]!, y: d["y"]!)
    }

    static func fromCGPoint(_ cgPoint: CGPoint) -> NPoint {
        NPoint(x: cgPoint.x, y: cgPoint.y)
    }
}
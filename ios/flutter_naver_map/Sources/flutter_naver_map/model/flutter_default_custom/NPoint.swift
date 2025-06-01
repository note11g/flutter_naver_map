import CoreGraphics

internal struct NPoint {
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

    static func fromCGPointWithDisplay(_ cgPoint: CGPoint) -> NPoint {
        NPoint(x: cgPoint.x, y: cgPoint.y)
    }

    static func fromCGPointWithOutDisplay(_ cgPoint: CGPoint) -> NPoint {
        NPoint(x: CalcUtil.float32To64(f32: cgPoint.x), y: CalcUtil.float32To64(f32: cgPoint.y))
    }
}

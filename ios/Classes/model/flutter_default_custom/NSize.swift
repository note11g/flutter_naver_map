import NMapsMap

struct NSize {
    let width, height: CGFloat

    func use(widthFun: (CGFloat) -> Void, heightFun: (CGFloat) -> Void) {
        widthFun(width)
        heightFun(height)
    }

    func toDict() -> Dictionary<String, Any> {
        [
            "width": width,
            "height": height
        ]
    }

    static func fromDict(_ args: Any) -> NSize {
        let d = asDict(args)
        return NSize(width: asCGFloat(d["width"]!), height: asCGFloat(d["height"]!))
    }
}
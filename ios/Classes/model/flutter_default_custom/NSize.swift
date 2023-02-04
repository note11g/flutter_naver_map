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
        let d = asDict(args, valueCaster: asCGFloat)
        return NSize(width: d["width"]!, height: d["height"]!)
    }
}
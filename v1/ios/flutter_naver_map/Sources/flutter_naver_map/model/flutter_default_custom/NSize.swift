import CoreGraphics

internal struct NSize {
    let width, height: CGFloat
    
    var isAutoSize: Bool {
        return self == Self.autoSize;
    }
    
    static let autoSize = NSize(width: 0.0, height: 0.0)

    func use(widthFun: (CGFloat) -> Void, heightFun: (CGFloat) -> Void) {
        widthFun(width)
        heightFun(height)
    }

    func toMessageable() -> Dictionary<String, Any> {
        [
            "width": width,
            "height": height
        ]
    }

    static func fromMessageable(_ args: Any) -> NSize {
        let d = asDict(args, valueCaster: asCGFloat)
        return NSize(width: d["width"]!, height: d["height"]!)
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.width == rhs.width && lhs.height == rhs.height
    }
}

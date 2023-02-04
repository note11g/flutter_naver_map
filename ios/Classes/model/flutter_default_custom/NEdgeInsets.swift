struct NEdgeInsets {
    let left: CGFloat
    let top: CGFloat
    let right: CGFloat
    let bottom: CGFloat

    var uiEdgeInsets: UIEdgeInsets {
        get {
            UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        }
    }

    static func fromDict(_ args: Any) -> NEdgeInsets {
        let d = asDict(args)
        return NEdgeInsets(
                left: asCGFloat(d["left"]!),
                top: asCGFloat(d["top"]!),
                right: asCGFloat(d["right"]!),
                bottom: asCGFloat(d["bottom"]!)
        )
    }
}

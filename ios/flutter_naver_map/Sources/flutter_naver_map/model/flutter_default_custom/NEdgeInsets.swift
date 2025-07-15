import UIKit

internal struct NEdgeInsets {
    let left: CGFloat
    let top: CGFloat
    let right: CGFloat
    let bottom: CGFloat

    var uiEdgeInsets: UIEdgeInsets {
        UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }

    static func fromMessageable(_ args: Any) -> NEdgeInsets {
        let d = asDict(args, valueCaster: asCGFloat)
        return NEdgeInsets(
                left: d["left"]!,
                top: d["top"]!,
                right: d["right"]!,
                bottom: d["bottom"]!
        )
    }
}

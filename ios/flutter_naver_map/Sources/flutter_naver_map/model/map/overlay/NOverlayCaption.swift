import UIKit

internal struct NOverlayCaption {
    let text: String
    let textSize: CGFloat
    let color: UIColor
    let haloColor: UIColor
    let minZoom: Double
    let maxZoom: Double
    let requestWidth: Double

    func toMessageable() -> Dictionary<String, Any> {
        [
            "text": text,
            "textSize": textSize,
            "color": color.toInt(),
            "haloColor": haloColor.toInt(),
            "minZoom": minZoom,
            "maxZoom": maxZoom,
            "requestWidth": requestWidth
        ]
    }

    static func fromMessageable(_ v: Any) -> NOverlayCaption {
        let d = asDict(v)
        return NOverlayCaption(
                text: asString(d["text"]!),
                textSize: asCGFloat(d["textSize"]!),
                color: asUIColor(d["color"]!),
                haloColor: asUIColor(d["haloColor"]!),
                minZoom: asDouble(d["minZoom"]!),
                maxZoom: asDouble(d["maxZoom"]!),
                requestWidth: asDouble(d["requestWidth"]!)
        )
    }
}

import NMapsMap

internal struct NCircleOverlay: AddableOverlay {
    typealias OverlayType = NMFCircleOverlay
    let info: NOverlayInfo
    let center: NMGLatLng
    let radius: Double
    let color: UIColor
    let outlineColor: UIColor
    let outlineWidth: Double

    func createMapOverlay() -> OverlayType {
        let overlay = NMFCircleOverlay(center, radius: radius)
        overlay.fillColor = color
        overlay.outlineColor = outlineColor
        overlay.outlineWidth = outlineWidth
        return overlay
    }

    func toMessageable() -> Dictionary<String, Any?> {
        [
            NCircleOverlay.infoName: info.toMessageable(),
            NCircleOverlay.centerName: center.toMessageable(),
            NCircleOverlay.radiusName: radius,
            NCircleOverlay.colorName: color.toInt(),
            NCircleOverlay.outlineColorName: outlineColor.toInt(),
            NCircleOverlay.outlineWidthName: outlineWidth
        ]
    }

    static func fromMessageable(_ v: Any) -> NCircleOverlay {
        let d = asDict(v)
        return NCircleOverlay(
                info: NOverlayInfo.fromMessageable(d[infoName]!),
                center: asLatLng(d[centerName]!),
                radius: asDouble(d[radiusName]!),
                color: asUIColor(d[colorName]!),
                outlineColor: asUIColor(d[outlineColorName]!),
                outlineWidth: asDouble(d[outlineWidthName]!)
        )
    }

    static func fromOverlay(_ overlay: NMFOverlay, id: String) -> NCircleOverlay {
        let o = overlay as! NMFCircleOverlay
        return NCircleOverlay(
                info: NOverlayInfo(type: .circleOverlay, id: id),
                center: o.center,
                radius: o.radius,
                color: o.fillColor,
                outlineColor: o.outlineColor,
                outlineWidth: o.outlineWidth
        )
    }

    /*
        --- Messaging Name Define ---
    */
    private static let infoName = "info"
    static let centerName = "center"
    static let radiusName = "radius"
    static let colorName = "color"
    static let outlineColorName = "outlineColor"
    static let outlineWidthName = "outlineWidth"
    static let boundsName = "bounds"
}
import NMapsMap

internal struct NCircleOverlay: AddableOverlay {
    typealias OverlayType = NMFCircleOverlay
    var overlayPayload: Dictionary<String, Any?> = [:]

    let info: NOverlayInfo
    let center: NMGLatLng
    let radius: Double
    let color: UIColor
    let outlineColor: UIColor
    let outlineWidth: Double

    func createMapOverlay() -> OverlayType {
        let overlay = NMFCircleOverlay(center, radius: radius)
        return applyAtRawOverlay(overlay)
    }
    
    func applyAtRawOverlay(_ overlay: NMFCircleOverlay) -> NMFCircleOverlay {
        overlay.fillColor = color
        overlay.outlineColor = outlineColor
        overlay.outlineWidth = outlineWidth
        return overlay
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

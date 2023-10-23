import NMapsMap

internal struct NGroundOverlay: AddableOverlay {
    typealias OverlayType = NMFGroundOverlay
    var overlayPayload: Dictionary<String, Any?> = [:]

    let info: NOverlayInfo
    let bounds: NMGLatLngBounds
    let minZoom: Double?
    let maxZoom: Double?
    let image: NOverlayImage
    let alpha: CGFloat

    func createMapOverlay() -> OverlayType {
        let overlay = NMFGroundOverlay(bounds: bounds, image: image.overlayImage)
        if let minZoom = minZoom {
            overlay.minZoom = minZoom
        }
        if let maxZoom = maxZoom {
            overlay.maxZoom = maxZoom
        }
        overlay.alpha = alpha
        return overlay
    }

    static func fromMessageable(_ v: Any) -> NGroundOverlay {
        let d = asDict(v)
        return NGroundOverlay(
                info: NOverlayInfo.fromMessageable(d[infoName]!),
                bounds: asLatLngBounds(d[boundsName]!),
                minZoom: castOrNull(d[minZoomName], caster: asDouble),
                maxZoom: castOrNull(d[maxZoomName], caster: asDouble),
                image: NOverlayImage.fromMessageable(d[imageName]!),
                alpha: asCGFloat(d[alphaName]!)
        )
    }

    /*
    --- Messaging Name Define ---
    */

    private static let infoName = "info"
    static let boundsName = "bounds"
    static let imageName = "image"
    static let alphaName = "alpha"
}

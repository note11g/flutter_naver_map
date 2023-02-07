import NMapsMap

struct NGroundOverlay: AddableOverlay {
    typealias OverlayType = NMFGroundOverlay

    let info: NOverlayInfo
    let bounds: NMGLatLngBounds
    let image: NOverlayImage
    let alpha: CGFloat

    func createMapOverlay() -> OverlayType {
        let overlay = NMFGroundOverlay(bounds: bounds, image: image.overlayImage)
        overlay.alpha = alpha
        return overlay
    }

    func toMessageable() -> Dictionary<String, Any?> {
        [
            NGroundOverlay.infoName: info.toMessageable(),
            NGroundOverlay.boundsName: bounds.toMessageable(),
            NGroundOverlay.imageName: image.toMessageable(),
            NGroundOverlay.alphaName: alpha
        ]
    }

    static func fromMessageable(_ v: Any) -> NGroundOverlay {
        let d = asDict(v)
        return NGroundOverlay(
                info: NOverlayInfo.fromMessageable(d[infoName]!),
                bounds: asLatLngBounds(d[boundsName]!),
                image: NOverlayImage.fromMessageable(d[imageName]!),
                alpha: asCGFloat(d[alphaName]!)
        )
    }

    static func fromOverlay(_ overlay: NMFOverlay, id: String) -> NGroundOverlay {
        let o = overlay as! NMFGroundOverlay
        return NGroundOverlay(
                info: NOverlayInfo(type: .groundOverlay, id: id),
                bounds: o.bounds,
                image: NOverlayImage.none,
                alpha: o.alpha
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
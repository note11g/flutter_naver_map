import NMapsMap

struct NGroundOverlay: AddableOverlay {
    typealias T = NMFGroundOverlay

    let info: NOverlayInfo
    let bounds: NMGLatLngBounds
    let image: NOverlayImage
    let alpha: CGFloat

    func createMapOverlay() -> NMFGroundOverlay {
        let overlay = NMFGroundOverlay(bounds: bounds, image: image.overlayImage)
        overlay.alpha = alpha
        return overlay
    }

    func toDict() -> Dictionary<String, Any?> {
        [
            NGroundOverlay.infoName: info.toDict(),
            NGroundOverlay.boundsName: bounds.toDict(),
            NGroundOverlay.imageName: image.toDict(),
            NGroundOverlay.alphaName: alpha
        ]
    }

    static func fromJson(_ v: Any) -> NGroundOverlay {
        let d = asDict(v)
        return NGroundOverlay(
                info: NOverlayInfo.fromDict(d[infoName]!),
                bounds: asLatLngBounds(d[boundsName]!),
                image: NOverlayImage.fromDict(d[imageName]!),
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
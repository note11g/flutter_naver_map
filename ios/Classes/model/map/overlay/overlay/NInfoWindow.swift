import NMapsMap

internal struct NInfoWindow: AddableOverlay {
    typealias OverlayType = NMFInfoWindow
    var overlayPayload: Dictionary<String, Any?> = [:]

    let info: NOverlayInfo
    let text: String
    let anchor: NPoint
    let alpha: CGFloat
    let position: NMGLatLng?
    let offsetX: Double
    let offsetY: Double

    func createMapOverlay() -> OverlayType {
        let infoWindow = NMFInfoWindow()
        infoWindow.dataSource = NInfoWindow.createTextSource(text);
        infoWindow.anchor = anchor.cgPoint
        infoWindow.alpha = alpha
        infoWindow.offsetX = asRoundInt(rawFloat: offsetX)
        infoWindow.offsetY = asRoundInt(rawFloat: offsetY)
        if let position = position {
            infoWindow.position = position
        }
        return infoWindow
    }

    static func fromMessageable(_ v: Any) -> NInfoWindow {
        let d = asDict(v)
        return NInfoWindow(
                info: NOverlayInfo.fromMessageable(d[infoName]!),
                text: asString(d[textName]!),
                anchor: NPoint.fromMessageable(d[anchorName]!),
                alpha: asDouble(d[alphaName]!),
                position: castOrNull(d[positionName], caster: asLatLng),
                offsetX: asDouble(d[offsetXName]!),
                offsetY: asDouble(d[offsetYName]!)
        )
    }

    static func createTextSource(_ text: String) -> NMFInfoWindowDefaultTextSource {
        let textSource = NMFInfoWindowDefaultTextSource.data()
        textSource.title = text
        return textSource
    }

    /*
        --- Messaging Name Define ---
    */
    private static let infoName = "info"
    static let textName = "text"
    static let anchorName = "anchor"
    static let alphaName = "alpha"
    static let positionName = "position"
    static let offsetXName = "offsetX"
    static let offsetYName = "offsetY"
    static let closeName = "close"
}
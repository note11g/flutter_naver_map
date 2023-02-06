import NMapsMap

struct NInfoWindow: AddableOverlay {
    typealias OverlayType = NMFInfoWindow

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

    func toDict() -> Dictionary<String, Any?> {
        [
            NInfoWindow.infoName: info.toDict(),
            NInfoWindow.textName: text,
            NInfoWindow.anchorName: anchor.toDict(),
            NInfoWindow.alphaName: alpha,
            NInfoWindow.positionName: position?.toDict(),
            NInfoWindow.offsetXName: offsetX,
            NInfoWindow.offsetYName: offsetY
        ]
    }

    static func fromJson(_ v: Any) -> NInfoWindow {
        let d = asDict(v)
        return NInfoWindow(
                info: NOverlayInfo.fromDict(d[infoName]!),
                text: asString(d[textName]!),
                anchor: NPoint.fromDict(d[anchorName]!),
                alpha: asDouble(d[alphaName]!),
                position: castOrNull(d[positionName], caster: asLatLng),
                offsetX: asDouble(d[offsetXName]!),
                offsetY: asDouble(d[offsetYName]!)
        )
    }

    static func fromOverlay(_ overlay: NMFOverlay, id: String) -> NInfoWindow {
        let infoWindow = overlay as! NMFInfoWindow
        return NInfoWindow(
                info: NOverlayInfo(type: .infoWindow, id: id),
                text: "",
                anchor: NPoint.fromCGPoint(infoWindow.anchor),
                alpha: infoWindow.alpha,
                position: infoWindow.position,
                offsetX: Double(infoWindow.offsetX),
                offsetY: Double(infoWindow.offsetY)
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
import NMapsMap

internal struct NPolygonOverlay: AddableOverlay {
    typealias OverlayType = NMFPolygonOverlay
    var overlayPayload: Dictionary<String, Any?> = [:]

    let info: NOverlayInfo
    let coords: Array<NMGLatLng>
    let color: UIColor
    let holes: Array<Array<NMGLatLng>>
    let outlineColor: UIColor
    let outlineWidth: Double

    func createMapOverlay() -> OverlayType {
        let polygon = NMGPolygon(
                ring: NMGLineString(points: coords),
                interiorRings: holes.map({ NMGLineString(points: $0) })
        )
        let overlay = NMFPolygonOverlay(polygon as! NMGPolygon<AnyObject>)!
        overlay.fillColor = color
        overlay.outlineColor = outlineColor
        overlay.outlineWidth = UInt(round(outlineWidth))
        return overlay
    }

    static func fromMessageable(_ v: Any) -> NPolygonOverlay {
        let d = asDict(v)
        return NPolygonOverlay(
                info: NOverlayInfo.fromMessageable(d[infoName]!),
                coords: asArr(d[coordsName]!, elementCaster: asLatLng),
                color: asUIColor(d[colorName]!),
                holes: asArr(d[holesName]!, elementCaster: { asArr($0, elementCaster: asLatLng) }),
                outlineColor: asUIColor(d[outlineColorName]!),
                outlineWidth: asDouble(d[outlineWidthName]!)
        )
    }

    /*
        --- Messaging Name Define ---
    */
    private static let infoName = "info"
    static let coordsName = "coords"
    static let colorName = "color"
    static let holesName = "holes"
    static let outlineColorName = "outlineColor"
    static let outlineWidthName = "outlineWidth"
    static let boundsName = "bounds"
}
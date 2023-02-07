import NMapsMap

struct NPolygonOverlay: AddableOverlay {
    typealias OverlayType = NMFPolygonOverlay

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

    func toMessageable() -> Dictionary<String, Any?> {
        [
            NPolygonOverlay.infoName: info.toMessageable(),
            NPolygonOverlay.coordsName: coords.map({ $0.toMessageable() }),
            NPolygonOverlay.colorName: color.toInt(),
            NPolygonOverlay.holesName: holes.map({ $0.map({ $0.toMessageable() }) }),
            NPolygonOverlay.outlineColorName: outlineColor.toInt(),
            NPolygonOverlay.outlineWidthName: outlineWidth,
        ]
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

    static func fromOverlay(_ overlay: NMFOverlay, id: String) -> NPolygonOverlay {
        let polygon = overlay as! NMFPolygonOverlay
        return NPolygonOverlay(
                info: NOverlayInfo(type: .polygonOverlay, id: id),
                coords: polygon.polygon.exteriorRing.latLngPoints,
                color: polygon.fillColor,
                holes: polygon.polygon.interiorRings.map({ $0.latLngPoints }),
                outlineColor: polygon.outlineColor,
                outlineWidth: Double(polygon.outlineWidth)
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
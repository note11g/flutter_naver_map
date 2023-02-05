import NMapsMap

struct NPolygonOverlay: AddableOverlay {
    typealias T = NMFPolygonOverlay

    let info: NOverlayInfo
    let coords: Array<NMGLatLng>
    let color: UIColor
    let holes: Array<Array<NMGLatLng>>
    let outlineColor: UIColor
    let outlineWidth: Double

    func createMapOverlay() -> NMFPolygonOverlay {
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

    func toDict() -> Dictionary<String, Any?> {
        [
            NPolygonOverlay.infoName: info.toDict(),
            NPolygonOverlay.coordsName: coords.map({ $0.toDict() }),
            NPolygonOverlay.colorName: color.toInt(),
            NPolygonOverlay.holesName: holes.map({ $0.map({ $0.toDict() }) }),
            NPolygonOverlay.outlineColorName: outlineColor.toInt(),
            NPolygonOverlay.outlineWidthName: outlineWidth,
        ]
    }

    static func fromJson(_ v: Any) -> NPolygonOverlay {
        let d = asDict(v)
        return NPolygonOverlay(
                info: NOverlayInfo.fromDict(d[infoName]!),
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
                coords: polygon.polygon.exteriorRing.points.map({ $0.toLatLng() }),
                color: polygon.fillColor,
                holes: polygon.polygon.interiorRings.map({ $0.points.map({ $0.toLatLng() }) }),
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
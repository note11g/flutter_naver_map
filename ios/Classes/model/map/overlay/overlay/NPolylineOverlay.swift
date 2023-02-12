import NMapsMap

internal struct NPolylineOverlay: AddableOverlay {
    typealias OverlayType = NMFPolylineOverlay

    let info: NOverlayInfo
    let coords: Array<NMGLatLng>
    let color: UIColor
    let width: Double
    let lineCap: NMFOverlayLineCap
    let lineJoin: NMFOverlayLineJoin
    let pattern: Array<NSNumber>

    func createMapOverlay() -> OverlayType {
        let polyline = NMFPolylineOverlay()
        polyline.line = NMGLineString(points: coords)
        polyline.color = color
        polyline.width = CGFloat(width)
        polyline.capType = lineCap
        polyline.joinType = lineJoin
        polyline.pattern = pattern
        return polyline
    }

    func toMessageable() -> Dictionary<String, Any?> {
        [
            NPolylineOverlay.infoName: info.toMessageable(),
            NPolylineOverlay.coordsName: coords.map {
                $0.toMessageable()
            },
            NPolylineOverlay.colorName: color.toInt(),
            NPolylineOverlay.widthName: width,
            NPolylineOverlay.lineCapName: lineCap.toMessageableString(),
            NPolylineOverlay.lineJoinName: lineJoin.toMessageableString(),
            NPolylineOverlay.patternName: pattern.map {
                $0.intValue
            },
        ]
    }

    static func fromMessageable(_ v: Any) -> NPolylineOverlay {
        let d = asDict(v)
        return NPolylineOverlay(
                info: NOverlayInfo.fromMessageable(d[infoName]!),
                coords: asArr(d[coordsName]!, elementCaster: asLatLng),
                color: asUIColor(d[colorName]!),
                width: asDouble(d[widthName]!),
                lineCap: asLineCap(d[lineCapName]!),
                lineJoin: asLineJoin(d[lineJoinName]!),
                pattern: asArr(d[patternName]!) {
                    NSNumber(value: asRoundInt(rawFloat: $0))
                }
        )
    }

    static func fromOverlay(_ overlay: NMFOverlay, id: String) -> NPolylineOverlay {
        let polyline = overlay as! NMFPolylineOverlay
        return NPolylineOverlay(
                info: NOverlayInfo(type: .polylineOverlay, id: id),
                coords: polyline.line.latLngPoints,
                color: polyline.color,
                width: Double(polyline.width),
                lineCap: polyline.capType,
                lineJoin: polyline.joinType,
                pattern: polyline.pattern
        )
    }

    /*
        --- Messaging Name Define ---
    */
    private static let infoName = "info"
    static let coordsName = "coords";
    static let colorName = "color";
    static let widthName = "width";
    static let lineCapName = "lineCap";
    static let lineJoinName = "lineJoin";
    static let patternName = "pattern";
    static let boundsName = "bounds";
}
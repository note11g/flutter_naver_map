import NMapsMap

internal struct NPolylineOverlay: AddableOverlay {
    typealias OverlayType = NMFPolylineOverlay
    var overlayPayload: Dictionary<String, Any?> = [:]

    let info: NOverlayInfo
    let coords: Array<NMGLatLng>
    let color: UIColor
    let width: Double
    let lineCap: NMFOverlayLineCap
    let lineJoin: NMFOverlayLineJoin
    let pattern: Array<NSNumber>

    func createMapOverlay() -> OverlayType {
        let polyline = NMFPolylineOverlay()
        return applyAtRawOverlay(polyline)
    }
    
    func applyAtRawOverlay(_ polyline: NMFPolylineOverlay) -> NMFPolylineOverlay {
        polyline.line = NMGLineString(points: coords)
        polyline.color = color
        polyline.width = CGFloat(width)
        polyline.capType = lineCap
        polyline.joinType = lineJoin
        polyline.pattern = pattern
        return polyline
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
                    NSNumber(value: asDouble($0))
                }
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

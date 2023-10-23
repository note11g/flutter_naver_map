import NMapsMap

internal struct NPolylineOverlay: AddableOverlay {
    typealias OverlayType = NMFPolylineOverlay
    var overlayPayload: Dictionary<String, Any?> = [:]

    let info: NOverlayInfo
    let coords: Array<NMGLatLng>
    let minZoom: Double?
    let maxZoom: Double?
    let color: UIColor
    let width: Double
    let lineCap: NMFOverlayLineCap
    let lineJoin: NMFOverlayLineJoin
    let pattern: Array<NSNumber>

    func createMapOverlay() -> OverlayType {
        let polyline = NMFPolylineOverlay()
        polyline.line = NMGLineString(points: coords)
        if let minZoom = minZoom {
            polyline.minZoom = minZoom
        }
        if let maxZoom = maxZoom {
            polyline.maxZoom = maxZoom
        }
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
                minZoom: castOrNull(d[minZoomName], caster: asDouble),
                maxZoom: castOrNull(d[maxZoomName], caster: asDouble),
                color: asUIColor(d[colorName]!),
                width: asDouble(d[widthName]!),
                lineCap: asLineCap(d[lineCapName]!),
                lineJoin: asLineJoin(d[lineJoinName]!),
                pattern: asArr(d[patternName]!) {
                    NSNumber(value: asRoundInt(rawFloat: $0))
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

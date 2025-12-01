import NMapsMap

internal struct NArrowheadPathOverlay: AddableOverlay {
    typealias OverlayType = NMFArrowheadPath
    var overlayPayload: Dictionary<String, Any?> = [:]

    let info: NOverlayInfo
    let coords: Array<NMGLatLng>
    let width: CGFloat
    let color: UIColor
    let outlineWidth: CGFloat
    let outlineColor: UIColor
    let elevation: CGFloat
    let headSizeRatio: CGFloat

    func createMapOverlay() -> OverlayType {
        let path = NMFArrowheadPath()
        return applyAtRawOverlay(path)
    }
    
    func applyAtRawOverlay(_ path: NMFArrowheadPath) -> NMFArrowheadPath {
        path.points = coords
        path.width = width
        path.color = color
        path.outlineWidth = outlineWidth
        path.outlineColor = outlineColor
        path.elevation = elevation
        path.headSizeRatio = headSizeRatio
        return path
    }

    static func fromMessageable(_ v: Any) -> NArrowheadPathOverlay {
        let d = asDict(v)
        return NArrowheadPathOverlay(
                info: NOverlayInfo.fromMessageable(d[infoName]!),
                coords: asArr(d[coordsName]!, elementCaster: asLatLng),
                width: asCGFloat(d[widthName]!),
                color: asUIColor(d[colorName]!),
                outlineWidth: asCGFloat(d[outlineWidthName]!),
                outlineColor: asUIColor(d[outlineColorName]!),
                elevation: asCGFloat(d[elevationName]!),
                headSizeRatio: asCGFloat(d[headSizeRatioName]!)
        )
    }

    /*
        --- Messaging Name Define ---
    */
    private static let infoName = "info"
    static let coordsName = "coords"
    static let widthName = "width"
    static let colorName = "color"
    static let outlineWidthName = "outlineWidth"
    static let outlineColorName = "outlineColor"
    static let elevationName = "elevation"
    static let headSizeRatioName = "headSizeRatio"
    static let boundsName = "bounds"
}

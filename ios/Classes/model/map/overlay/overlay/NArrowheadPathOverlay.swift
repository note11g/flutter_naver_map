import NMapsMap

struct NArrowheadPathOverlay: AddableOverlay {
    typealias OverlayType = NMFArrowheadPath

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
        path.points = coords
        path.width = width
        path.color = color
        path.outlineWidth = outlineWidth
        path.outlineColor = outlineColor
        path.elevation = elevation
        path.headSizeRatio = headSizeRatio
        return path
    }

    func toMessageable() -> Dictionary<String, Any?> {
        [
            NArrowheadPathOverlay.infoName: info.toMessageable(),
            NArrowheadPathOverlay.coordsName: coords.map {
                $0.toMessageable()
            },
            NArrowheadPathOverlay.widthName: width,
            NArrowheadPathOverlay.colorName: color.toInt(),
            NArrowheadPathOverlay.outlineWidthName: outlineWidth,
            NArrowheadPathOverlay.outlineColorName: outlineColor.toInt(),
            NArrowheadPathOverlay.elevationName: elevation,
            NArrowheadPathOverlay.headSizeRatioName: headSizeRatio,
        ]
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

    static func fromOverlay(_ overlay: NMFOverlay, id: String) -> NArrowheadPathOverlay {
        let path = overlay as! NMFArrowheadPath
        return NArrowheadPathOverlay(
                info: NOverlayInfo(type: .arrowheadPathOverlay, id: id),
                coords: path.points,
                width: path.width,
                color: path.color,
                outlineWidth: path.outlineWidth,
                outlineColor: path.outlineColor,
                elevation: path.elevation,
                headSizeRatio: path.headSizeRatio
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
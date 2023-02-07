import NMapsMap

internal struct NPathOverlay: AddableOverlay {
    typealias OverlayType = NMFPath

    let info: NOverlayInfo
    let coords: Array<NMGLatLng>
    let width: CGFloat
    let color: UIColor
    let outlineWidth: CGFloat
    let outlineColor: UIColor
    let passedColor: UIColor
    let passedOutlineColor: UIColor
    let progress: Double
    let patternImage: NOverlayImage?
    let patternInterval: Double
    let isHideCollidedCaptions: Bool
    let isHideCollidedMarkers: Bool
    let isHideCollidedSymbols: Bool

    func createMapOverlay() -> OverlayType {
        let overlay = NMFPath()
        overlay.path = NMGLineString(points: coords)
        overlay.width = width
        overlay.color = color
        overlay.outlineWidth = outlineWidth
        overlay.outlineColor = outlineColor
        overlay.passedColor = passedColor
        overlay.passedOutlineColor = passedOutlineColor
        overlay.progress = progress
        overlay.patternIcon = patternImage?.overlayImage
        overlay.patternInterval = UInt(round(patternInterval))
        overlay.isHideCollidedCaptions = isHideCollidedCaptions
        overlay.isHideCollidedMarkers = isHideCollidedMarkers
        overlay.isHideCollidedSymbols = isHideCollidedSymbols
        return overlay
    }

    func toMessageable() -> Dictionary<String, Any?> {
        [
            NPathOverlay.infoName: info.toMessageable(),
            NPathOverlay.coordsName: coords.map {
                $0.toMessageable()
            },
            NPathOverlay.widthName: width,
            NPathOverlay.colorName: color.toInt(),
            NPathOverlay.outlineWidthName: outlineWidth,
            NPathOverlay.outlineColorName: outlineColor.toInt(),
            NPathOverlay.passedColorName: passedColor.toInt(),
            NPathOverlay.passedOutlineColorName: passedOutlineColor.toInt(),
            NPathOverlay.progressName: progress,
            NPathOverlay.patternImageName: patternImage?.toMessageable(),
            NPathOverlay.patternIntervalName: patternInterval,
            NPathOverlay.isHideCollidedCaptionsName: isHideCollidedCaptions,
            NPathOverlay.isHideCollidedMarkersName: isHideCollidedMarkers,
            NPathOverlay.isHideCollidedSymbolsName: isHideCollidedSymbols,
        ]
    }

    static func fromMessageable(_ v: Any) -> NPathOverlay {
        let d = asDict(v)
        return NPathOverlay(
                info: NOverlayInfo.fromMessageable(d[infoName]!),
                coords: asArr(d[coordsName]!, elementCaster: asLatLng),
                width: asCGFloat(d[widthName]!),
                color: asUIColor(d[colorName]!),
                outlineWidth: asCGFloat(d[outlineWidthName]!),
                outlineColor: asUIColor(d[outlineColorName]!),
                passedColor: asUIColor(d[passedColorName]!),
                passedOutlineColor: asUIColor(d[passedOutlineColorName]!),
                progress: asDouble(d[progressName]!),
                patternImage: castOrNull(d[patternImageName], caster: NOverlayImage.fromMessageable),
                patternInterval: asDouble(d[patternIntervalName]!),
                isHideCollidedCaptions: asBool(d[isHideCollidedCaptionsName]!),
                isHideCollidedMarkers: asBool(d[isHideCollidedMarkersName]!),
                isHideCollidedSymbols: asBool(d[isHideCollidedSymbolsName]!)
        )
    }

    static func fromOverlay(_ overlay: NMFOverlay, id: String) -> NPathOverlay {
        let path = overlay as! NMFPath
        return NPathOverlay(
                info: NOverlayInfo(type: .pathOverlay, id: id),
                coords: path.path.points.map {
                    $0.toLatLng()
                },
                width: path.width,
                color: path.color,
                outlineWidth: path.outlineWidth,
                outlineColor: path.outlineColor,
                passedColor: path.passedColor,
                passedOutlineColor: path.passedOutlineColor,
                progress: path.progress,
                patternImage: NOverlayImage.none,
                patternInterval: Double(path.patternInterval),
                isHideCollidedCaptions: path.isHideCollidedCaptions,
                isHideCollidedMarkers: path.isHideCollidedMarkers,
                isHideCollidedSymbols: path.isHideCollidedSymbols
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
    static let passedColorName = "passedColor"
    static let passedOutlineColorName = "passedOutlineColor"
    static let progressName = "progress"
    static let patternImageName = "patternImage"
    static let patternIntervalName = "patternInterval"
    static let isHideCollidedCaptionsName = "isHideCollidedCaptions"
    static let isHideCollidedMarkersName = "isHideCollidedMarkers"
    static let isHideCollidedSymbolsName = "isHideCollidedSymbols"
    static let boundsName = "bounds"
}
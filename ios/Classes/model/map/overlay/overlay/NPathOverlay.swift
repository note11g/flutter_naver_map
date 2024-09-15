import NMapsMap

internal struct NPathOverlay: AddableOverlay {
    typealias OverlayType = NMFPath
    var overlayPayload: Dictionary<String, Any?> = [:]

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
        return applyAtRawOverlay(overlay)
    }
    
    func applyAtRawOverlay(_ overlay: NMFPath) -> NMFPath {
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

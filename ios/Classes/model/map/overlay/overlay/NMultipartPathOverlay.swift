import NMapsMap

internal struct NMultipartPathOverlay: AddableOverlay {
    typealias OverlayType = NMFMultipartPath
    var overlayPayload: Dictionary<String, Any?> = [:]

    let info: NOverlayInfo
    let paths: Array<NMultipartPath>
    let width: CGFloat
    let outlineWidth: CGFloat
    let patternImage: NOverlayImage?
    let patternInterval: Double
    let progress: CGFloat
    let isHideCollidedCaptions: Bool
    let isHideCollidedMarkers: Bool
    let isHideCollidedSymbols: Bool

    func createMapOverlay() -> OverlayType {
        let overlay = NMFMultipartPath()
        return applyAtRawOverlay(overlay)
    }
    
    func applyAtRawOverlay(_ overlay: NMFMultipartPath) -> NMFMultipartPath {
        paths.applyLineAndColor(linePartsFun: { overlay.lineParts = $0 }, colorPartsFun: { overlay.colorParts = $0 })
        overlay.width = width
        overlay.outlineWidth = outlineWidth
        overlay.patternIcon = patternImage?.overlayImage
        overlay.patternInterval = UInt(round(patternInterval))
        overlay.progress = progress
        overlay.isHideCollidedCaptions = isHideCollidedCaptions
        overlay.isHideCollidedMarkers = isHideCollidedMarkers
        overlay.isHideCollidedSymbols = isHideCollidedSymbols
        return overlay
    }

    static func fromMessageable(_ v: Any) -> NMultipartPathOverlay {
        let d = asDict(v)
        return NMultipartPathOverlay(
                info: NOverlayInfo.fromMessageable(d[infoName]!),
                paths: asArr(d[pathsName]!, elementCaster: NMultipartPath.fromMessageable),
                width: asCGFloat(d[widthName]!),
                outlineWidth: asCGFloat(d[outlineWidthName]!),
                patternImage: castOrNull(d[patternImageName], caster: NOverlayImage.fromMessageable),
                patternInterval: asDouble(d[patternIntervalName]!),
                progress: asCGFloat(d[progressName]!),
                isHideCollidedCaptions: asBool(d[isHideCollidedCaptionsName]!),
                isHideCollidedMarkers: asBool(d[isHideCollidedMarkersName]!),
                isHideCollidedSymbols: asBool(d[isHideCollidedSymbolsName]!)
        )
    }

    /*
        --- Messaging Name Define ---
    */
    private static let infoName = "info"
    static let pathsName = "paths"
    static let widthName = "width"
    static let outlineWidthName = "outlineWidth"
    static let patternImageName = "patternImage"
    static let patternIntervalName = "patternInterval"
    static let progressName = "progress"
    static let isHideCollidedCaptionsName = "isHideCollidedCaptions"
    static let isHideCollidedMarkersName = "isHideCollidedMarkers"
    static let isHideCollidedSymbolsName = "isHideCollidedSymbols"
    static let boundsName = "bounds"
}

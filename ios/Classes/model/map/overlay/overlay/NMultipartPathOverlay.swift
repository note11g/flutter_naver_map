import NMapsMap

struct NMultipartPathOverlay: AddableOverlay {
    typealias OverlayType = NMFMultipartPath

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

    func toMessageable() -> Dictionary<String, Any?> {
        [
            NMultipartPathOverlay.infoName: info.toMessageable(),
            NMultipartPathOverlay.pathsName: paths.map {
                $0.toMessageable()
            },
            NMultipartPathOverlay.widthName: width,
            NMultipartPathOverlay.outlineWidthName: outlineWidth,
            NMultipartPathOverlay.patternImageName: patternImage?.toMessageable(),
            NMultipartPathOverlay.patternIntervalName: patternInterval,
            NMultipartPathOverlay.progressName: progress,
            NMultipartPathOverlay.isHideCollidedCaptionsName: isHideCollidedCaptions,
            NMultipartPathOverlay.isHideCollidedMarkersName: isHideCollidedMarkers,
            NMultipartPathOverlay.isHideCollidedSymbolsName: isHideCollidedSymbols,
        ]
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

    static func fromOverlay(_ overlay: NMFOverlay, id: String) -> NMultipartPathOverlay {
        let overlay = overlay as! NMFMultipartPath
        var path: Array<NMultipartPath> = []
        for (i, line) in overlay.lineParts.enumerated() {
            path.append(NMultipartPath.fromCoordsAndColorParts(
                    coords: line.latLngPoints,
                    colorPart: overlay.colorParts[i]
            ))
        }

        return NMultipartPathOverlay(
                info: NOverlayInfo(type: .multipartPathOverlay, id: id),
                paths: path,
                width: overlay.width,
                outlineWidth: overlay.outlineWidth,
                patternImage: NOverlayImage.none,
                patternInterval: Double(overlay.patternInterval),
                progress: overlay.progress,
                isHideCollidedCaptions: overlay.isHideCollidedCaptions,
                isHideCollidedMarkers: overlay.isHideCollidedMarkers,
                isHideCollidedSymbols: overlay.isHideCollidedSymbols
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
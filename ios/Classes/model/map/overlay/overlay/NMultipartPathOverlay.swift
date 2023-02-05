import NMapsMap

struct NMultipartPathOverlay: AddableOverlay {
    typealias T = NMFMultipartPath

    let info: NOverlayInfo
    let path: Array<NMultipartPath>
    let width: CGFloat
    let outlineWidth: CGFloat
    let patternImage: NOverlayImage?
    let patternInterval: Double
    let progress: CGFloat
    let isHideCollidedCaptions: Bool
    let isHideCollidedMarkers: Bool
    let isHideCollidedSymbols: Bool

    func createMapOverlay() -> NMFMultipartPath {
        let overlay = NMFMultipartPath()
        var coords = overlay.lineParts
        var colors: Array<NMFPathColor> = []
        for path in path {
            coords.append(NMGLineString(points: path.coords))
            colors.append(path.colorPart)
        }
        overlay.lineParts = coords
        overlay.colorParts = colors
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

    func toDict() -> Dictionary<String, Any?> {
        [
            NMultipartPathOverlay.infoName: info.toDict(),
            NMultipartPathOverlay.pathsName: path.map {
                $0.toDict()
            },
            NMultipartPathOverlay.widthName: width,
            NMultipartPathOverlay.outlineWidthName: outlineWidth,
            NMultipartPathOverlay.patternImageName: patternImage?.toDict(),
            NMultipartPathOverlay.patternIntervalName: patternInterval,
            NMultipartPathOverlay.progressName: progress,
            NMultipartPathOverlay.isHideCollidedCaptionsName: isHideCollidedCaptions,
            NMultipartPathOverlay.isHideCollidedMarkersName: isHideCollidedMarkers,
            NMultipartPathOverlay.isHideCollidedSymbolsName: isHideCollidedSymbols,
        ]
    }

    static func fromJson(_ v: Any) -> NMultipartPathOverlay {
        let d = asDict(v)
        return NMultipartPathOverlay(
                info: NOverlayInfo.fromDict(d[infoName]!),
                path: asArr(d[pathsName]!, elementCaster: NMultipartPath.fromDict),
                width: asCGFloat(d[widthName]!),
                outlineWidth: asCGFloat(d[outlineWidthName]!),
                patternImage: castOrNull(d[patternImageName], caster: NOverlayImage.fromDict),
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
                    coords: line.points.map({ $0.toLatLng() }), // todo : test
                    colorPart: overlay.colorParts[i]
            ))
        }

        return NMultipartPathOverlay(
                info: NOverlayInfo(type: .multipartPathOverlay, id: id),
                path: path,
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
import NMapsMap
import Flutter

internal protocol PathOverlayHandler: OverlayHandler {
    func setCoords(_ pathOverlay: NMFPath, rawCoords: Any)

    func setWidth(_ pathOverlay: NMFPath, rawWidthDp: Any)

    func setColor(_ pathOverlay: NMFPath, rawColor: Any)

    func setOutlineWidth(_ pathOverlay: NMFPath, rawWidthDp: Any)

    func setOutlineColor(_ pathOverlay: NMFPath, rawColor: Any)

    func setPassedColor(_ pathOverlay: NMFPath, rawColor: Any)

    func setPassedOutlineColor(_ pathOverlay: NMFPath, rawColor: Any)

    func setProgress(_ pathOverlay: NMFPath, rawProgress: Any)

    func setPatternImage(_ pathOverlay: NMFPath, rawNOverlayImage: Any)

    func setPatternInterval(_ pathOverlay: NMFPath, rawInterval: Any)

    func setIsHideCollidedCaptions(_ pathOverlay: NMFPath, rawFlag: Any)

    func setIsHideCollidedMarkers(_ pathOverlay: NMFPath, rawFlag: Any)

    func setIsHideCollidedSymbols(_ pathOverlay: NMFPath, rawFlag: Any)

    func getBounds(_ pathOverlay: NMFPath, success: (_ bounds: Dictionary<String, Any>) -> Void)
}

internal extension  PathOverlayHandler {
    func handlePathOverlay(pathOverlay: NMFOverlay,
                           method: String,
                           args: Any?,
                           result: @escaping FlutterResult) {
        let pathOverlay = pathOverlay as! NMFPath
        switch method {
        case NPathOverlay.coordsName: setCoords(pathOverlay, rawCoords: args!)
        case NPathOverlay.widthName: setWidth(pathOverlay, rawWidthDp: args!)
        case NPathOverlay.colorName: setColor(pathOverlay, rawColor: args!)
        case NPathOverlay.outlineWidthName: setOutlineWidth(pathOverlay, rawWidthDp: args!)
        case NPathOverlay.outlineColorName: setOutlineColor(pathOverlay, rawColor: args!)
        case NPathOverlay.passedColorName: setPassedColor(pathOverlay, rawColor: args!)
        case NPathOverlay.passedOutlineColorName: setPassedOutlineColor(pathOverlay, rawColor: args!)
        case NPathOverlay.progressName: setProgress(pathOverlay, rawProgress: args!)
        case NPathOverlay.patternImageName: setPatternImage(pathOverlay, rawNOverlayImage: args!)
        case NPathOverlay.patternIntervalName: setPatternInterval(pathOverlay, rawInterval: args!)
        case NPathOverlay.isHideCollidedCaptionsName: setIsHideCollidedCaptions(pathOverlay, rawFlag: args!)
        case NPathOverlay.isHideCollidedMarkersName: setIsHideCollidedMarkers(pathOverlay, rawFlag: args!)
        case NPathOverlay.isHideCollidedSymbolsName: setIsHideCollidedSymbols(pathOverlay, rawFlag: args!)
        case getterName(NPathOverlay.boundsName): getBounds(pathOverlay, success: result)
        default: result(FlutterMethodNotImplemented)
        }
    }
}

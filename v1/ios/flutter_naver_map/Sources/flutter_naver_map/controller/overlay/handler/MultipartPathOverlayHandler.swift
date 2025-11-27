import NMapsMap
import Flutter

internal protocol MultipartPathOverlayHandler: OverlayHandler {
    func setPaths(_ multipartPathOverlay: NMFMultipartPath, rawPaths: Any)

    func setWidth(_ multipartPathOverlay: NMFMultipartPath, rawWidthDp: Any)

    func setOutlineWidth(_ multipartPathOverlay: NMFMultipartPath, rawWidth: Any)

    func setPatternImage(_ multipartPathOverlay: NMFMultipartPath, rawNOverlayImage: Any)

    func setPatternInterval(_ multipartPathOverlay: NMFMultipartPath, rawInterval: Any)

    func setProgress(_ multipartPathOverlay: NMFMultipartPath, rawProgress: Any)

    func setIsHideCollidedCaptions(_ multipartPathOverlay: NMFMultipartPath, rawFlag: Any)

    func setIsHideCollidedMarkers(_ multipartPathOverlay: NMFMultipartPath, rawFlag: Any)

    func setIsHideCollidedSymbols(_ multipartPathOverlay: NMFMultipartPath, rawFlag: Any)

    func getBounds(_ multipartPathOverlay: NMFMultipartPath, success: (_ bounds: Dictionary<String, Any>) -> Void)
}

internal extension  MultipartPathOverlayHandler {
    func handleMultipartPathOverlay(multipartPathOverlay: NMFOverlay,
                                    method: String,
                                    args: Any?,
                                    result: @escaping FlutterResult) {
        let multipartPathOverlay = multipartPathOverlay as! NMFMultipartPath
        switch method {
        case NMultipartPathOverlay.pathsName: setPaths(multipartPathOverlay, rawPaths: args!)
        case NMultipartPathOverlay.widthName: setWidth(multipartPathOverlay, rawWidthDp: args!)
        case NMultipartPathOverlay.outlineWidthName: setOutlineWidth(multipartPathOverlay, rawWidth: args!)
        case NMultipartPathOverlay.patternImageName: setPatternImage(multipartPathOverlay, rawNOverlayImage: args!)
        case NMultipartPathOverlay.patternIntervalName: setPatternInterval(multipartPathOverlay, rawInterval: args!)
        case NMultipartPathOverlay.progressName: setProgress(multipartPathOverlay, rawProgress: args!)
        case NMultipartPathOverlay.isHideCollidedCaptionsName: setIsHideCollidedCaptions(multipartPathOverlay, rawFlag: args!)
        case NMultipartPathOverlay.isHideCollidedMarkersName: setIsHideCollidedMarkers(multipartPathOverlay, rawFlag: args!)
        case NMultipartPathOverlay.isHideCollidedSymbolsName: setIsHideCollidedSymbols(multipartPathOverlay, rawFlag: args!)
        case getterName(NMultipartPathOverlay.boundsName): getBounds(multipartPathOverlay, success: result)
        default: result(FlutterMethodNotImplemented)
        }
    }
}

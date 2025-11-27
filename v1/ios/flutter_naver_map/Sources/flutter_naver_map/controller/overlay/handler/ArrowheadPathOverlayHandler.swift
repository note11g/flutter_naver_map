import NMapsMap
import Flutter

internal protocol ArrowheadPathOverlayHandler: OverlayHandler {
    func setCoords(_ arrowheadPathOverlay: NMFArrowheadPath, rawCoords: Any)

    func setWidth(_ arrowheadPathOverlay: NMFArrowheadPath, rawWidth: Any)

    func setColor(_ arrowheadPathOverlay: NMFArrowheadPath, rawColor: Any)

    func setOutlineWidth(_ arrowheadPathOverlay: NMFArrowheadPath, rawWidth: Any)

    func setOutlineColor(_ arrowheadPathOverlay: NMFArrowheadPath, rawColor: Any)

    func setElevation(_ arrowheadPathOverlay: NMFArrowheadPath, rawElevation: Any)

    func setHeadSizeRatio(_ arrowheadPathOverlay: NMFArrowheadPath, rawRatio: Any)

    func getBounds(_ arrowheadPathOverlay: NMFArrowheadPath, success: (_ bounds: Dictionary<String, Any>) -> Void)
}

internal extension  ArrowheadPathOverlayHandler {
    func handleArrowheadPathOverlay(
            arrowheadPathOverlay: NMFOverlay,
            method: String,
            args: Any?,
            result: @escaping FlutterResult) {
        let arrowheadPathOverlay = arrowheadPathOverlay as! NMFArrowheadPath
        switch method {
        case NArrowheadPathOverlay.coordsName: setCoords(arrowheadPathOverlay, rawCoords: args!)
        case NArrowheadPathOverlay.widthName: setWidth(arrowheadPathOverlay, rawWidth: args!)
        case NArrowheadPathOverlay.colorName: setColor(arrowheadPathOverlay, rawColor: args!)
        case NArrowheadPathOverlay.outlineWidthName: setOutlineWidth(arrowheadPathOverlay, rawWidth: args!)
        case NArrowheadPathOverlay.outlineColorName: setOutlineColor(arrowheadPathOverlay, rawColor: args!)
        case NArrowheadPathOverlay.elevationName: setElevation(arrowheadPathOverlay, rawElevation: args!)
        case NArrowheadPathOverlay.headSizeRatioName: setHeadSizeRatio(arrowheadPathOverlay, rawRatio: args!)
        case getterName(NArrowheadPathOverlay.boundsName): getBounds(arrowheadPathOverlay, success: result)
        default: result(FlutterMethodNotImplemented)
        }
    }
}

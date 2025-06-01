import NMapsMap
import Flutter

internal protocol PolylineOverlayHandler: OverlayHandler {
    func setCoords(_ polylineOverlay: NMFPolylineOverlay, rawCoords: Any)

    func setColor(_ polylineOverlay: NMFPolylineOverlay, rawColor: Any)

    func setWidth(_ polylineOverlay: NMFPolylineOverlay, rawWidth: Any)

    func setLineCap(_ polylineOverlay: NMFPolylineOverlay, rawLineCap: Any)

    func setLineJoin(_ polylineOverlay: NMFPolylineOverlay, rawLineJoin: Any)

    func setPattern(_ polylineOverlay: NMFPolylineOverlay, patternList: Any)

    func getBounds(_ polylineOverlay: NMFPolylineOverlay, success: (_ bounds: Dictionary<String, Any>) -> Void)
}

internal extension  PolylineOverlayHandler {
    func handlePolylineOverlay(polylineOverlay: NMFOverlay,
                               method: String,
                               args: Any?,
                               result: @escaping FlutterResult) {
        let polylineOverlay = polylineOverlay as! NMFPolylineOverlay
        switch method {
        case NPolylineOverlay.coordsName: setCoords(polylineOverlay, rawCoords: args!)
        case NPolylineOverlay.colorName: setColor(polylineOverlay, rawColor: args!)
        case NPolylineOverlay.widthName: setWidth(polylineOverlay, rawWidth: args!)
        case NPolylineOverlay.lineCapName: setLineCap(polylineOverlay, rawLineCap: args!)
        case NPolylineOverlay.lineJoinName: setLineJoin(polylineOverlay, rawLineJoin: args!)
        case NPolylineOverlay.patternName: setPattern(polylineOverlay, patternList: args!)
        case getterName(NPolylineOverlay.boundsName): getBounds(polylineOverlay, success: result)
        default: result(FlutterMethodNotImplemented)
        }
    }
}

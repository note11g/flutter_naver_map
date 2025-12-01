import NMapsMap
import Flutter

internal protocol PolygonOverlayHandler: OverlayHandler {
    func setCoords(_ polygonOverlay: NMFPolygonOverlay, rawCoords: Any)

    func setColor(_ polygonOverlay: NMFPolygonOverlay, rawColor: Any)

    func setHoles(_ polygonOverlay: NMFPolygonOverlay, rawHoles: Any)

    func setOutlineColor(_ polygonOverlay: NMFPolygonOverlay, rawColor: Any)

    func setOutlineWidth(_ polygonOverlay: NMFPolygonOverlay, rawWidthDp: Any)
    
    func setOutlinePattern(_ polygonOverlay: NMFPolygonOverlay, patternList: Any)

    func getBounds(_ polygonOverlay: NMFPolygonOverlay, success: (_ bounds: Dictionary<String, Any>) -> Void)
}

internal extension  PolygonOverlayHandler {
    func handlePolygonOverlay(polygonOverlay: NMFOverlay,
                              method: String,
                              args: Any?,
                              result: @escaping FlutterResult) {
        let polygonOverlay = polygonOverlay as! NMFPolygonOverlay
        switch method {
        case NPolygonOverlay.coordsName: setCoords(polygonOverlay, rawCoords: args!)
        case NPolygonOverlay.colorName: setColor(polygonOverlay, rawColor: args!)
        case NPolygonOverlay.holesName: setHoles(polygonOverlay, rawHoles: args!)
        case NPolygonOverlay.outlineColorName: setOutlineColor(polygonOverlay, rawColor: args!)
        case NPolygonOverlay.outlineWidthName: setOutlineWidth(polygonOverlay, rawWidthDp: args!)
        case NPolygonOverlay.outlinePatternName:
            setOutlinePattern(polygonOverlay, patternList: args!)
        case getterName(NPolygonOverlay.boundsName): getBounds(polygonOverlay, success: result)
        default: result(FlutterMethodNotImplemented)
        }
    }
}

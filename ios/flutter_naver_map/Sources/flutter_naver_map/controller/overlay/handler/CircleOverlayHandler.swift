import NMapsMap
import Flutter

internal protocol CircleOverlayHandler: OverlayHandler {
    func setCenter(_ circleOverlay: NMFCircleOverlay, rawCenter: Any)

    func setRadius(_ circleOverlay: NMFCircleOverlay, rawRadius: Any)

    func setColor(_ circleOverlay: NMFCircleOverlay, rawColor: Any)

    func setOutlineColor(_ circleOverlay: NMFCircleOverlay, rawOutlineColor: Any)

    func setOutlineWidth(_ circleOverlay: NMFCircleOverlay, rawOutlineWidth: Any)

    func getBounds(_ circleOverlay: NMFCircleOverlay, result: (_ bounds: Dictionary<String, Any>) -> Void)
}

internal extension  CircleOverlayHandler {
    func handleCircleOverlay(circleOverlay: NMFOverlay,
                             method: String,
                             args: Any?,
                             result: @escaping FlutterResult) {
        let circleOverlay = circleOverlay as! NMFCircleOverlay
        switch method {
        case NCircleOverlay.centerName: setCenter(circleOverlay, rawCenter: args!)
        case NCircleOverlay.radiusName: setRadius(circleOverlay, rawRadius: args!)
        case NCircleOverlay.colorName: setColor(circleOverlay, rawColor: args!)
        case NCircleOverlay.outlineColorName: setOutlineColor(circleOverlay, rawOutlineColor: args!)
        case NCircleOverlay.outlineWidthName: setOutlineWidth(circleOverlay, rawOutlineWidth: args!)
        case getterName(NCircleOverlay.boundsName): getBounds(circleOverlay, result: result)
        default: result(FlutterMethodNotImplemented)
        }
    }
}
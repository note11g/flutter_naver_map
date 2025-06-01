import NMapsMap
import Flutter

internal protocol GroundOverlayHandler: OverlayHandler {
    func setBounds(_ groundOverlay: NMFGroundOverlay, rawBounds: Any)

    func setImage(_ groundOverlay: NMFGroundOverlay, rawNOverlayImage: Any)

    func setAlpha(_ groundOverlay: NMFGroundOverlay, rawAlpha: Any)
}

internal extension  GroundOverlayHandler {
    func handleGroundOverlay(groundOverlay: NMFOverlay,
                             method: String,
                             args: Any?,
                             result: @escaping FlutterResult) {
        let groundOverlay = groundOverlay as! NMFGroundOverlay
        switch method {
        case NGroundOverlay.boundsName: setBounds(groundOverlay, rawBounds: args!)
        case NGroundOverlay.imageName: setImage(groundOverlay, rawNOverlayImage: args!)
        case NGroundOverlay.alphaName: setAlpha(groundOverlay, rawAlpha: args!)
        default: result(FlutterMethodNotImplemented)
        }
    }
}

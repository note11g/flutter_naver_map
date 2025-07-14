import NMapsMap
import Flutter

internal protocol InfoWindowHandler: OverlayHandler {
        func setText(_ infoWindow: NMFInfoWindow, rawText: Any)

        func setAnchor(_ infoWindow: NMFInfoWindow, rawNPoint: Any)

        func setAlpha(_ infoWindow: NMFInfoWindow, rawAlpha: Any)

        func setPosition(_ infoWindow: NMFInfoWindow, rawPosition: Any)

        func setOffsetX(_ infoWindow: NMFInfoWindow, rawOffsetX: Any)

        func setOffsetY(_ infoWindow: NMFInfoWindow, rawOffsetY: Any)

        func close(_ infoWindow: NMFInfoWindow)
}

internal extension  InfoWindowHandler {
    func handleInfoWindow(infoWindow: NMFOverlay,
                             method: String,
                             args: Any?,
                             result: @escaping FlutterResult) {
        let infoWindow = infoWindow as! NMFInfoWindow
        switch method {
        case NInfoWindow.textName: setText(infoWindow, rawText: args!)
        case NInfoWindow.anchorName: setAnchor(infoWindow, rawNPoint: args!)
        case NInfoWindow.alphaName: setAlpha(infoWindow, rawAlpha: args!)
        case NInfoWindow.positionName: setPosition(infoWindow, rawPosition: args!)
        case NInfoWindow.offsetXName: setOffsetX(infoWindow, rawOffsetX: args!)
        case NInfoWindow.offsetYName: setOffsetY(infoWindow, rawOffsetY: args!)
        case NInfoWindow.closeName: close(infoWindow)
        default: result(FlutterMethodNotImplemented)
        }
    }
}

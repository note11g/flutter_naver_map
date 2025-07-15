import NMapsMap
import Flutter

internal protocol LocationOverlayHandler: OverlayHandler {
    func setAnchor(_ overlay: NMFLocationOverlay, rawNPoint: Any)

    func setBearing(_ overlay: NMFLocationOverlay, rawBearing: Any)

    func setCircleColor(_ overlay: NMFLocationOverlay, rawColor: Any)

    func setCircleOutlineColor(_ overlay: NMFLocationOverlay, rawColor: Any)

    func setCircleOutlineWidth(_ overlay: NMFLocationOverlay, rawWidth: Any)

    func setCircleRadius(_ overlay: NMFLocationOverlay, rawRadius: Any)

    func setIcon(_ overlay: NMFLocationOverlay, rawNOverlayImage: Any)

    func setIconSize(_ overlay: NMFLocationOverlay, rawSize: Any)
    
    func setIconAlpha(_ overlay: NMFLocationOverlay, rawAlpha: Any)

    func setPosition(_ overlay: NMFLocationOverlay, rawLatLng: Any)

    func setSubAnchor(_ overlay: NMFLocationOverlay, rawNPoint: Any)

    func setSubIcon(_ overlay: NMFLocationOverlay, rawNOverlayImage: Any?)

    func setSubIconSize(_ overlay: NMFLocationOverlay, rawSize: Any)
    
    func setSubIconAlpha(_ overlay: NMFLocationOverlay, rawAlpha: Any)

    func getBearing(_ overlay: NMFLocationOverlay, success: (_ bearing: Double) -> Void)

    func getPosition(_ overlay: NMFLocationOverlay, success: (_ latLng: Dictionary<String, Any>) -> Void)
}

private let anchorName = "anchor"
private let bearingName = "bearing"
private let circleColorName = "circleColor"
private let circleOutlineColorName = "circleOutlineColor"
private let circleOutlineWidthName = "circleOutlineWidth"
private let circleRadiusName = "circleRadius"
private let iconName = "icon"
private let iconSizeName = "iconSize"
private let iconAlphaName = "iconAlpha"
private let positionName = "position"
private let subAnchorName = "subAnchor"
private let subIconName = "subIcon"
private let subIconSizeName = "subIconSize"
private let subIconAlphaName = "subIconAlpha"

internal extension  LocationOverlayHandler {
    func handleLocationOverlay(locationOverlay: NMFOverlay,
                               method: String,
                               args: Any?,
                               result: @escaping FlutterResult) {
        let locationOverlay = locationOverlay as! NMFLocationOverlay
        switch method {
        case anchorName: setAnchor(locationOverlay, rawNPoint: args!)
        case bearingName: setBearing(locationOverlay, rawBearing: args!)
        case circleColorName: setCircleColor(locationOverlay, rawColor: args!)
        case circleOutlineColorName: setCircleOutlineColor(locationOverlay, rawColor: args!)
        case circleOutlineWidthName: setCircleOutlineWidth(locationOverlay, rawWidth: args!)
        case circleRadiusName: setCircleRadius(locationOverlay, rawRadius: args!)
        case iconName: setIcon(locationOverlay, rawNOverlayImage: args!)
        case iconSizeName: setIconSize(locationOverlay, rawSize: args!)
        case iconAlphaName: setIconAlpha(locationOverlay, rawAlpha: args!)
        case positionName: setPosition(locationOverlay, rawLatLng: args!)
        case subAnchorName: setSubAnchor(locationOverlay, rawNPoint: args!)
        case subIconName: setSubIcon(locationOverlay, rawNOverlayImage: args)
        case subIconSizeName: setSubIconSize(locationOverlay, rawSize: args!)
        case subIconAlphaName: setSubIconAlpha(locationOverlay, rawAlpha: args!)
        case getterName(bearingName): getBearing(locationOverlay, success: result)
        case getterName(positionName): getPosition(locationOverlay, success: result)
        default: result(FlutterMethodNotImplemented)
        }
    }
}

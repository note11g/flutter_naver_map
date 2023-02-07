import NMapsMap

internal protocol LocationOverlayHandler: OverlayHandler {
    func getAnchor(_ overlay: NMFLocationOverlay, success: (_ nPoint: Dictionary<String, Any>) -> Void)

    func setAnchor(_ overlay: NMFLocationOverlay, rawNPoint: Any)

    func getBearing(_ overlay: NMFLocationOverlay, success: (_ bearing: Double) -> Void)

    func setBearing(_ overlay: NMFLocationOverlay, rawBearing: Any)

    func getCircleColor(_ overlay: NMFLocationOverlay, success: (_ color: Int) -> Void)

    func setCircleColor(_ overlay: NMFLocationOverlay, rawColor: Any)

    func getCircleOutlineColor(_ overlay: NMFLocationOverlay, success: (_ color: Int) -> Void)

    func setCircleOutlineColor(_ overlay: NMFLocationOverlay, rawColor: Any)

    func getCircleOutlineWidth(_ overlay: NMFLocationOverlay, success: (_ width: Double) -> Void)

    func setCircleOutlineWidth(_ overlay: NMFLocationOverlay, rawWidth: Any)

    func getCircleRadius(_ overlay: NMFLocationOverlay, success: (_ width: Double) -> Void)

    func setCircleRadius(_ overlay: NMFLocationOverlay, rawRadius: Any)

    func setIcon(_ overlay: NMFLocationOverlay, rawNOverlayImage: Any)

    func getIconSize(_ overlay: NMFLocationOverlay, success: (_ size: Dictionary<String, Any>) -> Void)

    func setIconSize(_ overlay: NMFLocationOverlay, rawSize: Any)

    func getPosition(_ overlay: NMFLocationOverlay, success: (_ latLng: Dictionary<String, Any>) -> Void)

    func setPosition(_ overlay: NMFLocationOverlay, rawLatLng: Any)

    func getSubAnchor(_ overlay: NMFLocationOverlay, success: (_ nPoint: Dictionary<String, Any>) -> Void)

    func setSubAnchor(_ overlay: NMFLocationOverlay, rawNPoint: Any)

    func setSubIcon(_ overlay: NMFLocationOverlay, rawNOverlayImage: Any)

    func getSubIconSize(_ overlay: NMFLocationOverlay, success: (_ size: Dictionary<String, Any>) -> Void)

    func setSubIconSize(_ overlay: NMFLocationOverlay, rawSize: Any)
}

private let anchorName = "anchor"
private let bearingName = "bearing"
private let circleColorName = "circleColor"
private let circleOutlineColorName = "circleOutlineColor"
private let circleOutlineWidthName = "circleOutlineWidth"
private let circleRadiusName = "circleRadius"
private let iconName = "icon"
private let iconSizeName = "iconSize"
private let positionName = "position"
private let subAnchorName = "subAnchor"
private let subIconName = "subIcon"
private let subIconSizeName = "subIconSize"

internal extension  LocationOverlayHandler {
    func handleLocationOverlay(locationOverlay: NMFLocationOverlay,
                               method: String,
                               args: Any?,
                               result: @escaping FlutterResult) {
        switch method {
        case anchorName: setAnchor(locationOverlay, rawNPoint: args!)
        case bearingName: setBearing(locationOverlay, rawBearing: args!)
        case circleColorName: setCircleColor(locationOverlay, rawColor: args!)
        case circleOutlineColorName: setCircleOutlineColor(locationOverlay, rawColor: args!)
        case circleOutlineWidthName: setCircleOutlineWidth(locationOverlay, rawWidth: args!)
        case circleRadiusName: setCircleRadius(locationOverlay, rawRadius: args!)
        case iconName: setIcon(locationOverlay, rawNOverlayImage: args!)
        case iconSizeName: setIconSize(locationOverlay, rawSize: args!)
        case positionName: setPosition(locationOverlay, rawLatLng: args!)
        case subAnchorName: setSubAnchor(locationOverlay, rawNPoint: args!)
        case subIconName: setSubIcon(locationOverlay, rawNOverlayImage: args!)
        case subIconSizeName: setSubIconSize(locationOverlay, rawSize: args!)
        case getterName(anchorName): getAnchor(locationOverlay, success: result)
        case getterName(bearingName): getBearing(locationOverlay, success: result)
        case getterName(circleColorName): getCircleColor(locationOverlay, success: result)
        case getterName(circleOutlineColorName): getCircleOutlineColor(locationOverlay, success: result)
        case getterName(circleOutlineWidthName): getCircleOutlineWidth(locationOverlay, success: result)
        case getterName(circleRadiusName): getCircleRadius(locationOverlay, success: result)
        case getterName(iconSizeName): getIconSize(locationOverlay, success: result)
        case getterName(positionName): getPosition(locationOverlay, success: result)
        case getterName(subAnchorName): getSubAnchor(locationOverlay, success: result)
        case getterName(subIconSizeName): getSubIconSize(locationOverlay, success: result)
        default: result(FlutterMethodNotImplemented)
        }
    }
}
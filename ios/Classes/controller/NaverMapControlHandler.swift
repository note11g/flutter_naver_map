import NMapsMap

internal protocol NaverMapControlHandler {
    func updateCamera(cameraUpdate: NMFCameraUpdate, onSuccess: @escaping (_ isCanceled: Bool) -> Void)

    func cancelTransitions(reason: Int, onSuccess: @escaping (Any?) -> Void)

    func getCameraPosition(onSuccess: @escaping (_ cameraPosition: Dictionary<String, Any>) -> Void)

    func getContentBounds(withPadding: Bool, onSuccess: @escaping (_ latLngBounds: Dictionary<String, Any>) -> Void)

    func getContentRegion(withPadding: Bool, onSuccess: @escaping (_ latLngs: Array<Dictionary<String, Any>>) -> Void)

    func getLocationOverlay(onSuccess: @escaping (Any?) -> Void)

    func screenLocationToLatLng(nPoint: NPoint, onSuccess: @escaping (_ latLng: Dictionary<String, Any>) -> Void)

    func latLngToScreenLocation(latLng: NMGLatLng, onSuccess: @escaping (_ nPoint: Dictionary<String, Any>) -> Void)

    func getMeterPerDp(lat: Double?, zoom: Double?, onSuccess: @escaping (_ meterPerDp: Double) -> Void)
    
    func getMeterPerPixelAtLatitude(lat: Double, zoom: Double, onSuccess: @escaping (_ meterPerDp: Double) -> Void)

    func pickAll(
            nPoint: NPoint,
            dpRadius: Double,
            onSuccess: @escaping (_ pickables: Array<Dictionary<String, Any?>>) -> Void
    )

    func takeSnapshot(
            showControls: Bool,
            compressQuality: Int,
            onSuccess: @escaping (String) -> Void,
            onFailure: @escaping (_ e: FlutterError) -> Void
    )

    func setLocationTrackingMode(locationTrackingMode: NMFMyPositionMode, onSuccess: @escaping (Any?) -> Void)

    func getLocationTrackingMode(onSuccess: @escaping (String) -> Void)

    func addOverlayAll(rawOverlays: Array<Dictionary<String, Any>>, onSuccess: @escaping (Any?) -> Void)

    func deleteOverlay(overlayInfo: NOverlayInfo, onSuccess: @escaping (Any?) -> Void)

    func clearOverlays(type: NOverlayType?, onSuccess: @escaping (Any?) -> Void)

    func updateOptions(options: Dictionary<String, Any>, onSuccess: @escaping (Any?) -> Void)
}

internal extension  NaverMapControlHandler {
    func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "updateCamera": updateCamera(
                cameraUpdate: try! NCameraUpdate.fromMessageable(call.arguments!).cameraUpdate, onSuccess: result
        )
        case "cancelTransitions": cancelTransitions(reason: asInt(call.arguments!), onSuccess: result)
        case "getCameraPosition": getCameraPosition(onSuccess: result)
        case "getContentBounds": getContentBounds(withPadding: asBool(call.arguments!), onSuccess: result)
        case "getContentRegion": getContentRegion(withPadding: asBool(call.arguments!), onSuccess: result)
        case "getLocationOverlay": getLocationOverlay(onSuccess: result)
        case "screenLocationToLatLng": screenLocationToLatLng(nPoint: NPoint.fromMessageable(call.arguments!), onSuccess: result)
        case "latLngToScreenLocation": latLngToScreenLocation(latLng: asLatLng(call.arguments!), onSuccess: result)
        case "getMeterPerDp":
            let d = asDict(call.arguments!)
            getMeterPerDp(lat: d["latitude"] as? Double, zoom: d["zoom"] as? Double, onSuccess: result)
        case "getMeterPerPixelAtLatitude":
            let d = asDict(call.arguments!)
            getMeterPerPixelAtLatitude(lat: asDouble(d["latitude"]!), zoom: asDouble(d["zoom"]!), onSuccess: result)
        case "pickAll":
            let d = asDict(call.arguments!)
            pickAll(nPoint: NPoint.fromMessageable(d["point"]!), dpRadius: asDouble(d["radius"]!), onSuccess: result)
        case "takeSnapshot":
            let d = asDict(call.arguments!)
            takeSnapshot(showControls: asBool(d["showControls"]!),
                    compressQuality: asInt(d["compressQuality"]!),
                    onSuccess: result,
                    onFailure: result)
        case "setLocationTrackingMode": setLocationTrackingMode(locationTrackingMode: asLocationTrackingMode(call.arguments!), onSuccess: result)
        case "getLocationTrackingMode": getLocationTrackingMode(onSuccess: result)
        case "addOverlayAll": addOverlayAll(rawOverlays: asArr(call.arguments!, elementCaster: asDict), onSuccess: result)
        case "deleteOverlay": deleteOverlay(overlayInfo: NOverlayInfo.fromMessageable(call.arguments!), onSuccess: result)
        case "clearOverlays": clearOverlays(type: castOrNull(call.arguments, caster: { NOverlayType(rawValue: asString($0))! }), onSuccess: result)
        case "updateOptions": updateOptions(options: asDict(call.arguments!), onSuccess: result)
        default: result(FlutterMethodNotImplemented)
        }
    }
}

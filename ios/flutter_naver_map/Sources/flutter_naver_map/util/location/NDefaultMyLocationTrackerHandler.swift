import Foundation
import Flutter

internal protocol NDefaultMyLocationTrackerHandler {
    func requestLocationPermission(result: @escaping FlutterResult)

    func getCurrentPositionOnce(result: @escaping FlutterResult)
}

internal extension NDefaultMyLocationTrackerHandler {
    func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        case "requestLocationPermission":
            requestLocationPermission(result: result)
        case "getCurrentPositionOnce":
            getCurrentPositionOnce(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

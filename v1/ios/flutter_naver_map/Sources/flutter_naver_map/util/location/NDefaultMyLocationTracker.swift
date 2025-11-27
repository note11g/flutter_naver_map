import Foundation
import Flutter
import CoreLocation
import NMapsGeometry

internal class NDefaultMyLocationTracker: NSObject, NDefaultMyLocationTrackerHandler {
    private let methodChannel: FlutterMethodChannel
    
    private let locationEventChannel: FlutterEventChannel
    private let headingEventChannel: FlutterEventChannel
    
    private let locationHelper: CLLocationHelper = CLLocationHelperImpl()
    
    private let locationStreamHandler: NDefaultMyLocationTrackerLocationStreamHandler
    private let headingStreamHandler: NDefaultMyLocationTrackerHeadingStreamHandler
    
    init(messenger: FlutterBinaryMessenger) {
        self.methodChannel = FlutterMethodChannel(name: "NDefaultMyLocationTracker", binaryMessenger: messenger)
        self.locationEventChannel = FlutterEventChannel(name: "NDefaultMyLocationTracker.locationStream", binaryMessenger: messenger)
        self.headingEventChannel = FlutterEventChannel(name: "NDefaultMyLocationTracker.headingStream", binaryMessenger: messenger)
        
        self.locationStreamHandler = NDefaultMyLocationTrackerLocationStreamHandler()
        self.headingStreamHandler = NDefaultMyLocationTrackerHeadingStreamHandler()
        super.init()
        
        methodChannel.setMethodCallHandler(handle)
        locationEventChannel.setStreamHandler(locationStreamHandler)
        headingEventChannel.setStreamHandler(headingStreamHandler)
    }
    
    deinit {
        methodChannel.setMethodCallHandler(nil)
        locationEventChannel.setStreamHandler(nil)
        headingEventChannel.setStreamHandler(nil)
    }

    func requestLocationPermission(result: @escaping FlutterResult) {
        locationHelper.requestPermission(onResult: DeferedRequestCallbacks(onDone: { status in
            result(status.toMessageable() ?? FlutterError(code: "notDetermined", message: "unexpected notDetermined was returned", details: nil))
        }))
    }
    
    func getCurrentPositionOnce(result: @escaping FlutterResult) {
        locationHelper.getLocationOnce(onResult: DeferedRequestCallbacks(onDone: { location in
            let latLng = NMGLatLng(from: location.coordinate)
            result(latLng.toMessageable())
        }, onError: { error in
            result(FlutterError(code: "LOCATION_ERROR", message: error.localizedDescription, details: nil))
        }))
    }
}


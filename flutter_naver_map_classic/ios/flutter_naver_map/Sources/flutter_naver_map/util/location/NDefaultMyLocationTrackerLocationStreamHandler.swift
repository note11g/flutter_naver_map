import Flutter
import Foundation
import CoreLocation
import NMapsGeometry

class NDefaultMyLocationTrackerLocationStreamHandler: NSObject, FlutterStreamHandler, CLLocationManagerDelegate {
    private var eventSink: FlutterEventSink?
    private lazy var location: CLLocationManager = CLLocationManager()
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events

        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        location.startUpdatingLocation()

        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        location.stopUpdatingLocation()
        location.delegate = nil
        
        return nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last {
            let latLng = NMGLatLng(lat: loc.coordinate.latitude.toDouble(), lng: loc.coordinate.longitude.toDouble())
            eventSink?(latLng.toMessageable())
        }
    }
}

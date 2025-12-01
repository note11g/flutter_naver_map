import Flutter
import Foundation
import CoreLocation

class NDefaultMyLocationTrackerHeadingStreamHandler: NSObject, FlutterStreamHandler, CLLocationManagerDelegate {
    private var eventSink: FlutterEventSink?
    private lazy var location: CLLocationManager = CLLocationManager()
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events;

        location.delegate = self;
        location.headingFilter = 0.1;
        location.startUpdatingHeading();

        return nil;
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        
        location.stopUpdatingHeading();
        location.delegate = nil;
        
        return nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let accuracy = newHeading.headingAccuracy
        guard accuracy > 0 else { return }
        eventSink?(newHeading.trueHeading)
    }
}


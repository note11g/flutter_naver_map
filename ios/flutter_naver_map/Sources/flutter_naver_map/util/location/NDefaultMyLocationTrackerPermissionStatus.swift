import CoreLocation

enum NDefaultMyLocationTrackerPermissionStatus: String {
    case granted = "granted"
    case denied = "denied"
    case deniedForever = "deniedForever"
    
    func toMessageable() -> String {
        return self.rawValue
    }
}

extension CLAuthorizationStatus {
    func toNDefaultMyLocationTrackerPermissionStatus() -> NDefaultMyLocationTrackerPermissionStatus? {
        switch self {
        case .authorizedAlways, .authorizedWhenInUse:
            return .granted
        case .denied:
            return .denied
        case .restricted:
            return .deniedForever
        case .notDetermined:
            return nil
        }
    }
    
    func toMessageable() -> String? {
        self.toNDefaultMyLocationTrackerPermissionStatus()?.toMessageable()
    }
}

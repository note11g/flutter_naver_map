//
//  CLLocationHelper.swift
//  flutter_naver_map
//
//  Created by 김소연 on 6/9/25.
//
import Foundation
import CoreLocation

protocol CLLocationHelper {
    func requestPermission(onResult: DeferedRequestCallbacks<CLAuthorizationStatus>)
    func getLocationOnce(onResult: DeferedRequestCallbacks<CLLocation>)
}

class CLLocationHelperImpl: NSObject, CLLocationManagerDelegate, CLLocationHelper {
    private let manager: CLLocationManager = CLLocationManager()
    let accuracy = kCLLocationAccuracyBestForNavigation
    private var permissionRequestQueue: [DeferedRequestCallbacks<CLAuthorizationStatus>] = []
    private var locationRequestQueue: [DeferedRequestCallbacks<CLLocation>] = []
    
    override init() {
        super.init()
        manager.desiredAccuracy = accuracy
        manager.delegate = self
    }
    
    deinit {
        manager.stopUpdatingLocation()
        manager.delegate = nil
    }
    
    func requestPermission(onResult: DeferedRequestCallbacks<CLAuthorizationStatus>) {
        let status = CLLocationManager.authorizationStatus()
        if (status == .notDetermined) {
            if (permissionRequestQueue.isEmpty) {
                manager.requestWhenInUseAuthorization()
            }
            permissionRequestQueue.append(onResult)
        } else {
            onResult.onDone(status)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        for permissionRequest in permissionRequestQueue {
            permissionRequest.onDone(status)
        }
        permissionRequestQueue.removeAll()
    }
    
    func getLocationOnce(onResult: DeferedRequestCallbacks<CLLocation>) {
        if (locationRequestQueue.isEmpty) {
            manager.startUpdatingLocation()
        }
        locationRequestQueue.append(onResult)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.last else { return }
        for locationRequest in locationRequestQueue {
            locationRequest.onDone(firstLocation)
        }
        locationRequestQueue.removeAll()
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        for callback in locationRequestQueue {
            callback.onError?(error)
        }
        locationRequestQueue.removeAll()
        manager.stopUpdatingLocation()
    }
}

struct DeferedRequestCallbacks<T> {
    let onDone: (T) -> Void
    let onError: ((Error) -> Void)?
    
    init(onDone: @escaping (T) -> Void, onError: ((Error) -> Void)?) {
        self.onDone = onDone
        self.onError = onError
    }
    
    init(onDone: @escaping (T) -> Void) {
        self.onDone = onDone
        self.onError = nil
    }
}

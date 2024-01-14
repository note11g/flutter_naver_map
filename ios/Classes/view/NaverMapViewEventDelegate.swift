import NMapsMap

internal class NaverMapViewEventDelegate: NSObject, NMFMapViewTouchDelegate, NMFMapViewCameraDelegate, NMFIndoorSelectionDelegate, NMFOfflineStorageDelegate {
    private weak var sender: NaverMapControlSender?

    private let initializeConsumeSymbolTapEvents: Bool
    private var animated: Bool = true
    private let offlineStorageHelper: NMFOfflineStorage = NMFOfflineStorage()
    private var isLoaded: Bool = false

    init(sender: NaverMapControlSender, initializeConsumeSymbolTapEvents: Bool) {
        self.sender = sender
        self.initializeConsumeSymbolTapEvents = initializeConsumeSymbolTapEvents
    }

    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        sender?.onMapTapped(nPoint: NPoint.fromCGPointWithDisplay(point), latLng: latlng)
    }

    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
        sender?.onSymbolTapped(symbol: symbol) ?? initializeConsumeSymbolTapEvents
    }

    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        self.animated = animated
        sender?.onCameraChange(cameraUpdateReason: reason, animated: animated)
    }

    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        sender?.onCameraChange(cameraUpdateReason: reason, animated: animated)
    }

    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        self.animated = animated
        sender?.onCameraChange(cameraUpdateReason: reason, animated: animated)
    }

    func mapViewCameraIdle(_ mapView: NMFMapView) {
        sender?.onCameraIdle()
    }

    func indoorSelectionDidChanged(_ indoorSelection: NMFIndoorSelection?) {
        sender?.onSelectedIndoorChanged(selectedIndoor: indoorSelection)
    }

    func registerDelegates(mapView: NMFMapView) {
        mapView.touchDelegate = self
        mapView.addCameraDelegate(delegate: self)
        mapView.addIndoorSelectionDelegate(delegate: self)
        
        offlineStorageHelper.delegate = self
    }

    func unregisterDelegates(mapView: NMFMapView) {
        mapView.touchDelegate = nil
        mapView.removeCameraDelegate(delegate: self)
        mapView.removeIndoorSelectionDelegate(delegate: self)
        offlineStorageHelper.delegate = nil
    }
    
    func checkNowShownMapIsCached() {
        let nowCacheCount = NMFOfflineStorage.shared.countOfBytesCompleted
        
        print("cacheCheck(dif:\(nowCacheCount != lastCacheCount):: last:\(lastCacheCount), now:\(nowCacheCount)")
        do {
            if nowCacheCount == lastCacheCount { // cached. register timing is too ealry. not sended platform messages.
                onMapLoaded(desc: "maybe")
            }
        }
        lastCacheCount = nowCacheCount
    }
    
    func offlineStorage(_ storage: NMFOfflineStorage, urlForResourceOf kind: NMFResourceKind, with url: URL) -> URL {
        onMapLoaded(desc: "sure")
        print("offlineStorageSaved: \(url.absoluteString)")
        lastCacheCount = NMFOfflineStorage.shared.countOfBytesCompleted
        
        if kind == .tile {
            offlineStorageHelper.delegate = nil
            return url
        } else {
            return URL(string: "https://map.pstatic.net/nrs/api/")! // URL Cache Failed.
        }
    }
    
    private func onMapLoaded(desc: String) {
        if isLoaded { return }
        do {
            isLoaded = true
            sender?.onMapLoaded()
            print("[swift, \(desc)] onMapLoaded! : \(Date().timeIntervalSince1970)")
        }
    }
}
var lastCacheCount: UInt64 = 0

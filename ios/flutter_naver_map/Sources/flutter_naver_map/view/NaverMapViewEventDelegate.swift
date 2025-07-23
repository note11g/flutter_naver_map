import NMapsMap

internal class NaverMapViewEventDelegate: NSObject, NMFMapViewTouchDelegate, NMFMapViewCameraDelegate, NMFIndoorSelectionDelegate, NMFMapViewLoadDelegate {
    private weak var sender: NaverMapControlSender?

    private let initializeConsumeSymbolTapEvents: Bool
    private var animated: Bool = true

    init(sender: NaverMapControlSender, initializeConsumeSymbolTapEvents: Bool) {
        self.sender = sender
        self.initializeConsumeSymbolTapEvents = initializeConsumeSymbolTapEvents
    }

    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        sender?.onMapTapped(nPoint: NPoint.fromCGPointWithDisplay(point), latLng: latlng)
    }
    
    func mapView(_ mapView: NMFMapView, didLongTapMap latlng: NMGLatLng, point: CGPoint) {
        sender?.onMapLongTapped(nPoint: NPoint.fromCGPointWithDisplay(point), latLng: latlng)
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
    
    func mapViewDidFinishLoadingMap(_ mapView: NMFMapView) {
        sender?.onMapLoaded()
    }

    func registerDelegates(mapView: NMFMapView) {
        mapView.touchDelegate = self
        mapView.addCameraDelegate(delegate: self)
        mapView.addIndoorSelectionDelegate(delegate: self)
        mapView.addLoadDelegate(delegate: self)

        mapView.setCustomStyleId(
            mapView.customStyleId,
            loadHandler: sender?.onCustomStyleLoaded,
            failHandler: sender?.onCustomStyleLoadFailed
        )
    }

    func unregisterDelegates(mapView: NMFMapView) {
        mapView.touchDelegate = nil
        mapView.removeCameraDelegate(delegate: self)
        mapView.removeIndoorSelectionDelegate(delegate: self)
        mapView.removeLoadDelegate(delegate: self)
    }
}

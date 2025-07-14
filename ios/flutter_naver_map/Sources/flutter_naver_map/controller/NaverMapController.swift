import NMapsMap
import Flutter

internal class NaverMapController: NaverMapControlSender, NaverMapControlHandler {
    private let naverMap: NMFNaverMapView!
    private let channel: FlutterMethodChannel
    private let overlayController: OverlayHandler
    private var naverMapViewOptions: NaverMapViewOptions?
    private var clusteringController: ClusteringController!
    
    private var mapView: NMFMapView {
        naverMap.mapView
    }
    
    init(naverMap: NMFNaverMapView!, channel: FlutterMethodChannel, overlayController: OverlayHandler) {
        self.naverMap = naverMap
        self.channel = channel
        self.overlayController = overlayController
        overlayController.initializeLocationOverlay(overlay: naverMap.mapView.locationOverlay)
        self.clusteringController = ClusteringController(naverMapView: naverMap.mapView, overlayController: self.overlayController, messageSender: self.channel.invokeMethod)
        
        channel.setMethodCallHandler(handle)
    }
    
    func updateCamera(cameraUpdate: NMFCameraUpdate, onSuccess: @escaping (Bool) -> ()) {
        mapView.moveCamera(cameraUpdate, completion: onSuccess)
    }
    
    func cancelTransitions(reason: Int, onSuccess: @escaping (Any?) -> ()) {
        mapView.cancelTransitions()
        onSuccess(nil)
    }
    
    func getCameraPosition(onSuccess: @escaping (Dictionary<String, Any>) -> ()) {
        onSuccess(mapView.cameraPosition.toMessageable())
    }
    
    func getContentBounds(withPadding: Bool, onSuccess: @escaping (Dictionary<String, Any>) -> ()) {
        let bounds = withPadding ? mapView.coveringBounds : mapView.contentBounds
        onSuccess(bounds.toMessageable())
    }
    
    func getContentRegion(withPadding: Bool, onSuccess: @escaping (Array<Dictionary<String, Any>>) -> ()) {
        let region = (withPadding ? mapView.coveringRegion : mapView.contentRegion).exteriorRing
        onSuccess(region.latLngPoints.map {
            $0.toMessageable()
        })
    }
    
    func getLocationOverlay(onSuccess: @escaping (Any?) -> ()) {
        let overlay = mapView.locationOverlay
        onSuccess(overlay.toMessageable())
    }
    
    func screenLocationToLatLng(nPoint: NPoint, onSuccess: @escaping (Dictionary<String, Any>) -> ()) {
        let latLng = mapView.projection.latlng(from: nPoint.cgPoint)
        onSuccess(latLng.toMessageable())
    }
    
    func latLngToScreenLocation(latLng: NMGLatLng, onSuccess: @escaping (Dictionary<String, Any>) -> ()) {
        let point = mapView.projection.point(from: latLng)
        onSuccess(NPoint.fromCGPointWithDisplay(point).toMessageable())
    }
    
    func getMeterPerDp(onSuccess: @escaping (Double) -> ()) {
        onSuccess(mapView.projection.metersPerPixel())
    }
    
    func getMeterPerDp(lat: Double, zoom: Double, onSuccess: @escaping (Double) -> Void) {
        onSuccess(mapView.projection.metersPerPixel(atLatitude: lat, zoom: zoom))
    }
    
    func pickAll(nPoint: NPoint, dpRadius: Double, onSuccess: @escaping (Array<Dictionary<String, Any?>>) -> ()) {
        let pickables = mapView.pickAll(nPoint.cgPoint, withTolerance: asRoundInt(rawFloat: dpRadius))
        
        let messageableResult: Array<Dictionary<String, Any?>> = pickables.filter({ !($0 is NMFLocationOverlay) }).map {
            let info = NOverlayInfo.fromPickable(pickable: $0)
            return info.toSignedMessageable()
        }
        
        onSuccess(messageableResult)
    }
    
    func takeSnapshot(showControls: Bool,
                      compressQuality: Int,
                      onSuccess: @escaping (String) -> (),
                      onFailure: @escaping (FlutterError) -> ()) {
        DispatchQueue.main.async { [weak self] in
            self!.naverMap.takeSnapshot(withShowControls: showControls) { [weak self] uiImage in
                do {
                    let path = try self?.saveSnapshot(uiImage, compressQuality: compressQuality)
                    if let path = path {
                        onSuccess(path)
                    }
                } catch {
                    onFailure(FlutterError(code: "error", message: "Failed to save snapshot", details: nil))
                }
            }
        }
    }
    
    
    private func saveSnapshot(_ snapshot: UIImage, compressQuality: Int) throws -> String {
        let directory = NSTemporaryDirectory()
        let fileName = "map_capture_\(UUID().uuidString).jpg"
        let tempUrl = NSURL.fileURL(withPathComponents: [directory, fileName])
        let jpgImg = snapshot.jpegData(compressionQuality: CGFloat(compressQuality / 100))
        try jpgImg!.write(to: tempUrl!)
        return tempUrl!.path
    }
    
    func setLocationTrackingMode(locationTrackingMode: NMFMyPositionMode, onSuccess: @escaping (Any?) -> ()) {
        mapView.positionMode = locationTrackingMode
        onSuccess(nil)
    }
    
    func getLocationTrackingMode(onSuccess: @escaping (String) -> ()) {
        onSuccess(mapView.positionMode.toMessageableString())
    }
    
    func addOverlayAll(rawOverlays: Array<Dictionary<String, Any>>, onSuccess: @escaping (Any?) -> ()) {
        var clusterableMarkers: [NClusterableMarker] = []
        
        for rawOverlay in rawOverlays {
            let info = NOverlayInfo.fromMessageable(rawOverlay["info"]!)
            let nOverlay = try! asLazyOverlayOrAddableOverlayFromMessageable(info: info, args: rawOverlay)
            
            switch nOverlay {
            case let addableOverlay as any AddableOverlay:
                saveAddableOverlayAtOverlayController(addableOverlay: addableOverlay)
            case let clusterableMarker as NClusterableMarker:
                clusterableMarkers.append(clusterableMarker)
            default:
                onSuccess(NSError(domain: "NaverMapController", code: 0, userInfo: [
                    NSLocalizedDescriptionKey: "Invalid Overlay Type: \(nOverlay)"
                ]))
                return;
            }
        }
        
        if !clusterableMarkers.isEmpty {
            print(clusterableMarkers)
            clusteringController.addClusterableMarkerAll(clusterableMarkers)
        }
        
        onSuccess(nil)
    }
    
    func saveAddableOverlayAtOverlayController(addableOverlay: some AddableOverlay) {
        let overlay = overlayController.saveOverlayWithAddable(creator: addableOverlay)
        overlay.mapView = mapView
    }
    
    func deleteOverlay(overlayInfo: NOverlayInfo, onSuccess: @escaping (Any?) -> ()) {
        switch overlayInfo.type {
        case .clusterableMarker: clusteringController.deleteClusterableMarker(overlayInfo)
        default: overlayController.deleteOverlay(info: overlayInfo)
        }
        onSuccess(nil)
    }
    
    func clearOverlays(type: NOverlayType?, onSuccess: @escaping (Any?) -> ()) {
        if let type = type {
            switch type {
            case .clusterableMarker: clusteringController.clearClusterableMarker()  // check needed todo
            default: overlayController.clearOverlays(type: type)
            }
        } else {
            clusteringController.clearClusterableMarker( ) // check needed todo
            overlayController.clearOverlays()
        }
        onSuccess(nil)
    }
    
    func forceRefresh(onSuccess: @escaping (Any?) -> Void) {
        mapView.forceRefresh()
        onSuccess(nil)
    }
    
    func updateOptions(options: Dictionary<String, Any?>, onSuccess: @escaping (Any?) -> ()) {
        naverMapViewOptions = NaverMapViewOptions.fromMessageable(options)
        naverMapViewOptions!.updateWithNaverMapView(naverMap: naverMap, isFirst: false, customStyleCallbacks: getCustomStyleCallback())
        onSuccess(nil)
    }
    
    func updateClusteringOptions(rawOptions: Dictionary<String, Any>, onSuccess: @escaping (Any?) -> Void) {
        do {
            let options = NaverMapClusterOptions.fromMessageable(rawOptions)
            clusteringController.updateClusterOptions(options)
            onSuccess(nil)
        }
    }
    
    func openMapOpenSourceLicense(onSuccess: @escaping (Any?) -> Void) {
        mapView.showOpenSourceLicense()
        onSuccess(nil)
    }
    
    func openLegend(onSuccess: @escaping (Any?) -> Void) {
//        mapView.showLegend() // > ??
         // todo.
        onSuccess(nil)
    }
    
    func openLegalNotice(onSuccess: @escaping (Any?) -> Void) {
        mapView.showLegalNotice()
        onSuccess(nil)
    }
    
    /*
     --- sender (to dart) ---
     */
    func onMapReady() {
        channel.invokeMethod("onMapReady", arguments: nil)
    }
    
    func onMapLoaded() {
        channel.invokeMethod("onMapLoaded", arguments: nil)
    }
    
    func onMapTapped(nPoint: NPoint, latLng: NMGLatLng) {
        channel.invokeMethod("onMapTapped", arguments: [
            "nPoint": nPoint.toMessageable(),
            "latLng": latLng.toMessageable()
        ])
    }
    
    func onMapLongTapped(nPoint: NPoint, latLng: NMGLatLng) {
        channel.invokeMethod("onMapLongTapped", arguments: [
            "nPoint": nPoint.toMessageable(),
            "latLng": latLng.toMessageable()
        ])
    }
    
    func onSymbolTapped(symbol: NMFSymbol) -> Bool? {
        let symbolInfo = NSymbolInfo(symbol: symbol)
        channel.invokeMethod("onSymbolTapped", arguments: symbolInfo.toMessageable())
        return naverMapViewOptions?.consumeSymbolTapEvents
    }
    
    func onCameraChange(cameraUpdateReason: Int, animated: Bool) {
        let cameraPosition = mapView.cameraPosition
        channel.invokeMethod("onCameraChange", arguments: [
            "reason": cameraUpdateReason,
            "animated": animated,
            "position": cameraPosition.toMessageable()
        ])
    }
    
    func onCameraIdle() {
        channel.invokeMethod("onCameraIdle", arguments: nil)
    }
    
    func onSelectedIndoorChanged(selectedIndoor: NMFIndoorSelection?) {
        channel.invokeMethod("onSelectedIndoorChanged", arguments: selectedIndoor?.toMessageable())
    }

    func onCustomStyleLoaded() {
        channel.invokeMethod("onCustomStyleLoaded", arguments: nil)
    }

    func onCustomStyleLoadFailed(exception: any Error) {
        let isInvalidCustomStyleIdError = exception._code == 900 && exception.localizedDescription.contains("(400)")
        let flutterError = isInvalidCustomStyleIdError
        ? NFlutterException(code: "400", message: exception.localizedDescription)
        : NFlutterException(error: exception)
        channel.invokeMethod("onCustomStyleLoadFailed", arguments: flutterError.toMessageable())
    }
    
    /*
     --- deinit ---
     */
    
    func dispose() {
        channel.setMethodCallHandler(nil)
        clusteringController.dispose()
        overlayController.removeChannel()
    }
}

import NMapsMap
import Foundation

internal class NaverMapController: NaverMapControlSender, NaverMapControlHandler {
    private let naverMap: NMFNaverMapView!
    private let channel: FlutterMethodChannel
    private let overlayController: OverlayHandler
    private var naverMapViewOptions: NaverMapViewOptions?

    private var mapView: NMFMapView {
        naverMap.mapView
    }

    init(naverMap: NMFNaverMapView!, channel: FlutterMethodChannel, overlayController: OverlayHandler) {
        self.naverMap = naverMap
        self.channel = channel
        self.overlayController = overlayController
        overlayController.initializeLocationOverlay(overlay: naverMap.mapView.locationOverlay)

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
        let startTime = Date()
        for rawOverlay in rawOverlays {
            let info = NOverlayInfo.fromMessageable(rawOverlay["info"]!)
            print("\(Date().timeIntervalSince(startTime))")
            let creator = try! asAddableOverlayFromMessageable(info: info, json: rawOverlay)
            print("\(Date().timeIntervalSince(startTime))")
            let overlay = overlayController.saveOverlayWithAddable(creator: creator)
            print("\(Date().timeIntervalSince(startTime))")
            overlay.mapView = mapView
        }

        onSuccess(nil)
    }

    func deleteOverlay(overlayInfo: NOverlayInfo, onSuccess: @escaping (Any?) -> ()) {
        overlayController.deleteOverlay(info: overlayInfo)
        onSuccess(nil)
    }

    func clearOverlays(type: NOverlayType?, onSuccess: @escaping (Any?) -> ()) {
        if let type = type {
            overlayController.clearOverlays(type: type)
        } else {
            overlayController.clearOverlays()
        }
        onSuccess(nil)
    }
    
    func forceRefresh(onSuccess: @escaping (Any?) -> Void) {
        mapView.forceRefresh()
        onSuccess(nil)
    }

    func updateOptions(options: Dictionary<String, Any>, onSuccess: @escaping (Any?) -> ()) {
        naverMapViewOptions = NaverMapViewOptions.fromMessageable(options)
        naverMapViewOptions!.updateWithNaverMapView(naverMap: naverMap, isFirst: false)
        onSuccess(nil)
    }

    /*
      --- sender (to dart) ---
    */
    func onMapReady() {
        channel.invokeMethod("onMapReady", arguments: nil)
    }

    func onMapTapped(nPoint: NPoint, latLng: NMGLatLng) {
        channel.invokeMethod("onMapTapped", arguments: [
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

    /*
      --- deinit ---
    */

    func removeChannel() {
        channel.setMethodCallHandler(nil)
        overlayController.removeChannel()
    }
}

import NMapsMap
import Flutter

internal class NaverMapView: NSObject, FlutterPlatformView {
    private let naverMap: NMFNaverMapView!
    private let naverMapViewOptions: NaverMapViewOptions
    private let naverMapControlSender: NaverMapControlSender
    private var eventDelegate: NaverMapViewEventDelegate!

    init(frame: CGRect, options: NaverMapViewOptions, channel: FlutterMethodChannel, overlayController: OverlayController) {
        naverMap = NMFNaverMapView(frame: frame)
        naverMapViewOptions = options
        naverMapControlSender = NaverMapController(naverMap: naverMap, channel: channel, overlayController: overlayController)
        super.init()

        naverMapViewOptions.updateWithNaverMapView(naverMap: naverMap, isFirst: true)
        onMapReady()
    }

    private func onMapReady() {
        setMapTapListener()
        naverMapControlSender.onMapReady()
        deactivateLogo()
    }

    private func deactivateLogo() {
        let subviews = naverMap.mapView.subviews
        if (subviews.count < 2) { return }
        let logoIncludedView = subviews[1]
        logoIncludedView.isHidden = true
    }

    private func setMapTapListener() {
        eventDelegate = NaverMapViewEventDelegate(sender: naverMapControlSender,
                initializeConsumeSymbolTapEvents: naverMapViewOptions.consumeSymbolTapEvents)
        eventDelegate.registerDelegates(mapView: naverMap.mapView)
    }

    func view() -> UIView {
        naverMap
    }

    deinit {
        naverMapControlSender.dispose()
    }
}

import NMapsMap

class NaverMapView: NSObject, FlutterPlatformView {
    private let naverMap: NMFNaverMapView!
    private let naverMapViewOptions: NaverMapViewOptions
    private let channel: FlutterMethodChannel
//    private let overlayController: OverlayController

    init(frame: CGRect, options: NaverMapViewOptions, channel: FlutterMethodChannel) {
        naverMap = NMFNaverMapView(frame: frame)
        naverMapViewOptions = options
        self.channel = channel
        super.init()

        naverMapViewOptions.updateWithNaverMapView(naverMap: naverMap)
    }

    func view() -> UIView {
        naverMap
    }
}

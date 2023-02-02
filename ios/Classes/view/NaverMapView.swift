import NMapsMap

class NaverMapView: NSObject, FlutterPlatformView {
    private var naverMap: NMFNaverMapView!

    init(frame: CGRect,
         viewIdentifier viewId: Int64,
         arguments args: Any?,
         binaryMessenger messenger: FlutterBinaryMessenger?) {
        naverMap = NMFNaverMapView(frame: frame)
        super.init()
    }

    func view() -> UIView {
        naverMap
    }
}

class NaverMapFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
            withFrame frame: CGRect,
            viewIdentifier viewId: Int64,
            arguments args: Any?
    ) -> FlutterPlatformView {
        let channel = FlutterMethodChannel(name: SwiftFlutterNaverMapPlugin.createViewMethodChannelName(id: viewId), binaryMessenger: messenger)
        let overlayChannel = FlutterMethodChannel(name: SwiftFlutterNaverMapPlugin.createOverlayMethodChannelName(id: viewId), binaryMessenger: messenger)
//        let overlayController = OverlayController(overlayChannel)

        let convertedArgs = asDict(args!) // todo
        let options = NaverMapViewOptions.fromMap(convertedArgs)

        return NaverMapView(frame: frame, options: options, channel: channel)
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }
}

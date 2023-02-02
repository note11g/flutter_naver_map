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
        let overlayChannel = FlutterMethodChannel(name: SwiftFlutterNaverMapPlugin.createOverlayMethodChannelName(viewId: viewId), binaryMessenger: messenger)
//        let overlayController = OverlayController(overlayChannel)
        
//        let convertedArgs = asDict(args!)
        
        return NaverMapView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
}

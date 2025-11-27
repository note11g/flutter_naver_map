import Foundation
import Flutter

internal class NaverMapFactory: NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
        setHttpConnectionMaximum()
    }

    func create(
            withFrame frame: CGRect,
            viewIdentifier viewId: Int64,
            arguments args: Any?
    ) -> FlutterPlatformView {
        let channel = FlutterMethodChannel(name: SwiftFlutterNaverMapPlugin.createViewMethodChannelName(id: viewId), binaryMessenger: messenger)
        let overlayChannel = FlutterMethodChannel(name: SwiftFlutterNaverMapPlugin.createOverlayMethodChannelName(id: viewId), binaryMessenger: messenger)
        let overlayController = OverlayController(channel: overlayChannel)

        let convertedArgs = asNullableDict(args!)
        let options = NaverMapViewOptions.fromMessageable(convertedArgs)

        return NaverMapView(frame: frame, options: options, channel: channel, overlayController: overlayController)
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }

    private func setHttpConnectionMaximum() {
        URLSession.shared.configuration.httpMaximumConnectionsPerHost = 8
    }
}

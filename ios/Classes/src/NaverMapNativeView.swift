import Flutter
import UIKit
import NMapsMap

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
        return NaverMapNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
}

class NaverMapNativeView: NSObject, FlutterPlatformView {
    private var naverMap : NMFNaverMapView!
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        naverMap = NMFNaverMapView(frame: frame)
        super.init()
    }
    
    func view() -> UIView {
        return naverMap
    }
}

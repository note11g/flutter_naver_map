import Flutter
import UIKit

public class SwiftNaverMapPlugin: NSObject, FlutterPlugin {
    var registrar: FlutterPluginRegistrar?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let naverMapFactory = NaverMapFactory(registrar: registrar)
        registrar.register(naverMapFactory,
                           withId: "naver_map_plugin",
                           gestureRecognizersBlockingPolicy: FlutterPlatformViewGestureRecognizersBlockingPolicyWaitUntilTouchesEnded)
    }
    
}


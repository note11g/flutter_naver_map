import Flutter
import UIKit

public class SwiftFlutterNaverMapPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
//     let channel = FlutterMethodChannel(name: "flutter_naver_map", binaryMessenger: registrar.messenger())
//     let instance = SwiftFlutterNaverMapPlugin()
//     registrar.addMethodCallDelegate(instance, channel: channel)

      let naverMapFactory = NaverMapFactory(messenger: registrar.messenger())
    registrar.register(naverMapFactory,
                               withId: "flutter_naver_map_view",
                               gestureRecognizersBlockingPolicy: FlutterPlatformViewGestureRecognizersBlockingPolicyWaitUntilTouchesEnded)


    }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
  }
}

import Flutter
import UIKit

public class SwiftFlutterNaverMapPlugin: NSObject, FlutterPlugin {
    private static var registrar: FlutterPluginRegistrar!

    public static func register(with registrar: FlutterPluginRegistrar) {
        self.registrar = registrar

        initializeSdkChannel(binaryMessenger: registrar.messenger())

        let naverMapFactory = NaverMapFactory(messenger: registrar.messenger())
        registrar.register(naverMapFactory,
                withId: MAP_VIEW_TYPE_ID,
                gestureRecognizersBlockingPolicy: FlutterPlatformViewGestureRecognizersBlockingPolicyWaitUntilTouchesEnded)
    }

    private static func initializeSdkChannel(binaryMessenger: FlutterBinaryMessenger) {
        let sdkChannel = FlutterMethodChannel(name: SwiftFlutterNaverMapPlugin.SDK_CHANNEL_NAME, binaryMessenger: binaryMessenger)
        _ = SdkInitializer(channel: sdkChannel)
    }

    private static let SDK_CHANNEL_NAME = "flutter_naver_map_sdk"
    private static let OVERLAY_CHANNEL_NAME = "flutter_naver_map_overlay"
    private static let MAP_VIEW_TYPE_ID = "flutter_naver_map_view"

    private static let SEPARATE_STRING = "#"

    internal static func createViewMethodChannelName(id: Int64) -> String {
        "\(MAP_VIEW_TYPE_ID)\(SEPARATE_STRING)\(id)"
    }

    internal static func createOverlayMethodChannelName(id: Int64) -> String {
        "\(OVERLAY_CHANNEL_NAME)\(SEPARATE_STRING)\(id)"
    }

    internal static func getAssets(path: String) -> String {
        registrar.lookupKey(forAsset: path)
    }
}

import "dart:developer";
import "dart:io";

import "package:flutter/services.dart";
import "package:flutter_naver_map/flutter_naver_map.dart";
import "package:flutter_naver_map/src/messaging/messaging.dart";
import "package:meta/meta.dart";

class FlutterNaverMap {
  @internal
  static bool isInitialized = false;

  @internal
  static int? androidSdkVersion;

  Function(NAuthFailedException ex)? onAuthFailed;

  /// 지도 사용 전에 호출해야 하는 초기화 메서드입니다.
  ///
  /// Naver Cloud Platform의 새로운 인증을 지원합니다.
  ///
  /// NCP 콘솔 좌측 사이드바의
  ///
  /// [Services > Application Services > Maps](https://console.ncloud.com/maps/application)에서
  /// [Application 등록](https://console.ncloud.com/maps/application/create)을 클릭 후,
  ///
  /// API 선택에서 "Dynamic Map"을 체크합니다.
  ///
  /// 이후, 인증정보에서 Client ID 값을 확인하실 수 있습니다.
  Future<void> init({
    String? clientId,
    Function(NAuthFailedException ex)? onAuthFailed,
  }) async {
    if (!isInitialized) {
      NChannel.sdkChannel.setMethodCallHandler(_handler);
    }

    this.onAuthFailed = onAuthFailed;

    final result = await NChannel.sdkChannel.invokeMethod("initializeNcp",
        {"clientId": clientId, "setAuthFailedListener": onAuthFailed != null});

    if (result != null) androidSdkVersion = result["androidSdkVersion"];
    isInitialized = true;

    log("SDK Initialized! (${Platform.operatingSystem}${Platform.isAndroid ? ", SDK $androidSdkVersion" : ""})",
        name: "FlutterNaverMap");
  }

  @internal
  Future<String?> getNativeMapSdkVersion() async {
    final version = await NChannel.sdkChannel.invokeMethod<String>(
        "getNativeMapSdkVersion");
    return version;
  }

  Future<void> _handler(MethodCall call) async {
    if (call.method == "onAuthFailed" && onAuthFailed != null) {
      onAuthFailed!.call(NAuthFailedException.fromMessageable(call.arguments));
    }
  }
}

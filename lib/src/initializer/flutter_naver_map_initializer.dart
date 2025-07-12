part of "../../flutter_naver_map.dart";

class FlutterNaverMap {
  static bool _isInitialized = false;

  static int? _androidSdkVersion;

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
    if (!_isInitialized) {
      NChannel.sdkChannel.setMethodCallHandler(_handler);
    }

    this.onAuthFailed = onAuthFailed;

    final result = await NChannel.sdkChannel.invokeMethod("initializeNcp",
        {"clientId": clientId, "setAuthFailedListener": onAuthFailed != null});

    if (result != null) _androidSdkVersion = result["androidSdkVersion"];
    _isInitialized = true;

    log("SDK Initialized! (${Platform.operatingSystem}${Platform.isAndroid ? ", SDK $_androidSdkVersion" : ""})",
        name: "FlutterNaverMap");
  }

  Future<void> _handler(MethodCall call) async {
    if (call.method == "onAuthFailed" && onAuthFailed != null) {
      final code = call.arguments["code"];
      final message = call.arguments["message"];
      onAuthFailed!.call(NAuthFailedException._internal(code, message));
    }
  }
}

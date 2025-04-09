part of "../../flutter_naver_map.dart";

class FlutterNaverMap {
  static bool _isInitialized = false;

  static int? _androidSdkVersion;

  Function(NAuthFailedException ex)? onAuthFailed;

  /// 지도 사용 전에 호출해야 하는 초기화 메서드입니다.
  ///
  /// Naver Cloud Platform의 새로운 인증을 지원합니다.
  Future<void> init({
    String? clientId,
    Function(NAuthFailedException ex)? onAuthFailed,
  }) async {
    if (_isInitialized) return;

    NChannel.sdkChannel.setMethodCallHandler(_handler);
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

part of "../../flutter_naver_map.dart";

class _NaverMapSdkImpl implements NaverMapSdk {
  @override
  bool _isInitialized = false;

  @override
  int? _androidSdkVersion;

  @override
  Function(NAuthFailedException ex)? onAuthFailed;

  @override
  Future<void> initialize({
    String? clientId,
    bool gov = false,
    Function(NAuthFailedException ex)? onAuthFailed,
  }) async {
    if (_isInitialized) return;

    NChannel.sdkChannel.setMethodCallHandler(_handler);
    this.onAuthFailed = onAuthFailed;

    final result = await NChannel.sdkChannel.invokeMethod("initialize", {
      "clientId": clientId,
      "gov": gov,
      "setAuthFailedListener": onAuthFailed != null
    });

    if (result != null) _androidSdkVersion = result["androidSdkVersion"];
    _isInitialized = true;

    log("SDK Initialized! (${Platform.operatingSystem}${Platform.isAndroid ? ", SDK $_androidSdkVersion" : ""})",
        name: "NaverMapSdk");
  }

  Future<void> _handler(MethodCall call) async {
    if (call.method == "onAuthFailed" && onAuthFailed != null) {
      onAuthFailed!.call(NAuthFailedException.fromMessageable(call.arguments));
    }
  }
}

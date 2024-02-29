part of "../../flutter_naver_map.dart";

abstract class NaverMapSdk {
  static final NaverMapSdk instance = _NaverMapSdkImpl();

  bool get _isInitialized;

  int? get _androidSdkVersion;

  Function(NAuthFailedException ex)? get onAuthFailed;

  Future<void> initialize({
    String? clientId,
    bool gov = false,
    Function(NAuthFailedException ex)? onAuthFailed,
  });
}

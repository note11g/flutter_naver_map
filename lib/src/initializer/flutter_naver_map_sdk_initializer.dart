part of "../../flutter_naver_map.dart";

abstract class NaverMapSdk {
  static final NaverMapSdk instance = _NaverMapSdkImpl();

  bool get _isInitialized;

  int? get _androidSdkVersion;

  Function(NAuthFailedException ex)? get onAuthFailed;

  /// 지도 사용 전에 호출해야 하는 초기화 메서드입니다.
  Future<void> initialize({
    String? clientId,
    bool gov = false,
    Function(NAuthFailedException ex)? onAuthFailed,
  });
}

part of "../../../../../../flutter_naver_map.dart";

/// 지도에 개발자가 직접 추가할 수 있는 오버레이들의 부모 클래스입니다.
sealed class NAddableOverlay<O extends NOverlay<void>> extends NOverlay<O>
    with NMessageableWithMap {
  NAddableOverlay({required NOverlayType type, required String id})
      : super(NOverlayInfo(type: type, id: id));

  bool get isAdded => _isAdded;
}

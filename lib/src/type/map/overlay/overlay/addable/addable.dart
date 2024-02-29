part of "../../../../../../flutter_naver_map.dart";

abstract class NAddableOverlay<O extends NOverlay<void>> extends NOverlay<O>
    with NMessageableWithMap {
  NAddableOverlay({required NOverlayType type, required String id})
      : super(NOverlayInfo(type: type, id: id));

  bool get isAdded => _isAdded;
}

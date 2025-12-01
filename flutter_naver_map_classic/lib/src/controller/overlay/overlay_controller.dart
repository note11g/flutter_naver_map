part of "../../../flutter_naver_map.dart";

abstract class _NOverlayController with NChannelWrapper {
  NLocationOverlay? locationOverlay;

  /// dependent at lifecycle with view(widget)
  int get viewId;

  void add(NOverlayInfo info, NOverlay overlay);

  void deleteWithInfo(NOverlayInfo info);

  void clear(NOverlayType? type);
}

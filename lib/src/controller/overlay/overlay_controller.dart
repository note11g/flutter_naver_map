part of flutter_naver_map;

abstract class _NOverlayController with NChannelWrapper {
  NLocationOverlay? locationOverlay;

  void add(NOverlayInfo info, NOverlay overlay);

  void deleteWithInfo(NOverlayInfo info);

  void clear(NOverlayType? type);
}

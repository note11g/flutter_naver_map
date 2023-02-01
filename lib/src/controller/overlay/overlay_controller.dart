part of flutter_naver_map;

abstract class _NOverlayController with NChannelWrapper {
  NLocationOverlay get locationOverlay;

  void add(NOverlayInfo info, NOverlay overlay);

  void disposeWithInfo(NOverlayInfo info);

  void clear(NOverlayType? type);
}

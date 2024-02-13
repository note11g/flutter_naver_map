part of flutter_naver_map;

// 보내야 하는 것들이라서, 모든 반환 값이 Future.
// but, 값을 얻기 위해 반환하는게 매번 Future일 필요는 X
// [getCameraPosition]
// [getContentBounds]
// [getContentRegion]
//
abstract class _NaverMapControlSender {
  /// return :
  ///  true if the camera update was canceled
  Future<bool> updateCamera(NCameraUpdate cameraUpdate);

  Future<void> cancelTransitions(
      {NCameraUpdateReason reason = NCameraUpdateReason.developer});

  /// normally, using nowCameraPosition property.
  /// this method provide exact currentCameraPosition.
  Future<NCameraPosition> getCameraPosition();

  Future<NLatLngBounds> getContentBounds({bool withPadding = false});

  Future<List<NLatLng>> getContentRegion({bool withPadding = false});

  Future<NLocationOverlay> getLocationOverlay();

  Future<NLatLng> screenLocationToLatLng(NPoint point);

  Future<NPoint> latLngToScreenLocation(NLatLng latLng);

  /// meter / 1dp (logical pixel)
  ///
  /// if's same `getMeterPerDpAtLatitude` + nowCameraPosition.
  ///
  /// using parameter is removed. if you want measure with specific latitude&zoomLevel, use [getMeterPerDpAtLatitude] instead.
  double getMeterPerDp();

  /// meter / 1dp at latitude (required zoomLevel)
  double getMeterPerDpAtLatitude({
    required double latitude,
    required double zoom,
  });

  Future<List<NPickableInfo>> pickAll(NPoint point, {double radius = 0});

  Future<File> takeSnapshot(
      {bool showControls = true, int compressQuality = 80});

  Future<void> setLocationTrackingMode(NLocationTrackingMode mode);

  Future<NLocationTrackingMode> getLocationTrackingMode();

  Future<void> addOverlay(NAddableOverlay overlay);

  Future<void> addOverlayAll(Set<NAddableOverlay> overlays);

  Future<void> deleteOverlay(NOverlayInfo info);

  Future<void> clearOverlays({NOverlayType? type});

  Future<void> forceRefresh();

  /*
    --- private methods ---
  */
  void _updateOptions(NaverMapViewOptions options);
}

part of "../../../flutter_naver_map.dart";

abstract class _NaverMapControlSender {
  /// 지도에 보이는 위치(영역)를 변경하기 위해, 지도를 비추는 카메라를 이동시킵니다.
  /// return :
  ///  true if the camera update was canceled
  Future<bool> updateCamera(NCameraUpdate cameraUpdate);

  /// 카메라가 이동 중일 때, 카메라 이동을 취소 시킵니다.
  Future<void> cancelTransitions(
      {NCameraUpdateReason reason = NCameraUpdateReason.developer});

  /// 카메라의 위치를 가져오는 메서드입니다.
  /// 네이티브 호출 비용이 발생할 수 있으니, 정확한 위치가 보장되어야 하는 것이 아니라면 [nowCameraPosition]을 대신 사용하세요.
  ///
  /// normally, using nowCameraPosition property.
  /// this method provide exact currentCameraPosition.
  Future<NCameraPosition> getCameraPosition();

  /// 현재 카메라로 보이는 지도의 영역을 가져옵니다.
  /// withPadding이 true라면, NaverMapViewOptions.contentPadding이 적용된 영역만 가져옵니다.
  ///
  /// 반환값: 현재 보이는 지도의 경계 좌표
  Future<NLatLngBounds> getContentBounds({bool withPadding = false});

  /// 현재 보이는 지도의 영역을 가져옵니다.
  /// withPadding이 true라면, NaverMapViewOptions.contentPadding이 적용된 영역만 가져옵니다.
  ///
  /// 반환값: 현재 보이는 지도의 영역
  Future<List<NLatLng>> getContentRegion({bool withPadding = false});

  /// 위치 오버레이를 가져옵니다. 위치 오버레이는 직접 생성하지 않고 이 메서드를 통해 가져옵니다.
  NLocationOverlay getLocationOverlay();

  /// 화면 좌표를 위경도 좌표로 변환합니다.
  ///
  /// 반환값: 변환된 위경도 좌표
  Future<NLatLng> screenLocationToLatLng(NPoint point);

  /// 위경도 좌표를 화면 좌표로 변환합니다.
  ///
  /// 반환값: 변환된 화면 좌표
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

  /// 특정 화면 좌표를 클릭했을 때, 그 좌표에 존재하는 모든 오버레이와 심볼 정보를 가져옵니다.
  ///
  /// 반환값: 해당 좌표에 존재하는 모든 오버레이와 심볼 정보
  Future<List<NPickableInfo>> pickAll(NPoint point, {double radius = 0});

  /// 현재 보이는 지도를 이미지 파일로 저장합니다.
  ///
  /// 앱 내의 임시 저장소에 저장되므로, 앱 종료 시점 이전에 사용하시기 바랍니다.
  ///
  /// compressQuality는 캡쳐한 이미지의 품질을 지정합니다. (100=원본)
  ///
  /// 반환값: 캡쳐한 이미지 파일
  Future<File> takeSnapshot({
    @Deprecated("showControls is not supported from 1.4.0")
    bool showControls = false,
    int compressQuality = 80,
  });

  /// 위치 추적 모드를 설정합니다.
  void setLocationTrackingMode(NLocationTrackingMode mode);

  /// 현재 설정된 위치 추적 모드를 가져옵니다.
  ///
  /// 반환값: 현재 위치 추적 모드
  NLocationTrackingMode get locationTrackingMode;

  void setMyLocationTracker(NMyLocationTracker tracker);

  NMyLocationTracker get myLocationTracker;

  /// 새로운 오버레이를 추가합니다.
  Future<void> addOverlay(NAddableOverlay overlay);

  /// 여러 개의 오버레이를 한 번에 추가합니다.
  Future<void> addOverlayAll(Set<NAddableOverlay> overlays);

  /// 특정 오버레이를 제거합니다.
  Future<void> deleteOverlay(NOverlayInfo info);

  /// 모든 오버레이를 제거합니다. type을 지정하면 해당 타입의 오버레이만 제거합니다.
  Future<void> clearOverlays({NOverlayType? type});

  /// 지도를 강제로 새로고침합니다.
  Future<void> forceRefresh();

  /*
    --- internal methods ---
   */

  Future<void> openMapOpenSourceLicense();

  Future<void> openLegend();

  Future<void> openLegalNotice();

  /*
    --- private methods ---
  */
  Future<void> _updateOptions(NaverMapViewOptions options);

  Future<void> _updateClusteringOptions(NaverMapClusteringOptions options);
}

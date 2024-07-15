part of "../../../flutter_naver_map.dart";

abstract class NaverMapController implements _NaverMapControlSender {
  static NaverMapController _createController(MethodChannel controllerChannel,
      {required int viewId, required NCameraPosition initialCameraPosition}) {
    final overlayController = _NOverlayControllerImpl(viewId: viewId);
    return _NaverMapControllerImpl(
        controllerChannel, overlayController, initialCameraPosition);
  }

  void dispose();

  /// 이 프로퍼티는 지금 카메라가 보여주고 있는 위치를 나타냅니다.
  ///
  /// This property allows you to retrieve the position of the camera currently displayed on the map.
  ///
  /// It is currently in the **experimental stage**.
  ///
  /// For exact results, please use the [getCameraPosition] method.
  @experimental
  NCameraPosition get nowCameraPosition;

  void _updateNowCameraPositionData(NCameraPosition position);
}

class _NaverMapControllerImpl
    with NChannelWrapper
    implements NaverMapController {
  @override
  final MethodChannel channel;

  final _NOverlayController overlayController;

  @override
  NCameraPosition nowCameraPosition;

  _NaverMapControllerImpl(
      this.channel, this.overlayController, this.nowCameraPosition);

  @override
  Future<bool> updateCamera(NCameraUpdate cameraUpdate) async {
    final rawIsCanceled = await invokeMethod("updateCamera", cameraUpdate);
    return rawIsCanceled as bool;
  }

  @override
  Future<void> cancelTransitions(
      {NCameraUpdateReason reason = NCameraUpdateReason.developer}) async {
    await invokeMethod("cancelTransitions", reason);
  }

  @override
  Future<NCameraPosition> getCameraPosition() async {
    final rawCameraPosition = await invokeMethod("getCameraPosition");
    return NCameraPosition._fromMessageable(rawCameraPosition);
  }

  @override
  Future<NLatLngBounds> getContentBounds({bool withPadding = false}) async {
    final messageable = NMessageable.forOnce(withPadding);
    final rawLatLngBounds = await invokeMethod("getContentBounds", messageable);
    return NLatLngBounds._fromMessageable(rawLatLngBounds);
  }

  @override
  Future<List<NLatLng>> getContentRegion({bool withPadding = false}) async {
    final messageable = NMessageable.forOnce(withPadding);
    final rawLatLngs = await invokeMethod("getContentRegion", messageable)
        .then((rawList) => rawList as List);
    return rawLatLngs.map(NLatLng._fromMessageable).toList();
  }

  @override
  NLocationOverlay getLocationOverlay() {
    if (overlayController.locationOverlay != null) {
      return overlayController.locationOverlay!;
    }
    final lo = NLocationOverlay._attachToMapWhenFirstUse(overlayController);
    overlayController.locationOverlay = lo;
    return lo;
  }

  @override
  Future<NLatLng> screenLocationToLatLng(NPoint point) {
    return invokeMethod("screenLocationToLatLng", point)
        .then((rawLatLng) => NLatLng._fromMessageable(rawLatLng));
  }

  @override
  Future<NPoint> latLngToScreenLocation(NLatLng latLng) {
    return invokeMethod("latLngToScreenLocation", latLng)
        .then((rawPoint) => NPoint._fromMessageable(rawPoint));
  }

  @override
  double getMeterPerDp() {
    return getMeterPerDpAtLatitude(
        latitude: nowCameraPosition.target.latitude,
        zoom: nowCameraPosition.zoom);
  }

  @override
  double getMeterPerDpAtLatitude(
      {required double latitude, required double zoom}) {
    return MathUtil.calcMeterPerDp(latitude, zoom);
  }

  @override
  Future<List<NPickableInfo>> pickAll(NPoint point, {double radius = 0}) async {
    final messageable =
        NMessageable.forOnceWithMap({"point": point, "radius": radius});

    final rawList =
        await invokeMethod("pickAll", messageable).then((raw) => raw as List);
    final pickableInfoList =
        rawList.map(NPickableInfo._fromMessageable).toList();

    return pickableInfoList;
  }

  @override
  Future<File> takeSnapshot(
      {bool showControls = true, int compressQuality = 80}) async {
    final messageable = NMessageable.forOnceWithMap({
      "showControls": showControls,
      "compressQuality": compressQuality,
    });
    final path = await invokeMethod("takeSnapshot", messageable)
        .then((raw) => raw as String);
    return File(path);
  }

  @override
  Future<void> setLocationTrackingMode(NLocationTrackingMode mode) async {
    await invokeMethod("setLocationTrackingMode", mode);
  }

  @override
  Future<NLocationTrackingMode> getLocationTrackingMode() async {
    final rawLocationTrackingMode =
        await invokeMethod("getLocationTrackingMode");
    return NLocationTrackingMode._fromMessageable(rawLocationTrackingMode);
  }

  @override
  Future<void> addOverlay(NAddableOverlay overlay) {
    return addOverlayAll({overlay});
  }

  @override
  Future<void> addOverlayAll(Set<NAddableOverlay> overlays) async {
    log("${DateTime.now()}: addedOnMap");
    for (final overlay in overlays) {
      overlay._addedOnMap(overlayController);
    }
    log("${DateTime.now()}: invokeMethodWithIterable");
    await invokeMethodWithIterable("addOverlayAll", overlays);
  }

  @override
  Future<void> deleteOverlay(NOverlayInfo info) async {
    assert(info.type != NOverlayType.locationOverlay);
    await invokeMethod("deleteOverlay", info);
    overlayController.deleteWithInfo(info);
  }

  @override
  Future<void> clearOverlays({NOverlayType? type}) async {
    assert(type != NOverlayType.locationOverlay);
    overlayController.clear(type);
    await invokeMethod("clearOverlays", type);
  }

  @override
  Future<void> forceRefresh() async {
    await invokeMethod("forceRefresh");
  }

  /*
    --- private methods ---
  */
  @override
  void _updateOptions(NaverMapViewOptions options) {
    invokeMethod("updateOptions", options);
  }

  @override
  void _updateNowCameraPositionData(NCameraPosition position) {
    nowCameraPosition = position;
  }

  /*
    --- low level methods ---
  */

  @override
  String toString() => "NaverMapController(channel: ${channel.name})";

  @override
  void dispose() {
    overlayController.disposeChannel();
  }
}

part of "../../../flutter_naver_map.dart";

typedef _OnCameraChangedParams = ({
  NCameraPosition position,
  NCameraUpdateReason reason
});

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

  Stream<_OnCameraChangedParams> get _nowCameraPositionStream;

  Stream<NLocationTrackingMode> get _locationTrackingModeStream;

  void _updateNowCameraPositionData(
      NCameraPosition position, NCameraUpdateReason reason);
}

class _NaverMapControllerImpl
    with NChannelWrapper
    implements NaverMapController {
  @override
  final MethodChannel channel;

  final _NOverlayController overlayController;

  @override
  NCameraPosition get nowCameraPosition =>
      _nowCameraPositionStreamController.currentData.position;

  @override
  Stream<_OnCameraChangedParams> get _nowCameraPositionStream =>
      _nowCameraPositionStreamController.stream;

  final NValueHoldHotStreamController<_OnCameraChangedParams>
      _nowCameraPositionStreamController;

  _NaverMapControllerImpl(this.channel, this.overlayController,
      NCameraPosition initialCameraPosition)
      : _nowCameraPositionStreamController =
            NValueHoldHotStreamController<_OnCameraChangedParams>((
          position: initialCameraPosition,
          reason: NCameraUpdateReason.developer
        ));

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
    return NLatLngBounds.fromMessageable(rawLatLngBounds);
  }

  @override
  Future<List<NLatLng>> getContentRegion({bool withPadding = false}) async {
    final messageable = NMessageable.forOnce(withPadding);
    final rawLatLngs = await invokeMethod("getContentRegion", messageable)
        .then((rawList) => rawList as List);
    return rawLatLngs.map(NLatLng.fromMessageable).toList();
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
        .then((rawLatLng) => NLatLng.fromMessageable(rawLatLng));
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
  Future<File> takeSnapshot({
    @Deprecated("showControls is not supported from 1.4.0")
    bool showControls = false,
    int compressQuality = 80,
  }) async {
    final messageable = NMessageable.forOnceWithMap({
      "showControls": showControls, // deprecated
      "compressQuality": compressQuality,
    });
    final path = await invokeMethod("takeSnapshot", messageable)
        .then((raw) => raw as String);
    return File(path);
  }

  final _trackingModeStreamController =
      NValueHoldHotStreamController(NLocationTrackingMode.none);

  @override
  Stream<NLocationTrackingMode> get _locationTrackingModeStream =>
      _trackingModeStreamController.stream;

  @override
  NLocationTrackingMode get locationTrackingMode =>
      _trackingModeStreamController.currentData;

  @override
  void setLocationTrackingMode(NLocationTrackingMode mode) {
    if (locationTrackingMode == mode) return; // guard distinct
    final oldMode = locationTrackingMode;
    _trackingModeStreamController.add(mode);
    myLocationTracker._onChangeTrackingMode(
        getLocationOverlay(), this, mode, oldMode);
  }

  @override
  NMyLocationTracker myLocationTracker = NDefaultMyLocationTracker();

  @override
  void setMyLocationTracker(NMyLocationTracker tracker) {
    myLocationTracker = tracker;
  }

  @override
  Future<void> addOverlay(NAddableOverlay overlay) {
    return addOverlayAll({overlay});
  }

  @override
  Future<void> addOverlayAll(Set<NAddableOverlay> overlays) async {
    final addTaskFuture = invokeMethodWithIterable("addOverlayAll", overlays);
    _connectOverlayControllerOnOverlays(overlays);
    await addTaskFuture;
  }

  void _connectOverlayControllerOnOverlays(Iterable<NAddableOverlay> overlays) {
    for (final overlay in overlays) {
      overlay._addedOnMap(overlayController);
    }
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
    --- internal methods ---
   */

  @override
  Future<void> openMapOpenSourceLicense() async {
    await invokeMethod("openMapOpenSourceLicense");
  }

  @override
  Future<void> openLegend() async {
    await invokeMethod("openLegend");
  }

  @override
  Future<void> openLegalNotice() async {
    await invokeMethod("openLegalNotice");
  }

  /*
    --- private methods ---
  */
  @override
  Future<void> _updateOptions(NaverMapViewOptions options) {
    return invokeMethod("updateOptions", options);
  }

  @override
  Future<void> _updateClusteringOptions(NaverMapClusteringOptions options) {
    return invokeMethod("updateClusteringOptions", options);
  }

  @override
  void _updateNowCameraPositionData(
      NCameraPosition position, NCameraUpdateReason reason) {
    _nowCameraPositionStreamController
        .add((position: position, reason: reason));
  }

  /*
    --- low level methods ---
  */

  @override
  String toString() => "NaverMapController(channel: ${channel.name})";

  @override
  void dispose() {
    myLocationTracker._stopTracking();
    overlayController.disposeChannel();
    _nowCameraPositionStreamController.close();
    _trackingModeStreamController.close();
  }
}

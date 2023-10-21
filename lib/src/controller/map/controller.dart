part of flutter_naver_map;

abstract class NaverMapController implements _NaverMapControlSender {
  static NaverMapController _createController(MethodChannel controllerChannel,
      {required int viewId}) {
    final overlayController = _NOverlayControllerImpl(viewId: viewId);
    return _NaverMapControllerImpl(controllerChannel, overlayController);
  }

  void dispose();
}

class _NaverMapControllerImpl
    with NChannelWrapper
    implements NaverMapController {
  @override
  final MethodChannel channel;

  final _NOverlayController overlayController;

  _NaverMapControllerImpl(this.channel, this.overlayController);

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
  Future<NLocationOverlay> getLocationOverlay() async {
    final rawLocationOverlay = await invokeMethod("getLocationOverlay");
    overlayController.locationOverlay ??=
        NLocationOverlay._fromMessageable(rawLocationOverlay)
          .._addedOnMap(overlayController);
    return overlayController.locationOverlay!;
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
  Future<double> getMeterPerDp({double? latitude, double? zoom}) {
    final messageable = NMessageable.forOnceWithMap({
      "latitude": latitude,
      "zoom": zoom,
    });
    return invokeMethod("getMeterPerDp", messageable)
        .then((value) => value as double);
  }

  @override
  Future<double> getMeterPerDpAtLatitude({
    required double latitude,
    required double zoom,
  }) {
    final messageable = NMessageable.forOnceWithMap({
      "latitude": latitude,
      "zoom": zoom,
    });
    return invokeMethod("getMeterPerDpAtLatitude", messageable)
        .then((value) => value as double);
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
    for (final overlay in overlays) {
      overlay._addedOnMap(overlayController);
    }
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

  /*
    --- private methods ---
  */
  @override
  void _updateOptions(NaverMapViewOptions options) {
    invokeMethod("updateOptions", options);
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

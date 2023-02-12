part of flutter_naver_map;

abstract class NaverMapController extends _NaverMapControlSender {
  static NaverMapController createController(MethodChannel controllerChannel,
      {required int viewId}) {
    final overlayController = _NOverlayControllerImpl(
        NChannel.overlayChannelName.createChannel(viewId));
    return _NaverMapControllerImpl(controllerChannel, overlayController);
  }
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
    await invokeMethod("getLocationOverlay");
    return overlayController.locationOverlay;
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
  Future<List<Pickable>> pickAll(NPoint point, {double radius = 0}) async {
    final messageable = NMessageable.forOnceWithMap({
      "point": point,
      "radius": radius,
    });
    final rawPickables = await invokeMethod("pickAll", messageable)
        .then((rawList) => rawList as List);

    final List<Pickable> result = rawPickables
        .map((rawPickable) => Pickable._fromMessageable(rawPickable,
            overlayController: overlayController))
        .toList();
    return result;
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
    await invokeMethodWithList("addOverlayAll", overlays.toList());
  }

  @override
  Future<void> deleteOverlay(
      {required NOverlayType type, required String id}) async {
    assert(type != NOverlayType.locationOverlay);

    final overlayInfo = NOverlayInfo._(type: type, id: id);
    await invokeMethod("deleteOverlay", overlayInfo);
    overlayController.disposeWithInfo(overlayInfo);
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
}

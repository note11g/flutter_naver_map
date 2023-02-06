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
    await invokeMethodWithEnum("cancelTransitions", reason);
  }

  @override
  Future<NCameraPosition> getCameraPosition() async {
    final rawCameraPosition = await invokeMethod("getCameraPosition");
    return NCameraPosition._fromJson(rawCameraPosition);
  }

  @override
  Future<NLatLngBounds> getContentBounds({bool withPadding = false}) async {
    final rawLatLngBounds =
        await invokeMethodWithMessageableArgs("getContentBounds", withPadding);
    return NLatLngBounds._fromJson(rawLatLngBounds);
  }

  @override
  Future<List<NLatLng>> getContentRegion({bool withPadding = false}) async {
    final listWithRawLatLng =
        await invokeMethodWithMessageableArgs("getContentRegion", withPadding)
            .then((rawList) => rawList as List);
    return listWithRawLatLng
        .map((rawLatLng) => NLatLng._fromJson(rawLatLng))
        .toList();
  }

  @override
  Future<NLocationOverlay> getLocationOverlay() async {
    await invokeMethod("getLocationOverlay");
    return overlayController.locationOverlay;
  }

  @override
  Future<NLatLng> screenLocationToLatLng(NPoint point) {
    return invokeMethod("screenLocationToLatLng", point)
        .then((rawLatLng) => NLatLng._fromJson(rawLatLng));
  }

  @override
  Future<NPoint> latLngToScreenLocation(NLatLng latLng) {
    return invokeMethod("latLngToScreenLocation", latLng)
        .then((rawPoint) => NPoint._fromJson(rawPoint));
  }

  @override
  Future<double> getMeterPerDp({double? latitude, double? zoom}) {
    return invokeMethodWithMessageableArgs("getMeterPerDp", {
      "latitude": latitude,
      "zoom": zoom,
    }).then((value) => value as double);
  }

  @override
  Future<bool> isDestroyed() async {
    final result = await invokeMethod("isDestroyed");
    return result as bool;
  }

  @override
  Future<List<Pickable>> pickAll(NPoint point, {double radius = 0}) async {
    final rawPickables = await invokeMethodWithMessageableArgs("pickAll", {
      "point": point.toNPayload().json,
      "radius": radius,
    }).then((rawList) => rawList as List);

    final List<Pickable> result = rawPickables.map((rawPickable) {
      log("rawPickable: $rawPickable");
      return Pickable._fromJson(rawPickable,
          overlayController: overlayController);
    }).toList();

    return result;
  }

  @override
  Future<String> takeSnapshot(
      {bool showControls = true, int compressQuality = 80}) async {
    final rawPath = await invokeMethodWithMessageableArgs("takeSnapshot", {
      "showControls": showControls,
      "compressQuality": compressQuality,
    });
    return rawPath as String;
  }

  @override
  Future<void> setLocationTrackingMode(NLocationTrackingMode mode) async {
    await invokeMethodWithEnum("setLocationTrackingMode", mode);
  }

  @override
  Future<NLocationTrackingMode> getLocationTrackingMode() async {
    final rawLocationTrackingMode =
        await invokeMethod("getLocationTrackingMode");
    return NLocationTrackingMode._fromJson(rawLocationTrackingMode);
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
    await invokeMethodWithEnum("clearOverlays", type);
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

import "package:flutter/services.dart";
import "package:flutter_naver_map/flutter_naver_map.dart";

import "default_my_location_tracker_platform_interface.dart";

mixin class NDefaultMyLocationTrackerPlatformImplMixin
    implements NDefaultMyLocationTrackerPlatformInterface {
  // using static for every channel. because of sensor/gps is only has one provider.
  static const _methodChannel = MethodChannel("NDefaultMyLocationTracker");
  static const _locationEventChannel =
      EventChannel("NDefaultMyLocationTracker.locationStream");
  static const _headingEventChannel =
      EventChannel("NDefaultMyLocationTracker.headingStream");

  static Stream<NLatLng>? _locationStream;
  static Stream<double>? _headingStream;

  @override
  Future<NDefaultMyLocationTrackerPermissionStatus>
      requestLocationPermission() {
    return _methodChannel
        .invokeMethod<String>("requestLocationPermission")
        .then((v) =>
            NDefaultMyLocationTrackerPermissionStatus.fromMessageable(v));
  }

  @override
  Future<NLatLng> getCurrentPositionOnce() async {
    final rawLatLng =
        await _methodChannel.invokeMethod("getCurrentPositionOnce");
    return NLatLng.fromMessageable(rawLatLng);
  }

  @override
  Stream<NLatLng> getLocationStream() {
    if (_locationStream case Stream<NLatLng> stream) return stream;
    final baseStream = _locationEventChannel.receiveBroadcastStream();
    final locationStream = baseStream.asBroadcastStream(onCancel: (sub) {
      sub.cancel();
      _locationStream = null;
    }).map((e) => NLatLng.fromMessageable(e));
    _locationStream = locationStream;
    return locationStream;
  }

  @override
  Stream<double> getHeadingStream() {
    if (_headingStream case Stream<double> stream) return stream;
    final baseStream = _headingEventChannel.receiveBroadcastStream();
    final headingStream = baseStream.asBroadcastStream(onCancel: (sub) {
      sub.cancel();
      _headingStream = null;
    }).map((e) => e as double);
    _headingStream = headingStream;
    return headingStream;
  }
}

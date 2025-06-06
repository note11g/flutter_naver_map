import "package:flutter_naver_map/flutter_naver_map.dart";

abstract interface class NDefaultMyLocationTrackerPlatformInterface {
  Future<NDefaultMyLocationTrackerPermissionStatus> requestLocationPermission();

  Future<NLatLng> getCurrentPositionOnce();

  Stream<NLatLng> getLocationStream();

  Stream<double> getHeadingStream();
}

enum NDefaultMyLocationTrackerPermissionStatus {
  granted,
  denied,
  deniedForever;

  factory NDefaultMyLocationTrackerPermissionStatus.fromMessageable(dynamic m) {
    if (m case String m) {
      return NDefaultMyLocationTrackerPermissionStatus.values.byName(m);
    } else {
      throw UnsupportedError("Unsupported type: $m");
    }
  }
}

import "package:flutter_naver_map/flutter_naver_map.dart";
import "default_my_location_tracker_platform_impl.dart";

class NDefaultMyLocationTracker extends NMyLocationTracker
    with NDefaultMyLocationTrackerPlatformImplMixin {
  final NDefaultMyLocationTrackerOptions options;
  final Function(bool isForeverDenied)? onPermissionDenied;

  NDefaultMyLocationTracker({
    this.options = const NDefaultMyLocationTrackerOptions(),
    this.onPermissionDenied,
  });

  @override
  Future<NLatLng?> startLocationService() async {
    final permissionStatus = await requestLocationPermission();
    switch (permissionStatus) {
      case NDefaultMyLocationTrackerPermissionStatus.granted:
        return getCurrentPositionOnce();
      case NDefaultMyLocationTrackerPermissionStatus.denied ||
            NDefaultMyLocationTrackerPermissionStatus.deniedForever:
        onPermissionDenied?.call(permissionStatus ==
            NDefaultMyLocationTrackerPermissionStatus.deniedForever);
        return null;
    }
  }

  @override
  void disposeLocationService() {}

  @override
  Stream<NLatLng> get locationStream => getLocationStream();

  @override
  Stream<double> get headingStream => getHeadingStream();
}

class NDefaultMyLocationTrackerOptions {
  const NDefaultMyLocationTrackerOptions();
}

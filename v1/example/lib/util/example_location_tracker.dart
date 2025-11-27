import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lat_compass/lat_compass.dart';

class NExampleMyLocationTracker extends NMyLocationTracker {
  @override
  Stream<double> get headingStream =>
      LatCompass().onUpdate.map((e) => e.trueHeading);

  @override
  Stream<NLatLng> get locationStream => Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 10))
      .map((e) => NLatLng(e.latitude, e.longitude));

  @override
  Future<NLatLng?> startLocationService() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    final permission = await Geolocator.requestPermission();
    final isGranted = switch (permission) {
      LocationPermission.whileInUse || LocationPermission.always => true,
      LocationPermission.denied ||
      LocationPermission.deniedForever ||
      LocationPermission.unableToDetermine =>
        false,
    };
    if (!isGranted) return null;

    final position = await Geolocator.getCurrentPosition();
    return NLatLng(position.latitude, position.longitude);
  }
}

import "dart:math";

import "package:flutter_naver_map/flutter_naver_map.dart";
import "package:vector_math/vector_math.dart" show radians, degrees;

class MathUtil {
  static const earthRadius = 6378137.0; // wgs84
  static const earthDiameter = 12756274.0; // wgs84
  static const _tileSize = 256.0;

  static double measureDistance(
      double lat1, double lng1, double lat2, double lng2) {
    final rLat1 = radians(lat1), rLng1 = radians(lng1);
    final rLat2 = radians(lat2), rLng2 = radians(lng2);

    return earthDiameter *
        asin(sqrt(pow(sin((rLat1 - rLat2) / 2), 2) +
            cos(rLat1) * cos(rLat2) * pow(sin((rLng1 - rLng2) / 2), 2)));
  }

  static double meterToLatitude(double verticalMeter) {
    return degrees(verticalMeter / earthRadius);
  }

  static double meterToLongitude(double horizontalMeter, double latitude) {
    return degrees(horizontalMeter / (earthRadius * cos(radians(latitude))));
  }

  static double calcMeterPerDp(double latitude, double zoom) {
    assert(NLatLng.minimumLatitude <= latitude &&
        latitude <= NLatLng.maximumLatitude);
    assert(NaverMapViewOptions.minimumZoom <= zoom &&
        zoom <= NaverMapViewOptions.maximumZoom);
    final latitudeScale = cos(radians(latitude));
    final zoomScale = pi / pow(2.0, zoom) / _tileSize * earthRadius;
    return latitudeScale * zoomScale;
  }
}

import "dart:math";

import "package:vector_math/vector_math.dart" show radians, degrees;

class MathUtil {
  static const earthRadius = 6378137;
  static const wgs84EarthDiameter = 12756274;

  static double measureDistance(
      double lat1, double lng1, double lat2, double lng2) {
    final rLat1 = radians(lat1), rLng1 = radians(lng1);
    final rLat2 = radians(lat2), rLng2 = radians(lng2);

    return wgs84EarthDiameter *
        asin(sqrt(pow(sin((rLat1 - rLat2) / 2), 2) +
            cos(rLat1) * cos(rLat2) * pow(sin((rLng1 - rLng2) / 2), 2)));
  }

  static double meterToLatitude(double verticalMeter) {
    return degrees(verticalMeter / earthRadius);
  }

  static double meterToLongitude(double horizontalMeter, double latitude) {
    return degrees(horizontalMeter / (earthRadius * cos(radians(latitude))));
  }
}

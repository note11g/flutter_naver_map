part of flutter_naver_map;

class NLatLng implements NMessageable {
  final double latitude;

  final double longitude;

  const NLatLng(this.latitude, this.longitude);

  NLatLng offsetByMeter(double northMeter, double eastMeter) {
    final latitude = this.latitude + MathUtil.meterToLatitude(northMeter);
    final longitude =
        this.longitude + MathUtil.meterToLongitude(eastMeter, this.latitude);
    return NLatLng(latitude, longitude);
  }

  double distanceTo(NLatLng other) {
    if (this == other) return 0;
    return MathUtil.measureDistance(
        latitude, longitude, other.latitude, other.longitude);
  }

  bool isWithinCoverage() {
    return worldCoverage.containsPoint(this);
  }

  /*
    --- required method ---
  */

  @override
  String toString() => "$runtimeType: ${toNPayload().m}";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NLatLng &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  NPayload toNPayload() => NPayload.make({"lat": latitude, "lng": longitude});

  factory NLatLng._fromMessageable(dynamic m) => NLatLng(m["lat"], m["lng"]);

  /*
    --- static constant ---
  */

  static const double minimumLatitude = -90.0;
  static const double maximumLatitude = 90.0;
  static const double minimumLongitude = -180.0;
  static const double maximumLongitude = 180.0;

  static const NLatLngBounds worldCoverage = NLatLngBounds(
      southWest: NLatLng(minimumLatitude, minimumLongitude),
      northEast: NLatLng(maximumLatitude, maximumLongitude));
}

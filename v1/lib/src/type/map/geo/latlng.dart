part of "../../../../flutter_naver_map.dart";

/// 위도(Latitude)와 경도(longitude)를 사용하여 좌표를 나타내는 객체입니다.
///
/// 자세한 내용은 문서를 참조하세요. [문서 바로가기](https://note11.dev/flutter_naver_map/element/coord#nlatlng-%EC%9C%84%EB%8F%84-%EA%B2%BD%EB%8F%84)
class NLatLng with NMessageableWithMap {
  final double latitude;

  final double longitude;

  const NLatLng(this.latitude, this.longitude);

  /// 특정 위치에서 일정 거리(m)만큼 떨어진 지점을 구하는 메서드입니다.
  ///
  /// 반환값은 일정 거리만큼 떨어진 지점의 좌표를 [NLatLng] 객체로 반환합니다.
  NLatLng offsetByMeter({double northMeter = 0, double eastMeter = 0}) {
    final latitude = this.latitude + MathUtil.meterToLatitude(northMeter);
    final longitude =
        this.longitude + MathUtil.meterToLongitude(eastMeter, this.latitude);
    return NLatLng(latitude, longitude);
  }

  /// 다른 위치와 얼마나 떨어져 있는지 구하는 메서드입니다.
  /// 반환값은 인자로 넘겨준 지점과 얼마나 떨어져있는지 미터(m) 단위로 반환합니다.
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
  String toString() => "$runtimeType: ${toNPayload().map}";

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

  @internal
  factory NLatLng.fromMessageable(dynamic m) => NLatLng(m["lat"], m["lng"]);

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

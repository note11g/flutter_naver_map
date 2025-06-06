part of "../../../../flutter_naver_map.dart";

/// 카메라가 보여주는 곳을 나타낼 때 사용하는 객체입니다.
///
/// 문서를 참고하세요. [문서 보러가기](https://note11.dev/flutter_naver_map/element/camera#ncameraposition)
class NCameraPosition with NMessageableWithMap {
  final NLatLng target;
  final double zoom;
  final double tilt;
  final double bearing;

  const NCameraPosition(
      {required this.target,
      required this.zoom,
      this.tilt = 0,
      this.bearing = 0});

  factory NCameraPosition._fromMessageable(dynamic map) {
    return NCameraPosition(
      target: NLatLng.fromMessageable(map["target"]),
      zoom: map["zoom"],
      tilt: map["tilt"],
      bearing: map["bearing"],
    );
  }

  NCameraPosition copyWith({
    NLatLng? target,
    double? zoom,
    double? tilt,
    double? bearing,
  }) =>
      NCameraPosition(
        target: target ?? this.target,
        zoom: zoom ?? this.zoom,
        bearing: bearing ?? this.bearing,
        tilt: tilt ?? this.tilt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NCameraPosition &&
          runtimeType == other.runtimeType &&
          target == other.target &&
          zoom == other.zoom &&
          tilt == other.tilt &&
          bearing == other.bearing;

  @override
  int get hashCode =>
      target.hashCode ^ zoom.hashCode ^ tilt.hashCode ^ bearing.hashCode;

  @override
  String toString() => "$runtimeType: ${toNPayload().map}";

  @override
  NPayload toNPayload() => NPayload.make({
        "target": target,
        "zoom": zoom,
        "tilt": tilt,
        "bearing": bearing,
      });
}

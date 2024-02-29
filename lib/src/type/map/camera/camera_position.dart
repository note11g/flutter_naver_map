part of "../../../../flutter_naver_map.dart";

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
      target: NLatLng._fromMessageable(map["target"]),
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
  String toString() => "$runtimeType: ${toNPayload().map}";

  @override
  NPayload toNPayload() => NPayload.make({
        "target": target,
        "zoom": zoom,
        "tilt": tilt,
        "bearing": bearing,
      });
}

part of flutter_naver_map;

/// NPoint 의 x, y는 소수점 6자리 이내의 정확도만 보장합니다.
class NPoint extends Point<double> implements NMessageable {
  const NPoint(super.x, super.y);

  @override
  NPayload toNPayload() =>
      NPayload.make({
        "x": x,
        "y": y,
      });

  factory NPoint._fromJson(dynamic json) => NPoint(json["x"], json["y"]);

  @override
  String toString() => "NPoint(x: $x, y: $y)";
}

part of "../../../flutter_naver_map.dart";

/// NPoint 의 x, y는 소수점 6자리 이내의 정확도만 보장합니다.
class NPoint extends Point<double> with NMessageableWithMap {
  const NPoint(super.x, super.y);

  @override
  NPayload toNPayload() => NPayload.make({
        "x": x,
        "y": y,
      });

  factory NPoint._fromMessageable(dynamic m) => NPoint(m["x"], m["y"]);

  @override
  String toString() => "NPoint(x: $x, y: $y)";
}

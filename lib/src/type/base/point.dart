part of "../../../flutter_naver_map.dart";

/// NPoint 의 x, y는 소수점 6자리 이내의 정확도만 보장합니다.
class NPoint extends math.Point<double> with NMessageableWithMap {
  const NPoint(super.x, super.y);

  /// NPoint(0, 0)~NPoint(1, 1)의 중앙 값입니다.
  ///
  /// 화면의 절대 위치를 나타낼 때는 사용하지 않습니다.
  static const relativeCenter = NPoint(0.5, 0.5);

  @override
  NPayload toNPayload() => NPayload.make({
        "x": x,
        "y": y,
      });

  factory NPoint._fromMessageable(dynamic m) => NPoint(m["x"], m["y"]);

  @override
  String toString() => "NPoint(x: $x, y: $y)";
}

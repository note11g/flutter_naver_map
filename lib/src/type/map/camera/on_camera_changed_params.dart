part of "../../../../flutter_naver_map.dart";

class OnCameraChangedParams {
  final NCameraPosition position;
  final NCameraUpdateReason reason;
  final bool isIdle;

  const OnCameraChangedParams(
      {required this.position, required this.reason, required this.isIdle});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnCameraChangedParams &&
          runtimeType == other.runtimeType &&
          position == other.position &&
          reason == other.reason &&
          isIdle == other.isIdle;

  @override
  int get hashCode => position.hashCode ^ reason.hashCode ^ isIdle.hashCode;

  @override
  String toString() {
    return "OnCameraChangedParams{position: $position, reason: $reason, isIdle: $isIdle}";
  }
}

part of "../../../../flutter_naver_map.dart";

/// 실내 지도에서 하나의 층을 나타내는 객체입니다.
///
/// 실내 지도에서 하나의 구역을 나타내는 [NIndoorZone]의 구성요소입니다.
class NIndoorLevel {
  final String name;
  @override
  final int hashCode;

  NIndoorLevel._(this.name, this.hashCode);

  factory NIndoorLevel._fromMessageable(dynamic m) =>
      NIndoorLevel._(m["name"], m["hashCode"]);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is NIndoorLevel &&
            runtimeType == other.runtimeType &&
            hashCode == other.hashCode;
  }

  @override
  String toString() {
    return "IndoorLevel{name: $name}";
  }
}

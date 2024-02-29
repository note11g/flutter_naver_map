part of "../../../../flutter_naver_map.dart";

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

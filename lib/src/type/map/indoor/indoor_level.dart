part of flutter_naver_map;

class NIndoorLevel {
  final String name;
  @override
  final int hashCode;

  NIndoorLevel._(this.name, this.hashCode);

  factory NIndoorLevel._fromJson(dynamic json) =>
      NIndoorLevel._(json["name"], json["hashCode"]);

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

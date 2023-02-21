part of flutter_naver_map;

class NIndoorZone {
  final String id;
  final int defaultLevelIndex;
  final List<NIndoorLevel> levels;

  NIndoorLevel get defaultLevel => levels[defaultLevelIndex];

  NIndoorZone._(this.id, this.defaultLevelIndex, this.levels);

  factory NIndoorZone._fromMessageable(dynamic m) {
    final listWithRawLevel = m["levels"] as List;
    final levels = listWithRawLevel
        .map((rawLevel) => NIndoorLevel._fromMessageable(rawLevel));
    return NIndoorZone._(
        m["id"], m["defaultLevelIndex"] as int, levels.toList());
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NIndoorZone &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => """IndoorZone{
    id: $id,
    defaultLevelIndex: $defaultLevelIndex,
    levels: $levels
}""";
}

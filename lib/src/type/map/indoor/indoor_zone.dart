part of "../../../../flutter_naver_map.dart";

/// 실내 지도에서 하나의 구역을 나타내는 객체입니다.
///
/// 실내 지도가 존재하는 영역을 나타내는 [NIndoorRegion]의 구성요소입니다.
/// (여러개의 구역 = 하나의 영역)
class NIndoorZone {
  /// 구역마다 존재하는 고유의 ID입니다.
  final String id;

  /// 기본으로 선택되는 구역의 층 인덱스를 나타냅니다.
  final int defaultLevelIndex;

  /// 구역의 층들을 나타냅니다.
  final List<NIndoorLevel> levels;

  /// 기본으로 선택되는 구역을 나타냅니다.
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

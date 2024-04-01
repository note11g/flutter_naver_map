part of "../../../../flutter_naver_map.dart";

/// 하나의 실내 지도의 영역에서 선택된 구역, 층을 나타내는 객체입니다.
///
/// [NaverMap.onSelectedIndoorChanged]에서 사용됩니다.
class NSelectedIndoor {
  final int levelIndex;
  final int zoneIndex;

  /// 현재 보이는 실내 지도 영역입니다.
  final NIndoorRegion region;

  /// 현재 보이는 층입니다.
  NIndoorLevel get level => zone.levels[levelIndex];

  /// 현재 보이는 구역입니다.
  NIndoorZone get zone => region.zones[zoneIndex];

  NSelectedIndoor._(this.levelIndex, this.zoneIndex, this.region);

  factory NSelectedIndoor._fromMessageable(dynamic m) {
    return NSelectedIndoor._(
      m["levelIndex"] as int,
      m["zoneIndex"] as int,
      NIndoorRegion._fromMessageable(m["region"]),
    );
  }

  @override
  String toString() => """SelectedIndoor{
    levelIndex: $levelIndex,
    zoneIndex: $zoneIndex,
    region: $region
}""";
}

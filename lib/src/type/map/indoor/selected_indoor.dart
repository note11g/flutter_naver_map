part of flutter_naver_map;

class NSelectedIndoor {
  final int levelIndex;
  final int zoneIndex;
  final NIndoorRegion region;

  NIndoorLevel get level => zone.levels[levelIndex];

  NIndoorZone get zone => region.zones[zoneIndex];

  NSelectedIndoor._(this.levelIndex, this.zoneIndex, this.region);

  factory NSelectedIndoor._fromJson(dynamic json) {
    return NSelectedIndoor._(
      json["levelIndex"] as int,
      json["zoneIndex"] as int,
      NIndoorRegion._fromJson(json["region"]),
    );
  }

  @override
  String toString() => """SelectedIndoor{
    levelIndex: $levelIndex,
    zoneIndex: $zoneIndex,
    region: $region
}""";
}

part of "../../../../flutter_naver_map.dart";

/// 실내 지도가 존재하는 영역을 나타내는 객체입니다.
///
/// 여러 개의 구역([NIndoorZone])으로 구성되어 있습니다.
class NIndoorRegion {
  final List<NIndoorZone> zones;

  NIndoorRegion._(this.zones);

  factory NIndoorRegion._fromMessageable(dynamic m) {
    final listWithRawZone = m["zones"] as List;
    final zones =
        listWithRawZone.map((rawZone) => NIndoorZone._fromMessageable(rawZone));
    return NIndoorRegion._(zones.toList());
  }

  /// 이 실내 지도 영역에서 구역ID([zoneId])와 일치하는 id를 가진 구역([NIndoorZone])을 반환합니다.
  /// 일치하는 id를 가진 구역이 없다면, `null`을 반환합니다.
  NIndoorZone? getZone(String zoneId) {
    final filteredZone = zones.where((zone) => zone.id == zoneId);
    return filteredZone.isNotEmpty ? filteredZone.first : null;
  }

  /// 이 실내 지도 영역에서 구역ID([zoneId])와 일치하는 id를 가진 구역([NIndoorZone])의 인덱스를 반환합니다.
  /// 일치하는 id를 가진 구역이 없다면, `-1`을 반환합니다.
  int getZoneIndex(String zoneId) {
    final zone = getZone(zoneId);
    return zone != null ? zones.indexOf(zone) : -1;
  }

  @override
  String toString() {
    return "IndoorRegion{zones: $zones}";
  }
}

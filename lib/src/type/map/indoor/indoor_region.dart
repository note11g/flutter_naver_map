part of "../../../../flutter_naver_map.dart";

class NIndoorRegion {
  final List<NIndoorZone> zones;

  NIndoorRegion._(this.zones);

  factory NIndoorRegion._fromMessageable(dynamic m) {
    final listWithRawZone = m["zones"] as List;
    final zones =
        listWithRawZone.map((rawZone) => NIndoorZone._fromMessageable(rawZone));
    return NIndoorRegion._(zones.toList());
  }

  NIndoorZone? getZone(String zoneId) {
    final filteredZone = zones.where((zone) => zone.id == zoneId);
    return filteredZone.isNotEmpty ? filteredZone.first : null;
  }

  int getZoneIndex(String zoneId) {
    final zone = getZone(zoneId);
    return zone != null ? zones.indexOf(zone) : -1;
  }

  @override
  String toString() {
    return "IndoorRegion{zones: $zones}";
  }
}

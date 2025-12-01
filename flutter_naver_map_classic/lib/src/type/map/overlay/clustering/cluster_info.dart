part of "../../../../../flutter_naver_map.dart";

class NClusterInfo {
  final String _id;
  final NLatLng position;
  final List<NClusterableMarkerInfo> children;
  final int size;

  NClusterInfo._({
    required String id,
    required this.children,
    required this.position,
    required this.size,
  }) : _id = id;

  factory NClusterInfo._fromMessageable(Map message) {
    return NClusterInfo._(
      id: message["id"],
      children: (message["children"] as List)
          .cast<Map>()
          .map((e) => NClusterableMarkerInfo._fromMessageable(e))
          .toList(),
      position: NLatLng.fromMessageable(message["position"]),
      size: message["clusterSize"],
    );
  }

// bool get mergedByTag => mergedTag != null;
//
// /*mergedTag == null;*/
// bool get mergedByDistance => throw UnimplementedError(); // todo: when merged impl
//
// // from Native Data (now property)
// String? get mergedTag => throw UnimplementedError();

  @override
  String toString() {
    return "NClusterInfo(id: $_id, position: $position, size: $size)";
  }
}

class NClusterableMarkerInfo extends NOverlayInfo {
  final Map<String, String> tags;
  final NLatLng position;

  const NClusterableMarkerInfo({
    required super.id,
    required this.tags,
    required this.position,
  }) : super(type: NOverlayType.clusterableMarker);

  factory NClusterableMarkerInfo._fromMessageable(Map message) {
    final info = NOverlayInfo._fromMessageable(message);
    return NClusterableMarkerInfo(
      id: info.id,
      tags: (message["tags"] as Map).cast<String, String>(),
      position: NLatLng.fromMessageable(message["position"]),
    );
  }

  @override
  NPayload toNPayload() {
    return super.toNPayload().expandWith({
      "tags": tags,
      "position": position,
    });
  }

  @override
  String toString() {
    return "${super.toString()} (position: $position, tags: $tags)";
  }
}

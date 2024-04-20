part of "../../../../../flutter_naver_map.dart";

class NClusterInfo {
  final List<NClusterableMarkerInfo> children;

  int get size => children.length;

  NClusterInfo._({required this.children});

  // factory constructor fromMessageable

  bool get mergedByTag => mergedTag != null;

  /*mergedTag == null;*/
  bool get mergedByDistance => throw UnimplementedError();

  // from Native Data (now property)
  String? get mergedTag => throw UnimplementedError();
}

class NClusterableMarkerInfo extends NOverlayInfo {
  final Map<String, String> tags;

  const NClusterableMarkerInfo({
    required super.id,
    required this.tags,
  }) : super(type: NOverlayType.clusterableMarker);

  @override
  NPayload toNPayload() {
    return super.toNPayload().expandWith({
      "tags": tags,
    });
  }
}

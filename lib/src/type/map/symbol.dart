part of flutter_naver_map;

class NSymbol implements Pickable {
  final String caption;
  final NLatLng position;
  @override
  final int hashCode;

  NSymbol._(
    this.caption,
    this.position,
    this.hashCode,
  );

  factory NSymbol._fromJson(dynamic map) => NSymbol._(
        map["caption"].toString(),
        NLatLng._fromJson(map["position"]),
        map["hashCode"],
      );

  @override
  String toString() =>
      "Symbol{caption: $caption, position: $position, hashCode: $hashCode}";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NSymbol &&
          runtimeType == other.runtimeType &&
          caption == other.caption &&
          position == other.position &&
          hashCode == other.hashCode;
}

part of flutter_naver_map;

class NOverlayInfo with NMessageableWithMap implements NPickableInfo {
  final NOverlayType type;

  final String id;

  /* ----- Constructor ----- */

  const NOverlayInfo({required this.type, required this.id});

  /* ----- NMessageable ----- */

  factory NOverlayInfo._fromMessageable(dynamic m) => NOverlayInfo(
      type: NOverlayType._fromMessageable(m["type"]), id: m["id"]);

  @override
  NPayload toNPayload() => NPayload.make({"type": type, "id": id});

  /* ----- Default Override ----- */

  @override
  String toString() => "NOverlayInfo(type: $type, id: $id)";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NOverlayInfo &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          id == other.id;

  @override
  int get hashCode => type.hashCode ^ id.hashCode;
}

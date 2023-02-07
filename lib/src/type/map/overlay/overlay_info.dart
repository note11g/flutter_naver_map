part of flutter_naver_map;

@visibleForTesting
class NOverlayInfo implements NMessageable {
  final NOverlayType type;

  final String id;

  final String? method;

  /* ----- Constructor ----- */

  NOverlayInfo._({required this.type, required this.id})
      : method = null,
        assert(!id.contains("\""));

  const NOverlayInfo._withMethod(
      {required this.type, required this.id, required this.method});

  /* ----- toMessageable ----- */

  String get _overlayKey => [type, id].join(_separateString);

  String toQueryString({String? injectMethod}) =>
      [_overlayKey, injectMethod ?? method!].join(_separateString);

  @override
  NPayload toNPayload() => NPayload.make({"type": type, "id": id});

  /* ----- fromMessageable ----- */

  factory NOverlayInfo._fromMessageable(dynamic m) => NOverlayInfo._(
      type: NOverlayType._fromMessageable(m["type"]), id: m["id"]);

  factory NOverlayInfo._fromString(String query) {
    final params = query.split(_separateString);
    return NOverlayInfo._withMethod(
        type: NOverlayType._fromMessageable(params[0]),
        id: params[1],
        method: (params.length > 2) ? params[2] : null);
  }

  /* ----- Override ----- */

  @override
  String toString() =>
      "OverlayInfo(type: $type, id: $id${method != null ? ", method: $method" : ""})";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NOverlayInfo &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          id == other.id;

  @override
  int get hashCode => type.hashCode ^ id.hashCode;

  /* ----- Constants ----- */

  static const _separateString = "\"";
}

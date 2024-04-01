part of "../../../../flutter_naver_map.dart";

class _NOverlayQuery {
  final NOverlayInfo info;
  final String methodName;

  _NOverlayQuery(this.info, {required this.methodName});

  factory _NOverlayQuery.fromQuery(String query) => _decode(query);

  String get query => _encode();

  // ----- Encode / Decode -----

  String _encode() => [info.type.payload, info.id, methodName].join(_separator);

  static _NOverlayQuery _decode(String string) {
    final split = string.split(_separator);
    final type = split.first;
    final method = split.last;
    final id = split.sublist(1, split.length - 1).join(_separator);
    return _NOverlayQuery(
        NOverlayInfo(type: NOverlayType._fromMessageable(type), id: id),
        methodName: method);
  }

  static const _separator = "\"";
}

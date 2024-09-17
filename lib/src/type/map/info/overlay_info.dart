part of "../../../../flutter_naver_map.dart";

/// 오버레이의 정보를 나타내는 객체입니다.
///
/// 식별자인 [id]와 오버레이의 종류를 나타내는 값인 [type]으로 구성되어 있습니다.
///
/// type과 id로 고유하게 나타낼 수 있습니다. (id가 같아도, type이 다르면 다른 오버레이로 판별합니다)
class NOverlayInfo with NMessageableWithMap implements NPickableInfo {
  /// 오버레이의 종류
  final NOverlayType type;

  /// 타입별 오버레이 식별자 (id가 같아도, type이 다르면 다른 오버레이로 판별합니다)
  final String id;

  /* ----- Constructor ----- */

  const NOverlayInfo({required this.type, required this.id});

  /* ----- NMessageable ----- */

  factory NOverlayInfo._fromMessageable(dynamic m) =>
      NOverlayInfo(type: NOverlayType._fromMessageable(m["type"]), id: m["id"]);

  @override
  NPayload toNPayload() => NPayload.make({"type": type, "id": id});

  /* ----- Default Override ----- */

  @override
  String toString() => "NOverlayInfo(type: $type, id: $id)";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NOverlayInfo &&
          // runtimeType check pass (subclasses support needed)
          type == other.type &&
          id == other.id;

  @override
  int get hashCode => type.hashCode ^ id.hashCode;
}

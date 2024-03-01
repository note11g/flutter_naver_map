part of flutter_naver_map;

/// [NaverMapController.pickAll]을 통해서 가져올 수 있는 요소들을 나타냅니다.
///
/// 심볼의 정보를 나타내는 [NSymbolInfo]와 오버레이의 정보를 나타내는 [NOverlayInfo]가 구현체로 존재합니다.
// TODO : Migrate to Sealed Class
abstract class NPickableInfo {
  static NPickableInfo _fromMessageable(dynamic m) {
    final signature = m["signature"] as String;
    if (signature == "symbol") {
      return NSymbolInfo._fromMessageable(m);
    } else if (signature == "overlay") {
      return NOverlayInfo._fromMessageable(m);
    } else {
      throw NUnknownTypeCastException(unknownValue: m);
    }
  }
}

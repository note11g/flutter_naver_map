part of "../../../../flutter_naver_map.dart";

/// [NaverMapController.pickAll]을 통해서 가져올 수 있는 요소들을 나타냅니다.
///
/// 심볼의 정보를 나타내는 [NSymbolInfo]와 오버레이의 정보를 나타내는 [NOverlayInfo]가 구현체로 존재합니다.
sealed class NPickableInfo {
  static NPickableInfo _fromMessageable(dynamic m) {
    final signature = m["signature"] as String;
    return switch (signature) {
      "symbol" => NSymbolInfo._fromMessageable(m),
      "overlay" => NOverlayInfo._fromMessageable(m),
      _ => throw NUnknownTypeCastException(unknownValue: m),
    };
  }
}

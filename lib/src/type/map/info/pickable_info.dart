part of flutter_naver_map;

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

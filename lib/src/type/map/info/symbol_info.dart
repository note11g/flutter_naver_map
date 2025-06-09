part of "../../../../flutter_naver_map.dart";

/// 심볼의 정보를 나타내는 객체입니다.
class NSymbolInfo implements NPickableInfo {
  final String caption;
  final NLatLng position;

  NSymbolInfo._(this.caption, this.position);

  factory NSymbolInfo._fromMessageable(dynamic map) => NSymbolInfo._(
        map["caption"]!.toString(),
        NLatLng.fromMessageable(map["position"]!),
      );
}

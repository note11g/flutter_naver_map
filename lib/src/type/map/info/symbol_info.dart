part of "../../../../flutter_naver_map.dart";

class NSymbolInfo implements NPickableInfo {
  final String caption;
  final NLatLng position;

  NSymbolInfo._(this.caption, this.position);

  factory NSymbolInfo._fromMessageable(dynamic map) => NSymbolInfo._(
        map["caption"]!.toString(),
        NLatLng._fromMessageable(map["position"]!),
      );
}

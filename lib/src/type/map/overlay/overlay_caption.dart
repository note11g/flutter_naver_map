part of flutter_naver_map;

class NOverlayCaption with NMessageableWithMap {
  final String text;

  final double textSize;

  final Color color;

  final Color haloColor;

  final double minZoom;

  final double maxZoom;

  final double requestWidth;

  const NOverlayCaption({
    required this.text,
    this.textSize = 12.0,
    this.color = Colors.black,
    this.haloColor = Colors.white,
    this.minZoom = NaverMapViewOptions.minimumZoom,
    this.maxZoom = NaverMapViewOptions.maximumZoom,
    this.requestWidth = 0,
  });

  @override
  NPayload toNPayload() => NPayload.make({
        "text": text,
        "textSize": textSize,
        "color": color,
        "haloColor": haloColor,
        "minZoom": minZoom,
        "maxZoom": maxZoom,
        "requestWidth": requestWidth,
      });
}

part of flutter_naver_map;

class NOverlayCaption implements NMessageable {
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

  factory NOverlayCaption._fromJson(dynamic json) => NOverlayCaption(
      text: json["text"],
      textSize: json["textSize"],
      color: Color(json["color"]),
      haloColor: Color(json["haloColor"]),
      minZoom: json["minZoom"],
      maxZoom: json["maxZoom"],
      requestWidth: json["requestWidth"],
    );

  @override
  NPayload toNPayload() => NPayload.make({
        "text": text,
        "textSize": textSize,
        "color": color.value,
        "haloColor": haloColor.value,
        "minZoom": minZoom,
        "maxZoom": maxZoom,
        "requestWidth": requestWidth,
      });
}

part of flutter_naver_map;

class NMultipartPath implements NMessageable {
  final List<NLatLng> coords;
  final Color color;
  final Color outlineColor;
  final Color passedColor;
  final Color passedOutlineColor;

  const NMultipartPath({
    required this.coords,
    this.color = Colors.white,
    this.outlineColor = Colors.black,
    this.passedColor = Colors.white,
    this.passedOutlineColor = Colors.black,
  });

  factory NMultipartPath._fromJson(dynamic json) => NMultipartPath(
        coords: (json["coords"] as List).map(NLatLng._fromJson).toList(),
        color: Color(json["color"]!),
        outlineColor: Color(json["outlineColor"]!),
        passedColor: Color(json["passedColor"]!),
        passedOutlineColor: Color(json["passedOutlineColor"]!),
      );

  static List<NMultipartPath> _fromJsonList(dynamic json) =>
      (json as List).map(NMultipartPath._fromJson).toList();

  @override
  NPayload toNPayload() => NPayload.make({
        "coords": coords,
        "color": color.value,
        "outlineColor": outlineColor.value,
        "passedColor": passedColor.value,
        "passedOutlineColor": passedOutlineColor.value,
      });
}

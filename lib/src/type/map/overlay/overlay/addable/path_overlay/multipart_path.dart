part of flutter_naver_map;

class NMultipartPath with NMessageableWithMap {
  final Iterable<NLatLng> coords;
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

  factory NMultipartPath._fromMessageable(dynamic m) => NMultipartPath(
        coords: (m["coords"] as List).map(NLatLng._fromMessageable),
        color: Color(m["color"]!),
        outlineColor: Color(m["outlineColor"]!),
        passedColor: Color(m["passedColor"]!),
        passedOutlineColor: Color(m["passedOutlineColor"]!),
      );

  static Iterable<NMultipartPath> _fromMessageableIterable(dynamic m) =>
      (m as List).map(NMultipartPath._fromMessageable);

  @override
  NPayload toNPayload() => NPayload.make({
        "coords": coords,
        "color": color,
        "outlineColor": outlineColor,
        "passedColor": passedColor,
        "passedOutlineColor": passedOutlineColor,
      });
}

part of "../../../../../../../flutter_naver_map.dart";

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

  @override
  NPayload toNPayload() => NPayload.make({
        "coords": coords,
        "color": color,
        "outlineColor": outlineColor,
        "passedColor": passedColor,
        "passedOutlineColor": passedOutlineColor,
      });
}

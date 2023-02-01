part of flutter_naver_map;

class NSize extends Size implements NMessageable {
  const NSize(super.width, super.height);
  NSize.fromSize(Size size) : this(size.width, size.height);

  @override
  NPayload toNPayload() => NPayload.make({"width": width, "height": height});

  factory NSize._fromJson(dynamic json) => NSize(json["width"], json["height"]);

  @override
  String toString() => "NSize(w: $width, h: $height)";
}

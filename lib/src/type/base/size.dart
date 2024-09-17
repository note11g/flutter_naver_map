part of "../../../flutter_naver_map.dart";

class NSize extends Size with NMessageableWithMap {
  const NSize(super.width, super.height);

  NSize.fromSize(Size size) : this(size.width, size.height);

  @override
  NPayload toNPayload() => NPayload.make({"width": width, "height": height});

  // factory NSize._fromMessageable(dynamic m) => NSize(m["width"], m["height"]);

  @override
  String toString() => "NSize(w: $width, h: $height)";
}

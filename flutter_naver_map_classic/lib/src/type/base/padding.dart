part of "../../../flutter_naver_map.dart";

class NEdgeInsets extends EdgeInsets with NMessageableWithMap {
  const NEdgeInsets.fromLTRB(super.left, super.top, super.right, super.bottom)
      : super.fromLTRB();

  NEdgeInsets.fromEdgeInsets(EdgeInsets insets)
      : super.fromLTRB(insets.left, insets.top, insets.right, insets.bottom);

  @override
  NPayload toNPayload() => NPayload.make({
        "left": left,
        "top": top,
        "right": right,
        "bottom": bottom,
      });
}

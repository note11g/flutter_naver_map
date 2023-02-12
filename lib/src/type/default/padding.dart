part of flutter_naver_map;

class NEdgeInsets extends EdgeInsets with NMessageableWithMap {
  const NEdgeInsets.fromLTRB(
      double left, double top, double right, double bottom)
      : super.fromLTRB(left, top, right, bottom);

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

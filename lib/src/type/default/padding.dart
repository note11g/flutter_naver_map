part of flutter_naver_map;

class NEdgeInsets extends EdgeInsets implements NMessageable {
  const NEdgeInsets.symmetric({double vertical = 0, double horizontal = 0})
      : super.symmetric(vertical: vertical, horizontal: horizontal);

  const NEdgeInsets.all(double value) : super.all(value);

  const NEdgeInsets.only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) : super.only(left: left, top: top, right: right, bottom: bottom);

  const NEdgeInsets.fromLTRB(
      double left, double top, double right, double bottom)
      : super.fromLTRB(left, top, right, bottom);

  NEdgeInsets.fromEdgeInsets(EdgeInsets insets)
      : super.fromLTRB(insets.left, insets.top, insets.right, insets.bottom);

  static const NEdgeInsets zero = NEdgeInsets.only();

  @override
  NPayload toNPayload() => NPayload.make({
        "left": left,
        "top": top,
        "right": right,
        "bottom": bottom,
      });
}

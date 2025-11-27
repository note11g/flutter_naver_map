import "dart:ui";
import "package:meta/meta.dart";

@internal
extension OffsetExtension on Offset {
  Offset move({double x = 0, double y = 0}) {
    return Offset(dx + x, dy + y);
  }
}
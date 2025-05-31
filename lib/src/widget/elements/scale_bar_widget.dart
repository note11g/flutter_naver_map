import "package:flutter/material.dart";
import "package:flutter/services.dart";

class ScaleBarWidget extends StatelessWidget {
  final int currentMeter;
  final int barWidth; // 40~80dp

  const ScaleBarWidget({
    super.key,
    required this.currentMeter,
    required this.barWidth,
  });

  static Future<void> prepareFont() => _ScaleBarFontLoader.init();

  static const _textStyle = TextStyle(
      fontFamilyFallback: [],
      fontFamily: _ScaleBarFontLoader.fontFamily,
      fontSize: 9,
      fontWeight: FontWeight.w500,
      letterSpacing: 9 * 0.02,
      height: 1,
      color: Colors.black);

  static const _scaleBarInnerPadding = EdgeInsets.only(left: 3, right: 11);

  @override
  Widget build(BuildContext context) {
    _ScaleBarFontLoader.init();
    return Container(
        margin: const EdgeInsets.only(bottom: 32),
        child: SizedBox(
            width: barWidth + _scaleBarInnerPadding.horizontal,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(children: [
                    const Text("0", style: _textStyle),
                    const Spacer(),
                    Text(
                        currentMeter >= 1000
                            ? "${currentMeter ~/ 1000}km"
                            : "${currentMeter}m",
                        textAlign: TextAlign.right,
                        style: _textStyle),
                  ]),
                  const SizedBox(height: 1),
                  const Padding(
                      padding: _scaleBarInnerPadding,
                      child: CustomPaint(painter: _ScaleBarPainter())),
                ])));
  }
}

class _ScaleBarPainter extends CustomPainter {
  // final double width;
  final double barHeight;

  const _ScaleBarPainter({
    this.barHeight = 4.0,
  });

  static const barColor = Color(0xFF444444);

  static const barBorderColor = Color(0x80FFFFFF);

  @override
  void paint(Canvas canvas, Size size) {
    const double borderThickness = 1.0; // 테두리 두께 1dp
    const double barThickness = 1.0; // 내부 막대 두께 1dp
    final double barWidth = size.width; // 막대 길이

    final Paint barPaint = Paint()
      ..color = barColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = barThickness
      ..strokeCap = StrokeCap.square;

    final Paint borderAsBackgroundPaint = Paint()
      ..color = barBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = (borderThickness * 2 + barThickness)
      ..strokeCap = StrokeCap.square;

    final Path barPath = Path()
      ..lineTo(0, barHeight)
      ..lineTo(barWidth, barHeight)
      ..lineTo(barWidth, 0);

    final Path borderPath = Path()
      ..lineTo(0, barHeight)
      ..lineTo(barWidth, barHeight)
      ..lineTo(barWidth, 0);

    canvas.drawPath(borderPath, borderAsBackgroundPaint);
    canvas.drawPath(barPath, barPaint);
  }

  @override
  bool shouldRepaint(covariant _ScaleBarPainter oldPainter) {
    return oldPainter.barHeight != barHeight;
  }
}

abstract class _ScaleBarFontLoader {
  static const fontFamily = "FNMScaleBar";

  static bool _isLoaded = false;

  static Future<void> init() async {
    if (_isLoaded) return;
    final loader = FontLoader(fontFamily);
    loader.addFont(rootBundle.load(
        "packages/flutter_naver_map/assets/font/Inter-fnm-scalebar-ss540.otf"));
    await loader.load();
    print("ScaleBarFontLoader.init: done");
    _isLoaded = true;
  }
}

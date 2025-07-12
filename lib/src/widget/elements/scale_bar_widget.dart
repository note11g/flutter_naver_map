part of "../../../flutter_naver_map.dart";

class NMapScaleBarWidget extends StatelessWidget {
  final NaverMapController? naverMapController;
  final NCameraPosition? initCameraPosition;

  const NMapScaleBarWidget(
      {super.key, this.naverMapController, this.initCameraPosition});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: naverMapController?._nowCameraPositionStream,
        builder: (context, snapshot) {
          final cameraPosition = snapshot.data?.position ?? initCameraPosition;
          if (cameraPosition == null) return const SizedBox.shrink();
          return ScaleBarWidget.fromMeterPerDp(MathUtil.calcMeterPerDp(
              cameraPosition.target.latitude, cameraPosition.zoom));
        });
  }
}

class ScaleBarWidget extends StatelessWidget {
  final int currentMeter;
  final double barWidth;

  const ScaleBarWidget({
    super.key,
    required this.currentMeter,
    required this.barWidth,
  });

  factory ScaleBarWidget.fromMeterPerDp(double meterPerDp) {
    final currentStep = _findCurrentStep(meterPerDp);
    return ScaleBarWidget(
        currentMeter: currentStep, barWidth: currentStep / meterPerDp);
  }

  static int _findCurrentStep(double meterPerDp) {
    final maxDisplayMeter = meterPerDp * _maxWidth;
    for (final meterScale in _meterScaleSteps.reversed) {
      if (meterScale <= maxDisplayMeter) return meterScale;
    }
    return _meterScaleSteps.first;
  }

  static const _maxWidth = 80.0;

  // @formatter:off
  static const _meterScaleSteps = [2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000, 200000, 500000, 1000000, 2000000, 5000000];
  // @formatter:on

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
    return SizedBox(
        width: barWidth + _scaleBarInnerPadding.horizontal,
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            const Text("0", style: _textStyle),
            Expanded(
                child: Text(
                    currentMeter >= 1000
                        ? "${currentMeter ~/ 1000}km"
                        : "${currentMeter}m",
                    textAlign: TextAlign.right,
                    style: _textStyle)),
          ]),
          const SizedBox(height: 1),
          const Padding(
              padding: _scaleBarInnerPadding,
              child: CustomPaint(painter: _ScaleBarPainter())),
        ]));
  }
}

class _ScaleBarPainter extends CustomPainter {
  final double barHeight;

  const _ScaleBarPainter({
    this.barHeight = 4.0,
  });

  static const barColor = Color(0xFF444444);
  static const barBorderColor = Color(0x80FFFFFF);

  @override
  void paint(Canvas canvas, Size size) {
    const double borderThickness = 1.0;
    const double barThickness = 1.0;
    final double barWidth = size.width;

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
  static bool _tryLoad = false;

  static Future<void> init() async {
    if (_tryLoad) return;
    final loader = FontLoader(fontFamily);
    loader.addFont(rootBundle.load(
        "packages/flutter_naver_map/assets/font/Inter-fnm-scalebar-ss540.otf"));
    _tryLoad = true;
    await loader.load();
  }
}

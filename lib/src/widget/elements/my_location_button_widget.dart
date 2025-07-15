part of "../../../flutter_naver_map.dart";

/// 내 위치 추적 모드(`NLocationTrackingMode`)를 컨트롤할 수 있는 버튼 위젯입니다.
class NMyLocationButtonWidget extends StatelessWidget {
  final NaverMapController? mapController;
  final bool nightMode;
  final BorderRadius borderRadius;
  final double elevation;
  final double size;

  const NMyLocationButtonWidget({
    super.key,
    required this.mapController,
    this.borderRadius = const BorderRadius.all(Radius.circular(2)),
    this.elevation = 1,
    this.size = 44,
    this.nightMode = false,
  });

  Color get buttonColor => nightMode ? Colors.grey.shade900 : Colors.white;

  Color get inactiveIconColor =>
      nightMode ? Colors.grey.shade200 : const Color(0xFF575757);

  static const Color activeIconColor = Color(0xFF0086FF);

  static const _baseIconSize = Size(21, 21);

  @override
  Widget build(BuildContext context) {
    final stream = mapController?._locationTrackingModeStream;
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          final mode = snapshot.data ?? NLocationTrackingMode.none;
          return _button(
              onTap: () => onTap(mode),
              child: Stack(children: [
                Positioned.fill(
                    child: Center(
                        child: CustomPaint(
                            size: _baseIconSize,
                            foregroundPainter:
                                mode == NLocationTrackingMode.face
                                    ? const _MyLocationFaceIconPainter()
                                    : null,
                            painter: switch (mode) {
                              NLocationTrackingMode.none =>
                                _MyLocationDefaultIconPainter(
                                    color: inactiveIconColor),
                              NLocationTrackingMode m =>
                                _MyLocationDefaultIconPainter(
                                    color: activeIconColor,
                                    isFace: m == NLocationTrackingMode.face),
                            }))),
                if (mode == NLocationTrackingMode.follow)
                  Positioned.fill(
                      bottom: _baseIconSize.height,
                      child: Center(
                          child: SizedBox.fromSize(
                              size: const Size(12, 12),
                              child: Image.asset(
                                  NLocationOverlay.defaultSubIcon._path,
                                  color: activeIconColor)))),
                if (mapController?.myLocationTracker
                    case NMyLocationTracker(:final isLoading))
                  Positioned.fill(
                      child: ValueListenableBuilder(
                          valueListenable: isLoading,
                          builder: (context, isLoading, child) =>
                              Offstage(offstage: !isLoading, child: child!),
                          child: _progressIndicator())),
              ]));
        });
  }

  Widget _button({required VoidCallback onTap, required Widget child}) {
    return Builder(builder: (context) {
      return SizedBox(
          width: size,
          height: size,
          child: Material(
              clipBehavior: Clip.hardEdge,
              borderRadius: borderRadius,
              color: buttonColor,
              elevation: elevation,
              child: InkWell(onTap: onTap, child: child)));
    });
  }

  Widget _progressIndicator() {
    return const Padding(
        padding: EdgeInsets.all(4),
        child:
            CircularProgressIndicator(color: activeIconColor, strokeWidth: 1));
  }

  void onTap(NLocationTrackingMode mode) {
    final nextMode = switch (mode) {
      NLocationTrackingMode.face => NLocationTrackingMode.none,
      NLocationTrackingMode.follow => NLocationTrackingMode.face,
      NLocationTrackingMode.noFollow ||
      NLocationTrackingMode.none =>
        NLocationTrackingMode.follow,
    };
    mapController?.setLocationTrackingMode(nextMode);
  }
}

class _MyLocationDefaultIconPainter extends CustomPainter {
  final Color color;
  final bool isFace;

  _MyLocationDefaultIconPainter({required this.color, this.isFace = false});

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 1.2;
    const pointDotRadius = 2.64;
    const tickLengthRatio = 0.4;

    final Paint strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double innerRadius =
        math.min(size.width, size.height) / 2 - strokePaint.strokeWidth / 2;

    if (!isFace) {
      canvas.drawCircle(center, innerRadius, strokePaint);
    } else {
      final Rect rect = Rect.fromCircle(center: center, radius: innerRadius);
      const fullRad = (2 * math.pi);
      const double startAngle = fullRad * (-0.25 / 2);
      const double sweepAngle = fullRad * 0.75;
      canvas.drawArc(rect, startAngle, sweepAngle, false, strokePaint);
    }

    final double tickLength = innerRadius * tickLengthRatio;
    for (final axis in AxisDirection.values) {
      if (isFace && axis == AxisDirection.up) continue;
      drawTick(canvas, axis, tickLength, innerRadius, size, strokePaint);
    }

    final Paint fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawCircle(center, pointDotRadius / 2, fillPaint);
  }

  void drawTick(Canvas canvas, AxisDirection direction, double tickLength,
      double innerRadius, Size size, Paint paint) {
    final center = Offset(size.width / 2, size.height / 2);

    final (start, end) = switch (direction) {
      AxisDirection.up => (
          center.move(y: -innerRadius),
          center.move(y: -innerRadius + tickLength)
        ),
      AxisDirection.down => (
          center.move(y: innerRadius),
          center.move(y: innerRadius - tickLength)
        ),
      AxisDirection.left => (
          center.move(x: -innerRadius),
          center.move(x: -innerRadius + tickLength)
        ),
      AxisDirection.right => (
          center.move(x: innerRadius),
          center.move(x: innerRadius - tickLength)
        ),
    };

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _MyLocationFaceIconPainter extends CustomPainter {
  static const double _viewBox = 20.0;

  const _MyLocationFaceIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Float64List matrix = Matrix4.diagonal3Values(
            size.width / _viewBox, size.height / _viewBox, 1)
        .storage;

    final Path face = Path()
      ..moveTo(8.06752, 7.75)
      ..lineTo(3.24609, -0.5375)
      ..cubicTo(8.51817, -2.4875, 11.474, -2.4875, 16.7461, -0.5375)
      ..lineTo(11.9247, 7.75)
      ..cubicTo(10.4184, 7.01875, 9.57383, 7.01875, 8.06752, 7.75)
      ..close();

    final Path highlight = Path()
      ..moveTo(3.29616, -0.451039)
      ..cubicTo(3.26839, -0.498776, 3.20718, -0.514962, 3.15944, -0.487189)
      ..lineTo(3.11622, -0.462046)
      ..cubicTo(3.06848, -0.434274, 3.0523, -0.373061, 3.08007, -0.325323)
      ..lineTo(7.87454, 7.91583)
      ..cubicTo(7.92716, 8.00629, 8.04062, 8.04088, 8.13476, 7.99518)
      ..lineTo(8.17649, 7.97492)
      ..cubicTo(8.91526, 7.61628, 9.46302, 7.45159, 9.99588, 7.45159)
      ..cubicTo(10.5287, 7.45159, 11.0765, 7.61628, 11.8153, 7.97492)
      ..lineTo(11.857, 7.99518)
      ..cubicTo(11.9511, 8.04088, 12.0646, 8.00629, 12.1172, 7.91583)
      ..lineTo(16.9117, -0.325323)
      ..cubicTo(16.9395, -0.373061, 16.9233, -0.434274, 16.8755, -0.462046)
      ..lineTo(16.8323, -0.487189)
      ..cubicTo(16.7846, -0.514962, 16.7234, -0.498777, 16.6956, -0.451039)
      ..lineTo(11.9244, 7.75002)
      ..cubicTo(10.4181, 7.01877, 9.57361, 7.01877, 8.06731, 7.75002)
      ..lineTo(3.29616, -0.451039)
      ..close();

    final Paint bluePaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = const LinearGradient(
        begin: Alignment((9.99609 / _viewBox) * 2 - 1, (-2 / _viewBox) * 2 - 1),
        end: Alignment((10 / _viewBox) * 2 - 1, (8 / _viewBox) * 2 - 1),
        colors: [
          Color(0x000086FF),
          Color(0x310086FF),
          Color(0xFF0670FF),
          Color(0xFF054293),
        ],
        stops: [0.175, 0.425, 0.975, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(face.transform(matrix), bluePaint);

    final Paint highlightPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = const LinearGradient(
        begin: Alignment((10 / _viewBox) * 2 - 1, (0 / _viewBox) * 2 - 1),
        end: Alignment(
            (9.99588 / _viewBox) * 2 - 1, (8.07621 / _viewBox) * 2 - 1),
        colors: [Color(0x000086FF), Color(0xFF0086FF)],
        stops: [0.0, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(highlight.transform(matrix), highlightPaint);
  }

  @override
  bool shouldRepaint(_MyLocationFaceIconPainter oldDelegate) => false;
}

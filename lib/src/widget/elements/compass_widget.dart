part of "../../../flutter_naver_map.dart";

/// 나침반 위젯을 제공합니다.
class NCompassWidget extends StatefulWidget {
  final NaverMapController? naverMapController;
  final NCameraPosition? initCameraPosition;

  /// Custom Widget으로 직접 나침반을 그릴 수 있습니다.
  final Widget? customWidget;
  final double? size;

  /// bearing이 0일때, 나침반 위젯을 숨깁니다.
  final bool hideWhenUnrotated;

  final double elevation;
  final BorderRadius borderRadius;

  const NCompassWidget({
    super.key,
    this.naverMapController,
    this.initCameraPosition,
    this.customWidget,
    this.hideWhenUnrotated = true,
    this.borderRadius = const BorderRadius.all(Radius.circular(99)),
    this.elevation = 1,
    this.size = 44,
  });

  @override
  State<NCompassWidget> createState() => _NCompassWidgetState();
}

class _NCompassWidgetState extends State<NCompassWidget> {
  bool _keepVisibilityUntilIdle = false;

  @override
  Widget build(BuildContext context) {
    final compass = widget.customWidget ?? const DefaultCompassWidget();
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: StreamBuilder(
          stream: widget.naverMapController?.nowCameraPositionStream,
          builder: (context, snapshot) {
            final data = snapshot.data;
            final cameraPosition = data?.position ?? widget.initCameraPosition;
            final bearing = cameraPosition?.bearing ?? 0.0;
            final isRotated = bearing != 0;
            final isIdle = data?.isIdle ?? true;
            final rotatedGesturableWidget = Material(
              clipBehavior: Clip.hardEdge,
              borderRadius: widget.borderRadius,
              elevation: widget.elevation,
              child: Transform.rotate(
                angle: -bearing * math.pi / 180.0,
                child: GestureDetector(
                  onTap: isRotated ? resetBearing : null,
                  child: compass,
                ),
              ),
            );

            if (widget.hideWhenUnrotated) {
              _updateVisibilityFlags(isRotated, isIdle);
              final shouldShow = isRotated || _keepVisibilityUntilIdle;
              return AnimatedOpacity(
                opacity: shouldShow ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 220),
                child: rotatedGesturableWidget,
              );
            } else {
              return rotatedGesturableWidget;
            }
          }),
    );
  }

  void _updateVisibilityFlags(bool isRotated, bool isIdle) {
    if (isRotated && !_keepVisibilityUntilIdle) {
      _scheduleVisibility(true);
    } else if (!isRotated && isIdle && _keepVisibilityUntilIdle) {
      _scheduleVisibility(false);
    }
  }

  void _scheduleVisibility(bool value) {
    if (_keepVisibilityUntilIdle == value) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _keepVisibilityUntilIdle == value) return;
      setState(() => _keepVisibilityUntilIdle = value);
    });
  }

  void resetBearing() {
    final currentBearing = widget.naverMapController?.nowCameraPosition.bearing;
    if (currentBearing == null || currentBearing == 0) return;

    widget.naverMapController?.updateCamera(NCameraUpdate.withParams(bearing: 0)
      ..setAnimation(duration: const Duration(milliseconds: 300))
      ..setReason(NCameraUpdateReason.control));
  }
}

class DefaultCompassWidget extends StatelessWidget {
  const DefaultCompassWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _CompassPainter());
  }
}

class _CompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
  // 기본 로직은 48x48 좌표계를 기준으로 작성되었습니다.
    // 입력된 size에 따라 비율을 유지하며 스케일링됩니다.
    final double scale = size.width / 48.0;
    canvas.scale(scale, scale);

    final Paint paint = Paint()..style = PaintingStyle.fill;
    final Path path = Path();

    // 1. Background Circle (White)
    // 중심: 24, 반지름: 24
    paint.color = Colors.white;
    canvas.drawCircle(const Offset(24, 24), 24, paint);

    // 2. Top Icon 'N' Shape (Dark Grey #444444)
    // 48px 기준으로 변환 시 좌표가 정수로 딱 떨어져 선명하게 보입니다.
    paint.color = const Color(0xFF444444);
    path.reset();
    path.moveTo(21, 8);   // 시작점
    path.lineTo(21, 2.5); 
    path.lineTo(22.5, 2.5);
    path.lineTo(25.5, 5.5);
    path.lineTo(25.5, 2.5);
    path.lineTo(27, 2.5);
    path.lineTo(27, 8);
    path.lineTo(25.5, 8);
    path.lineTo(22.5, 5);
    path.lineTo(22.5, 8);
    path.close();
    canvas.drawPath(path, paint);

    // 3. Small Rectangles Markers (Grey #666666)
    paint.color = const Color(0xFF666666);
    
    // Left (x: ~3.5)
    canvas.drawRect(const Rect.fromLTWH(3.5, 22.7, 2.5, 2.5), paint);
    
    // Right (x: ~42)
    canvas.drawRect(const Rect.fromLTWH(42, 22.7, 2.5, 2.5), paint);
    
    // Bottom (y: ~42)
    canvas.drawRect(const Rect.fromLTWH(22.75, 42, 2.5, 2.5), paint);

    // 4. Inner Ring (Stroke #B6B6B6)
    paint.color = const Color(0xFFB6B6B6);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 0.6; // 두께 조정
    canvas.drawCircle(const Offset(24, 24), 13.9, paint);

    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 0.0;

    // 5. Bottom Needle (Light Grey #C9C9C9)
    paint.color = const Color(0xFFC9C9C9);
    path.reset();
    path.moveTo(23.88, 34.15); // 끝점
    path.lineTo(19.6, 24);     // 왼쪽 날개
    path.lineTo(28.4, 24);     // 오른쪽 날개
    path.lineTo(24.12, 34.15); // 끝점 (대칭)
    // 끝부분 둥글게 처리 (Bezier)
    path.cubicTo(24.08, 34.25, 23.92, 34.25, 23.88, 34.15);
    path.close();
    canvas.drawPath(path, paint);

    // 6. Top Needle (Red #EB2739)
    paint.color = const Color(0xFFEB2739);
    path.reset();
    path.moveTo(23.88, 13.85); // 끝점
    path.lineTo(19.6, 24);     // 왼쪽 날개
    path.lineTo(28.4, 24);     // 오른쪽 날개
    path.lineTo(24.12, 13.85); // 끝점 (대칭)
    // 끝부분 둥글게 처리 (Bezier)
    path.cubicTo(24.08, 13.75, 23.92, 13.75, 23.88, 13.85);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

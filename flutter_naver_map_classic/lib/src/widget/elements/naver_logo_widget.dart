import "package:flutter/material.dart";
import "package:flutter_naver_map/flutter_naver_map.dart";
import "package:flutter_naver_map/src/widget/info/info_dialog.dart";

class NMapLogoWidget extends StatelessWidget {
  final NaverMapController? naverMapController;
  final bool logoClickEnable;

  const NMapLogoWidget({
    super.key,
    required this.naverMapController,
    required this.logoClickEnable,
  });

  static const width = 48.0;
  static const height = 17.0;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(99);
    return DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(color: const Color(0x17000000))),
        child: SizedBox(
            width: width,
            height: height,
            child: Padding(
                padding: const EdgeInsets.all(1),
                child: Material(
                    color: Colors.white,
                    clipBehavior: Clip.hardEdge,
                    borderRadius: borderRadius,
                    child: InkWell(
                        onTap: logoClickEnable
                            ? () => showDialog(
                                context: context,
                                builder: (context) => NMapInfoDialog(
                                    naverMapController: naverMapController))
                            : null,
                        child: Center(child: _naverLogo()))))));
  }

  Widget _naverLogo() {
    return CustomPaint(size: const Size(35, 7.2), painter: _NaverLogoPainter());
  }
}

class _NaverLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const naverGreen = Color(0xFF03CF5D);

    final path_0 = Path()
      ..moveTo(10.0753, 0.5)
      ..lineTo(7.44092, 7.21682)
      ..lineTo(9.67963, 7.21682)
      ..lineTo(9.99801, 6.32751)
      ..lineTo(12.5229, 6.32751)
      ..lineTo(12.8412, 7.21682)
      ..lineTo(15.08, 7.21682)
      ..lineTo(12.4456, 0.5)
      ..lineTo(10.0753, 0.5)
      ..close()
      ..moveTo(10.5098, 4.7148)
      ..lineTo(11.2608, 2.61647)
      ..lineTo(12.0117, 4.7148)
      ..lineTo(10.5098, 4.7148)
      ..close();

    final paint0Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = naverGreen;
    canvas.drawPath(path_0, paint0Fill);

    final path_1 = Path()
      ..moveTo(24.3982, 4.6651)
      ..lineTo(27.4597, 4.6651)
      ..lineTo(27.4597, 3.05172)
      ..lineTo(24.3982, 3.05172)
      ..lineTo(24.3982, 2.14629)
      ..lineTo(27.4927, 2.14629)
      ..lineTo(27.4927, 0.5)
      ..lineTo(22.2576, 0.5)
      ..lineTo(22.2576, 7.21682)
      ..lineTo(27.5585, 7.21682)
      ..lineTo(27.5585, 5.57053)
      ..lineTo(24.3982, 5.57053)
      ..lineTo(24.3982, 4.6651)
      ..close();

    final paint1Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = naverGreen;
    canvas.drawPath(path_1, paint1Fill);

    final path_2 = Path()
      ..moveTo(17.7472, 4.91631)
      ..lineTo(16.1668, 0.5)
      ..lineTo(13.9274, 0.5)
      ..lineTo(16.5617, 7.21682)
      ..lineTo(18.9321, 7.21682)
      ..lineTo(21.5664, 0.5)
      ..lineTo(19.3277, 0.5)
      ..lineTo(17.7472, 4.91631)
      ..close();

    Paint paint2Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = naverGreen;
    canvas.drawPath(path_2, paint2Fill);

    final path_3 = Path()
      ..moveTo(4.57684, 4.09484)
      ..lineTo(2.07415, 0.5)
      ..lineTo(0, 0.5)
      ..lineTo(0, 7.21682)
      ..lineTo(2.17289, 7.21682)
      ..lineTo(2.17289, 3.62198)
      ..lineTo(4.67558, 7.21682)
      ..lineTo(6.74973, 7.21682)
      ..lineTo(6.74973, 0.5)
      ..lineTo(4.57684, 0.5)
      ..lineTo(4.57684, 4.09484)
      ..close();

    final paint3Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = naverGreen;
    canvas.drawPath(path_3, paint3Fill);

    final path_4 = Path()
      ..moveTo(33.302, 4.91222)
      ..lineTo(33.5056, 4.82691)
      ..cubicTo(34.2861, 4.50048, 34.683, 3.7932, 34.683, 2.89583)
      ..cubicTo(34.683, 2.04749, 34.3734, 1.41947, 33.7635, 1.0299)
      ..cubicTo(33.1959, 0.66786, 32.4604, 0.499268, 31.4482, 0.499268)
      ..lineTo(28.613, 0.499268)
      ..lineTo(28.613, 7.21609)
      ..lineTo(30.7201, 7.21609)
      ..lineTo(30.7201, 5.33941)
      ..lineTo(31.4771, 5.33941)
      ..lineTo(32.7613, 7.21609)
      ..lineTo(35.0001, 7.21609)
      ..lineTo(33.302, 4.91155)
      ..lineTo(33.302, 4.91222)
      ..close()
      ..moveTo(31.8391, 3.62796)
      ..lineTo(30.6865, 3.62796)
      ..lineTo(30.6865, 2.21206)
      ..lineTo(31.8391, 2.21206)
      ..cubicTo(32.23, 2.21206, 32.5471, 2.52909, 32.5471, 2.92001)
      ..cubicTo(32.5471, 3.31093, 32.23, 3.62796, 31.8391, 3.62796)
      ..close();

    final paint4Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = naverGreen;

    canvas.drawPath(path_4, paint4Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

import 'package:balloon_widget/balloon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

// import 'package:flutter_naver_map_example/design/custom_widget.dart';
import 'package:flutter_naver_map_example/design/theme.dart';

typedef NInfoOverlayBuilderCreateCallback = Widget Function(
    BuildContext context,
    NaverMapController mapController,
    NInfoOverlayPortalController controller,
    VoidCallback back);

typedef NInfoOverlayBuilderCallback = Widget Function(
    BuildContext context, NaverMapController mapController);

class NInfoOverlayPortalController extends OverlayPortalController {
  NInfoOverlayPortalController({super.debugLabel});

  NInfoOverlayBuilderCallback _builder =
      (BuildContext _, NaverMapController __) => const SizedBox();

  NInfoOverlayBuilderCallback get builder => _builder;

  void openWithWidget({
    required NInfoOverlayBuilderCreateCallback builder,
    required NPoint screenPoint,
    required Stream<NPoint> screenPointStream,
    required NOverlay<dynamic> overlay,
  }) {
    _builder = (BuildContext context, NaverMapController mapController) =>
        _nOverlayInfoOverlayWithTouchScope(context,
            point: screenPoint,
            screenPointStream: screenPointStream,
            child: builder.call(context, mapController, this, hide));
    show();
  }

  Widget _nOverlayInfoOverlayWithTouchScope(BuildContext context,
      {required NPoint point,
      required Stream<NPoint> screenPointStream,
      required Widget child}) {
    return Positioned.fill(
        child: StreamBuilder<NPoint>(
            stream: screenPointStream,
            builder: (context, snapshot) {
              final xPosition = snapshot.data?.x ?? point.x;
              final yPosition = snapshot.data?.y ?? point.y;
              final screenSize = MediaQuery.sizeOf(context);
              if ((xPosition < 0 || screenSize.width < xPosition) ||
                  (yPosition < 0 || screenSize.height < yPosition)) {
                WidgetsBinding.instance.addPostFrameCallback((_) => hide());
              }
              return Stack(children: [
                Positioned(
                    left: xPosition - 28,
                    top: yPosition,
                    child: Balloon(
                        borderRadius: BorderRadius.circular(12),
                        nipMargin: 8,
                        nipSize: 16,
                        nipRadius: 4,
                        elevation: 6,
                        padding: EdgeInsets.zero,
                        color: getColorTheme(context).background,
                        shadowColor: Colors.black,
                        nipPosition: BalloonNipPosition.topLeft,
                        child:
                            SizedBox(width: 200, height: 160, child: child))),
              ]);
            }));
  }
}

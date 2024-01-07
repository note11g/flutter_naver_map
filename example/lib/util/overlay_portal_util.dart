import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_naver_map_example/design/custom_widget.dart';
import 'package:flutter_naver_map_example/design/theme.dart';

typedef NInfoOverlayBuilderCreateCallback = Widget Function(
    BuildContext context,
    NaverMapController mapController,
    NInfoOverlayPortalController controller);

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
    required NOverlay<dynamic> overlay,
  }) {
    _builder = (BuildContext context, NaverMapController mapController) =>
        _nOverlayInfoOverlayWithTouchScope(context,
            point: screenPoint,
            child: builder.call(context, mapController, this));
    show();
  }

  Widget _nOverlayInfoOverlayWithTouchScope(BuildContext context,
      {required NPoint point, required Widget child}) {
    final xPosition = (point.x) - 28;
    return Positioned.fill(
        child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => hide(),
            child: Container(
                color: Colors.black12,
                child: Stack(children: [
                  Positioned(
                      left: xPosition < 0 ? 0 : xPosition,
                      top: point.y < 0 ? 0 : point.y,
                      child: Balloon(
                          size: const Size(200, 160),
                          padding: EdgeInsets.zero,
                          backgroundColor: getColorTheme(context).background,
                          child: child)),
                ]))));
  }
}

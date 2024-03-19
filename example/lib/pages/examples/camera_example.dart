import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import '../../design/theme.dart';
import '../../util/string_util.dart';
import '../../design/custom_widget.dart';
import '../others/example_page_data.dart';

class CameraUpdateExample extends StatefulWidget {
  static const ExamplePageData pageData = ExamplePageData(
    title: "카메라 이동",
    icon: Icons.zoom_in_rounded,
    description: "지도를 요리조리 움직여봐요",
    route: "/move_camera",
  );

  final NaverMapController mapController;
  final Stream<NCameraUpdateReason> onCameraChangeStream;

  const CameraUpdateExample({
    Key? key,
    required this.mapController,
    required this.onCameraChangeStream,
  }) : super(key: key);

  @override
  State<CameraUpdateExample> createState() => _NOverlayExampleState();
}

class _NOverlayExampleState extends State<CameraUpdateExample> {
  /// 현재 카메라 상태
  NCameraPosition? _nowCameraPosition;
  int _animationMill = 300;
  static const dpForMove = 40.0;

  void onCameraChange() {
    _nowCameraPosition = _mapController.nowCameraPosition;
    if (mounted) setState(() {});
  }

  void updateCamera(NCameraUpdate cameraUpdate) {
    _mapController.updateCamera(cameraUpdate
      ..setAnimation(duration: Duration(milliseconds: _animationMill)));
  }

  void moveCameraCoordWithDp(double dp, Axis axis) async {
    final meterPerDp = _mapController.getMeterPerDp();
    final offsetMeter = meterPerDp * dp;
    updateCamera(NCameraUpdate.withParams(
        target: _nowCameraPosition!.target.offsetByMeter(
      eastMeter: axis == Axis.horizontal ? offsetMeter : 0,
      northMeter: axis == Axis.vertical ? offsetMeter : 0,
    )));
  }

  Widget coordControlWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20)
            .copyWith(right: 20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: InnerSimpleTitle(
                      title:
                          "좌표 (${_nowCameraPosition?.target.toShortString()})",
                      description:
                          "NCameraUpdate.scrollAndZoomTo, .target,\nNCameraPosition.target")),
              _arrowButtonController(
                up: () => moveCameraCoordWithDp(dpForMove, Axis.vertical),
                down: () => moveCameraCoordWithDp(-dpForMove, Axis.vertical),
                left: () => moveCameraCoordWithDp(-dpForMove, Axis.horizontal),
                right: () => moveCameraCoordWithDp(dpForMove, Axis.horizontal),
              ),
            ]));
  }

  Widget _arrowButtonController({
    required VoidCallback left,
    required VoidCallback right,
    required VoidCallback up,
    required VoidCallback down,
  }) {
    Widget buttonSeparator([bool horizontal = false]) => Container(
        width: horizontal ? null : 1,
        height: horizontal ? 1 : null,
        color: getColorTheme(context).onSurface);

    Widget arrowButton(IconData icon, void Function() onTap,
            {double width = 32, double height = 48}) =>
        Material(
            color: getColorTheme(context).outline,
            child: InkWell(
                onTap: onTap,
                child: Container(
                    width: width,
                    height: height,
                    alignment: Alignment.center,
                    child: Icon(icon, size: 20))));

    return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: IntrinsicHeight(
            child: Row(children: [
          arrowButton(Icons.arrow_left_rounded, left),
          buttonSeparator(),
          SizedBox(
              width: 40,
              height: 48,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        child: arrowButton(Icons.arrow_drop_up_rounded, up)),
                    buttonSeparator(true),
                    Expanded(
                        child:
                            arrowButton(Icons.arrow_drop_down_rounded, down)),
                  ])),
          buttonSeparator(),
          arrowButton(Icons.arrow_right_rounded, right),
        ])));
  }

  Widget zoomControlWidget() {
    return plusMinusItemWidget(
      title: "줌 레벨",
      method:
          "NCameraUpdate.scrollAndZoomTo, .zoom,\n.zoomBy, NCameraPosition.zoom",
      value: _nowCameraPosition?.zoom.toStringAsFixed(1),
      resetFunc: () => updateCamera(NCameraUpdate.withParams(zoom: 14)),
      minusFunc: () => updateCamera(NCameraUpdate.zoomBy(-0.5)),
      plusFunc: () => updateCamera(NCameraUpdate.zoomBy(0.5)),
    );
  }

  Widget tiltControlWidget() {
    return plusMinusItemWidget(
      title: "틸트 레벨",
      method: "NCameraUpdate.tilt, .tiltBy,\nNCameraPosition.tilt",
      value: _nowCameraPosition?.tilt.toStringAsFixed(1),
      resetFunc: () => updateCamera(NCameraUpdate.withParams(tilt: 0)),
      minusFunc: () => updateCamera(NCameraUpdate.withParams(tiltBy: -9)),
      plusFunc: () => updateCamera(NCameraUpdate.withParams(tiltBy: 9)),
    );
  }

  Widget bearingControlWidget() {
    return plusMinusItemWidget(
      title: "방향각(도)",
      method: "NCameraUpdate.bearing, .bearingBy,\nNCameraPosition.bearing",
      value: _nowCameraPosition?.bearing.toStringAsFixed(1),
      resetFunc: () => updateCamera(NCameraUpdate.withParams(bearing: 0)),
      minusFunc: () => updateCamera(NCameraUpdate.withParams(bearingBy: -20)),
      plusFunc: () => updateCamera(NCameraUpdate.withParams(bearingBy: 20)),
    );
  }

  Widget animationSpeedControlWidget() {
    return plusMinusItemWidget(
      title: "이동 애니메이션 시간",
      method: "NCameraUpdate.setAnimation(\n\tNCameraAnimation?, Duration?)",
      value: "${_animationMill}ms",
      resetFunc: () => setState(() => _animationMill = 800),
      minusFunc: () => setState(() => _animationMill -= 100),
      plusFunc: () => setState(() => _animationMill += 100),
    );
  }

  Widget plusMinusItemWidget({
    required String title,
    required String method,
    required String? value,
    required void Function() resetFunc,
    required void Function() plusFunc,
    required void Function() minusFunc,
  }) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20)
            .copyWith(right: 8),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: InnerSimpleTitle(
                      title: title,
                      description: method,
                      direction: Axis.vertical)),
              Row(children: [
                IconButton(
                    onPressed: minusFunc,
                    icon: const Icon(Icons.remove_circle)),
                Material(
                    borderRadius: BorderRadius.circular(8),
                    color: getColorTheme(context).outline,
                    child: InkWell(
                        onTap: resetFunc,
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(children: [
                          Container(
                            constraints: const BoxConstraints(minWidth: 60),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            child: Text(value.toString(),
                                style: getTextTheme(context).titleSmall),
                          ),
                          Positioned(
                              top: 2,
                              right: 2,
                              child: Icon(Icons.refresh_rounded,
                                  size: 12,
                                  color: getColorTheme(context).secondary)),
                        ]))),
                IconButton(
                    onPressed: plusFunc, icon: const Icon(Icons.add_circle)),
              ]),
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      coordControlWidget(),
      zoomControlWidget(),
      Column(children: [
        tiltControlWidget(),
        bearingControlWidget(),
        animationSpeedControlWidget(),
      ]),
      const BottomPadding(),
    ]));
  }

  bool _onKeyUp(KeyEvent event) {
    if (event is KeyDownEvent) return true;

    final _ = switch (event.logicalKey) {
      LogicalKeyboardKey.arrowUp =>
        moveCameraCoordWithDp(dpForMove, Axis.vertical),
      LogicalKeyboardKey.arrowDown =>
        moveCameraCoordWithDp(-dpForMove, Axis.vertical),
      LogicalKeyboardKey.arrowLeft =>
        moveCameraCoordWithDp(-dpForMove, Axis.horizontal),
      LogicalKeyboardKey.arrowRight =>
        moveCameraCoordWithDp(dpForMove, Axis.horizontal),
      LogicalKeyboardKey.minus => updateCamera(NCameraUpdate.zoomBy(-0.5)),
      LogicalKeyboardKey.add ||
      LogicalKeyboardKey.equal =>
        updateCamera(NCameraUpdate.zoomBy(0.5)),
      _ => null,
    };

    return false;
  }

  NaverMapController get _mapController => widget.mapController;
  StreamSubscription<NCameraUpdateReason>? onCameraChangeStreamSubscription;
  StreamSubscription<KeyEvent>? onKeyUpStreamSubscription;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKeyUp);
    onCameraChange();
    onCameraChangeStreamSubscription =
        widget.onCameraChangeStream.listen((_) => onCameraChange());
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKeyUp);
    onCameraChangeStreamSubscription?.cancel();
    onCameraChangeStreamSubscription = null;
    super.dispose();
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_naver_map_example/design/custom_widget.dart';
import 'package:flutter_naver_map_example/pages/example_base.dart';
import 'package:flutter_naver_map_example/util/alert_util.dart';

import '../../design/theme.dart';

class NaverMapControllerExample extends ExampleBasePage {
  final Stream<void> onCameraChangeStream;

  const NaverMapControllerExample({
    super.key,
    required super.mapController,
    required super.canScroll,
    required this.onCameraChangeStream,
  });

  @override
  State<NaverMapControllerExample> createState() =>
      _NaverMapControllerExampleState();
}

class _NaverMapControllerExampleState extends State<NaverMapControllerExample> {
  /// 현재 카메라 상태
  NCameraPosition? _nowCameraPosition;

  /// 현재 m/dp (1dp가 몇 미터인지)
  double? _nowMeterPerDp;

  void onCameraChange() async {
    _nowCameraPosition = await _mapController.getCameraPosition();
    _nowMeterPerDp = await _mapController.getMeterPerDp();
    setState(() {});
  }

  Widget _nowCameraPositionWidget() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(children: [
          const InnerSimpleTitle(
              title: "현재 카메라 상태",
              description: ".getCameraPosition()",
              direction: Axis.horizontal),
          const SizedBox(height: 8),
          Row(children: [
            _cameraPositionValueElementWidget(
                "위도", _nowCameraPosition?.target.latitude),
            _cameraPositionValueElementWidget(
                "경도", _nowCameraPosition?.target.longitude),
            _cameraPositionValueElementWidget(
                "방위각", _nowCameraPosition?.bearing),
            _cameraPositionValueElementWidget("확대", _nowCameraPosition?.zoom),
            _cameraPositionValueElementWidget("기울임", _nowCameraPosition?.tilt),
          ]),
        ]));
  }

  // used in _nowCameraPositionWidget
  Widget _cameraPositionValueElementWidget(String title, Object? value) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(right: 2),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        InkWell(
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text(title, style: getTextTheme(context).titleSmall),
              const SizedBox(width: 4),
              const Icon(Icons.copy, size: 12, color: Colors.grey),
            ]),
            onTap: () {
              if (value == null) return;
              Clipboard.setData(ClipboardData(text: value.toString()));
              AlertUtil.openAlert("클립보드에 복사되었습니다.", context: context);
            }),
        Text(value.toString(),
            overflow: TextOverflow.ellipsis,
            style: getTextTheme(context).bodySmall),
      ]),
    ));
  }

  Widget _meterPerDpWidget() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const InnerSimpleTitle(
              title: "1dp당 거리",
              description: "현재 카메라 기준: .getMeterPerDp()\n"
                  "위도/줌레벨 지정: .getMeterPerDpAtLatitude()"),
          const SizedBox(height: 4),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text("1dp = ", style: getTextTheme(context).bodyMedium),
            Text("${_nowMeterPerDp}m",
                style: getTextTheme(context).titleMedium),
          ]),
        ]));
  }

  Widget _actionButtonSections(bool isUnFold) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: HalfActionButtonGrid(buttons: [
        if (isUnFold)
        HalfActionButton(
            action: _mapController.forceRefresh,
            icon: Icons.refresh,
            title: "지도 강제 새로고침",
            description: ".forceRefresh"),
        HalfActionButton(
            action: () => AlertUtil.openAlert("준비중인 예제입니다.\n함수로는 사용하실 수 있습니다.",
                context: context),
            icon: Icons.camera_alt,
            title: "지도 캡쳐하기",
            description: ".takeSnapshot"),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _nowCameraPositionWidget(),
      _meterPerDpWidget(),
      _actionButtonSections(widget.canScroll),
      const BottomPadding(),
    ]);
  }

  // --- worker ---

  NaverMapController get _mapController => widget.mapController;
  StreamSubscription? onCameraChangeStreamSubscription;

  @override
  void initState() {
    super.initState();
    onCameraChange();
    onCameraChangeStreamSubscription =
        widget.onCameraChangeStream.listen((_) => onCameraChange());
  }

  @override
  void dispose() {
    onCameraChangeStreamSubscription?.cancel();
    super.dispose();
  }
}

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_naver_map_example/design/custom_widget.dart';
import 'package:flutter_naver_map_example/pages/utils/example_base.dart';
import 'package:flutter_naver_map_example/util/alert_util.dart';
import 'package:flutter_naver_map_example/util/string_util.dart';

import '../../design/theme.dart';

class NaverMapControllerExample extends ExampleBasePage {
  final Stream<void> onCameraChangeStream;
  final Stream<Offset> onLastTouchStream;

  const NaverMapControllerExample({
    super.key,
    required super.mapController,
    required super.canScroll,
    required this.onCameraChangeStream,
    required this.onLastTouchStream,
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

  /// 현재 표출되는 지도 범위
  NLatLngBounds? _regionBounds;

  /// 마지막 터치 화면 좌표
  NPoint? _lastTappedScreenPosition;
  NLatLng? _lastTappedMapPosition;

  void onCameraChange() async {
    _nowCameraPosition = _mapController.nowCameraPosition;
    _nowMeterPerDp = await _mapController.getMeterPerDp();
    _regionBounds = await _mapController.getContentBounds();
    if (mounted) setState(() {});
  }

  void onLastTouch(Offset offset) {
    _lastTappedScreenPosition = NPoint(offset.dx, offset.dy);
    _mapController
        .screenLocationToLatLng(_lastTappedScreenPosition!)
        .then((latLng) => _lastTappedMapPosition = latLng);
  }

  Widget _nowCameraPositionWidget() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(children: [
          const InnerSimpleTitle(
              title: "현재 카메라 상태",
              description: ".nowCameraPosition",
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

  Widget _contentsRegionWidget() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const InnerSimpleTitle(
              title: "지도 위젯에 보여지는 범위",
              description: ".getContentBounds() | .getContentRegion()"),
          const SizedBox(height: 4),
          Text(
              "남서: ${_regionBounds?.southWest.toShortString()}, "
              "북동: ${_regionBounds?.northEast.toShortString()}",
              style: getTextTheme(context)
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
        ]));
  }

  Widget _switchLatLngToScreenLocationWidget() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const InnerSimpleTitle(
              title: "위치 좌표 ↔️ 화면 좌표",
              description:
                  ".screenLocationToLatLng(NPoint)\n.latLngToScreenLocation(NLatLng)"),
          const SizedBox(height: 4),
          Text(
              _lastTappedScreenPosition != null
                  ? "마지막 드래그 화면 좌표: NPoint(${_lastTappedScreenPosition!.x.toStringAsFixed(5)}, ${_lastTappedScreenPosition!.y.toStringAsFixed(5)})\n"
                      "변환 된 지도 좌표: NLatLng(${_lastTappedMapPosition?.toShortString()})"
                  : "지도를 드래그해보세요 (드래그 시작점을 수집합니다)",
              style: getTextTheme(context)
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
        ]));
  }

  Widget _actionButtonSections() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: HalfActionButtonGrid(buttons: [
        HalfActionButton(
            action: _mapController.forceRefresh,
            icon: Icons.refresh,
            title: "지도 강제 새로고침",
            description: ".forceRefresh"),
        HalfActionButton(
            action: _takeSnapshot,
            icon: Icons.camera_alt,
            title: "지도 캡쳐하기",
            description: ".takeSnapshot"),
      ]),
    );
  }

  void _takeSnapshot() async {
    final snapshot = await _mapController.takeSnapshot(showControls: false);
    if (context.mounted) {
      showDialog(
          context: context,
          builder: (context) {
            return Center(
                child: Material(
              color: getColorTheme(context).background,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("지도 캡쳐하기",
                            style: getTextTheme(context).titleMedium),
                        Container(
                            margin: const EdgeInsets.only(top: 6),
                            height: MediaQuery.sizeOf(context).height * 0.64,
                            child: Image.file(File(snapshot.path))),
                      ])),
            ));
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.canScroll ? 1 : 0,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _nowCameraPositionWidget(),
        if (widget.canScroll)
          Expanded(
              child: ListView(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.paddingOf(context).bottom),
                  children: [
                _actionButtonSections(),
                _meterPerDpWidget(),
                _contentsRegionWidget(),
                _switchLatLngToScreenLocationWidget(),
              ])),
        if (!widget.canScroll) const BottomPadding(),
      ]),
    );
  }

  // --- worker ---

  NaverMapController get _mapController => widget.mapController;
  StreamSubscription<void>? onCameraChangeStreamSubscription;
  StreamSubscription<Offset>? onLastTouchStreamSubscription;

  @override
  void initState() {
    super.initState();
    onCameraChange();
    onCameraChangeStreamSubscription =
        widget.onCameraChangeStream.listen((_) => onCameraChange());
    onLastTouchStreamSubscription =
        widget.onLastTouchStream.listen(onLastTouch);
  }

  @override
  void dispose() {
    onCameraChangeStreamSubscription?.cancel();
    onLastTouchStreamSubscription?.cancel();
    super.dispose();
  }
}

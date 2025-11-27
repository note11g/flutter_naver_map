import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import '../../design/custom_widget.dart';
import '../../util/location_util.dart';
import '../../util/alert_util.dart';
import '../others/example_page_data.dart';

class NaverMapViewOptionsExample extends StatefulWidget {
  static const ExamplePageData pageData = ExamplePageData(
    title: "지도 위젯 옵션 변경하기",
    description: "위젯에 보여지는 걸 바꿔봐요",
    icon: Icons.map_rounded,
    route: "/map_option",
  );

  final StreamController<NaverMapViewOptions> sharedMapViewOptionChangeState;
  final bool canScroll;

  const NaverMapViewOptionsExample({
    Key? key,
    required this.sharedMapViewOptionChangeState,
    required this.canScroll,
  }) : super(key: key);

  @override
  State<NaverMapViewOptionsExample> createState() =>
      _NaverMapViewOptionsExampleState();
}

class _NaverMapViewOptionsExampleState
    extends State<NaverMapViewOptionsExample> {
  @override
  void initState() {
    widget.sharedMapViewOptionChangeState.stream.listen((e) => _options = e);
    super.initState();
  }

  NaverMapViewOptions _options = const NaverMapViewOptions();

  NaverMapViewOptions get options => _options;

  set options(NaverMapViewOptions value) {
    _options = value;
    final changedOptions = prepareOptionChange(value);
    widget.sharedMapViewOptionChangeState.add(changedOptions);
    setState(() {});
  }

  void clearOptions() => options = const NaverMapViewOptions();

  NaverMapViewOptions prepareOptionChange(NaverMapViewOptions newOptions) {
    if (!indoorAvailable) {
      newOptions = newOptions.copyWith(
          indoorEnable: false, indoorLevelPickerEnable: false);
    }
    if (!liteModeAvailable) {
      newOptions = newOptions.copyWith(liteModeEnable: false);
    }
    if (!nightModeAvailable) {
      newOptions = newOptions.copyWith(nightModeEnable: false);
    }

    return newOptions;
  }

  /// 실내 지도는 지도 유형이 [basic, terrain]만 가능합니다.
  bool get indoorAvailable =>
      options.mapType == NMapType.basic || options.mapType == NMapType.terrain;

  /// 경량 모드는 지도 유형이 navi가 아닌 경우만 가능합니다.
  bool get liteModeAvailable =>
      options.mapType != NMapType.navi && options.mapType != NMapType.none;

  /// 야간 모드는 지도 유형이 navi인 경우만 가능합니다.
  bool get nightModeAvailable => options.mapType == NMapType.navi;

  @override
  Widget build(BuildContext context) {
    return ReLoader(
      text: "옵션을 모두",
      reload: clearOptions,
      child: CustomScrollView(
          primary: true,
          physics: widget.canScroll
              ? const BouncingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          slivers: [
            SliverColumn([
              SelectorWithTitle("지도 유형",
                  description: ".mapType",
                  selector: (context) => EasyDropdown(
                      items: NMapType.values,
                      value: options.mapType,
                      onChanged: (v) =>
                          options = options.copyWith(mapType: v))),
              SelectorWithTitle("로고 위치",
                  description: ".logoAlign",
                  selector: (context) => EasyDropdown(
                      items: NLogoAlign.values,
                      value: options.logoAlign,
                      onChanged: (v) =>
                          options = options.copyWith(logoAlign: v)))
            ]),
            sliverMultiSwitcherGrid([
              TextSwitcher(
                  title: "축척 바",
                  description: ".scaleBarEnable",
                  value: options.scaleBarEnable,
                  onChanged: (v) =>
                      options = options.copyWith(scaleBarEnable: v)),
              TextSwitcher(
                  title: "내 위치 버튼",
                  description: ".locationButtonEnable",
                  value: options.locationButtonEnable,
                  onChanged: (enable) {
                    void buttonEnable(bool v) =>
                        options = options.copyWith(locationButtonEnable: v);
                    if (!enable) {
                      buttonEnable(false);
                      return;
                    }
                    requestLocationPermission(context,
                        onGranted: () => buttonEnable(true));
                  }),
              if (indoorAvailable)
                TextSwitcher(
                    title: "실내 지도",
                    description: ".indoorEnable",
                    value: options.indoorEnable,
                    onChanged: (v) =>
                        options = options.copyWith(indoorEnable: v)),
              if (indoorAvailable)
                TextSwitcher(
                    title: "실내 지도 레벨 피커",
                    description: ".indoorLevelPickerEnable",
                    value: options.indoorLevelPickerEnable,
                    onChanged: (v) =>
                        options = options.copyWith(indoorLevelPickerEnable: v)),
              if (liteModeAvailable)
                TextSwitcher(
                    title: "경량 모드",
                    description: ".liteModeEnable",
                    value: options.liteModeEnable,
                    onChanged: (v) =>
                        options = options.copyWith(liteModeEnable: v)),
              if (nightModeAvailable)
                TextSwitcher(
                    title: "야간 모드",
                    description: ".nightModeEnable",
                    value: options.nightModeEnable,
                    onChanged: (v) =>
                        options = options.copyWith(nightModeEnable: v)),
            ]),
            SliverColumn([
              if (options.indoorEnable)
                SelectorWithTitle("실내 지도 유지 반경",
                    description: ".indoorFocusRadius",
                    selector: (context) => EasySlider(
                        value: options.indoorFocusRadius,
                        onChanged: (v) =>
                            options = options.copyWith(indoorFocusRadius: v))),
              SelectorWithTitle("지도 명도",
                  description: ".lightness",
                  selector: (context) => EasySlider(
                      min: -1,
                      max: 1,
                      floatingPoint: 1,
                      value: options.lightness,
                      onChanged: (v) =>
                          options = options.copyWith(lightness: v))),
              SelectorWithTitle("건물 3D 높이",
                  description: ".buildingHeight",
                  selector: (context) => EasySlider(
                      max: 1,
                      floatingPoint: 1,
                      value: options.buildingHeight,
                      onChanged: (v) =>
                          options = options.copyWith(buildingHeight: v))),
              SelectorWithTitle("심볼 크기",
                  description: ".symbolScale",
                  selector: (context) => EasySlider(
                      max: 2,
                      floatingPoint: 1,
                      value: options.symbolScale,
                      onChanged: (v) =>
                          options = options.copyWith(symbolScale: v))),
              SelectorWithTitle("심볼 원근 계수",
                  description: ".symbolPerspectiveRatio",
                  selector: (context) => EasySlider(
                      max: 1,
                      floatingPoint: 1,
                      value: options.symbolPerspectiveRatio,
                      onChanged: (v) => options =
                          options.copyWith(symbolPerspectiveRatio: v))),
            ]),
            const SliverTitle("제스처 제어"),
            sliverMultiSwitcherGrid([
              TextSwitcher(
                  title: "스크롤 제스처",
                  description: ".scrollGesturesEnable",
                  value: options.scrollGesturesEnable,
                  onChanged: (v) =>
                      options = options.copyWith(scrollGesturesEnable: v)),
              TextSwitcher(
                  title: "줌 제스처",
                  description: ".zoomGesturesEnable",
                  value: options.zoomGesturesEnable,
                  onChanged: (v) =>
                      options = options.copyWith(zoomGesturesEnable: v)),
              TextSwitcher(
                  title: "회전 제스처",
                  description: ".rotationGesturesEnable",
                  value: options.rotationGesturesEnable,
                  onChanged: (v) =>
                      options = options.copyWith(rotationGesturesEnable: v)),
              TextSwitcher(
                  title: "기울임 제스처",
                  description: ".tiltGesturesEnable",
                  value: options.tiltGesturesEnable,
                  onChanged: (v) =>
                      options = options.copyWith(tiltGesturesEnable: v)),
              TextSwitcher(
                  title: "멈춤 제스처",
                  description: ".stopGesturesEnable",
                  value: options.stopGesturesEnable,
                  onChanged: (v) =>
                      options = options.copyWith(stopGesturesEnable: v)),
              TextSwitcher(
                  title: "심볼 터치 소비",
                  description: ".consumeSymbolTapEvents",
                  value: options.consumeSymbolTapEvents,
                  onChanged: (v) =>
                      options = options.copyWith(consumeSymbolTapEvents: v)),
              TextSwitcher(
                  title: "로고 클릭",
                  description: ".logoClickEnable",
                  value: options.logoClickEnable,
                  onChanged: (v) =>
                      options = options.copyWith(logoClickEnable: v)),
            ]),
            SliverColumn([
              SelectorWithTitle("오버레이 및 심볼\n터치 반경",
                  description: ".pickTolerance",
                  selector: (context) => EasySlider(
                      max: 8,
                      divisions: 8,
                      value: options.pickTolerance,
                      onChanged: (v) =>
                          options = options.copyWith(pickTolerance: v))),
              SelectorWithTitle("스크롤 마찰 계수",
                  description: ".scrollGesturesFriction",
                  selector: (context) => EasySlider(
                      max: 1,
                      divisions: null,
                      floatingPoint: 3,
                      value: options.scrollGesturesFriction,
                      defaultValue:
                          NaverMapViewOptions.defaultScrollGesturesFriction,
                      onChanged: (v) => options =
                          options.copyWith(scrollGesturesFriction: v))),
              SelectorWithTitle("줌 마찰 계수",
                  description: ".zoomGesturesFriction",
                  selector: (context) => EasySlider(
                      max: 1,
                      divisions: null,
                      floatingPoint: 3,
                      value: options.zoomGesturesFriction,
                      defaultValue:
                          NaverMapViewOptions.defaultZoomGesturesFriction,
                      onChanged: (v) =>
                          options = options.copyWith(zoomGesturesFriction: v))),
              SelectorWithTitle("회전 마찰 계수",
                  description: ".rotationGesturesFriction",
                  selector: (context) => EasySlider(
                      max: 1,
                      divisions: null,
                      floatingPoint: 3,
                      value: options.rotationGesturesFriction,
                      defaultValue:
                          NaverMapViewOptions.defaultRotationGesturesFriction,
                      onChanged: (v) => options =
                          options.copyWith(rotationGesturesFriction: v))),
            ]),
            const SliverTitle("표시할 정보 레이어", description: ".activeLayerGroups"),
            sliverMultiSwitcherGrid([
              layerGroupTextSwitcher("건물", NLayerGroup.building),
              layerGroupTextSwitcher("교통정보", NLayerGroup.traffic),
              layerGroupTextSwitcher("대중교통", NLayerGroup.transit,
                  enable: options.mapType != NMapType.navi),
              layerGroupTextSwitcher("자전거", NLayerGroup.bicycle,
                  enable: options.mapType != NMapType.navi),
              layerGroupTextSwitcher("등산정보", NLayerGroup.mountain,
                  enable: options.mapType != NMapType.navi),
              layerGroupTextSwitcher("지적편집도", NLayerGroup.cadastral,
                  enable: options.mapType != NMapType.navi),
            ], small: true),
            const SliverTitle("이동 제한"),
            SliverColumn([
              SelectorWithTitle("최소 줌 제한",
                  description: ".minZoom",
                  selector: (context) => EasySlider(
                      max: 21,
                      divisions: 21,
                      value: options.minZoom,
                      onChanged: (v) =>
                          options = options.copyWith(minZoom: v))),
              SelectorWithTitle("최대 줌 제한",
                  description: ".maxZoom",
                  selector: (context) => EasySlider(
                      max: 21,
                      divisions: 21,
                      value: options.maxZoom,
                      onChanged: (v) =>
                          options = options.copyWith(maxZoom: v))),
              SelectorWithTitle("최대 기울임 제한",
                  description: ".maxTilt",
                  selector: (context) => EasySlider(
                      max: 63,
                      divisions: 63,
                      value: options.maxTilt,
                      onChanged: (v) =>
                          options = options.copyWith(maxTilt: v))),
            ]),
            const SliverBottomPadding(),
          ]),
    );
  }

  Widget sliverMultiSwitcherGrid(List<TextSwitcher> switchers,
      {bool small = false}) {
    return SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        sliver: SliverGrid.count(
          crossAxisCount: small ? 3 : 2,
          mainAxisSpacing: small ? 6 : 8,
          crossAxisSpacing: small ? 6 : 8,
          childAspectRatio: small ? 2 : 2.6,
          children: switchers,
        ));
  }

  void layerGroupChange(bool enable, {required NLayerGroup layer}) {
    options = options.copyWith(
        activeLayerGroups: enable
            ? [layer, ...options.activeLayerGroups]
            : options.activeLayerGroups.where((e) => e != layer).toList());
  }

  TextSwitcher layerGroupTextSwitcher(String title, NLayerGroup layer,
      {bool enable = true}) {
    return TextSwitcher(
        title: title,
        description: layer.name,
        enable: enable && options.mapType != NMapType.none,
        value: layerGroupContains(layer),
        onChanged: (enable) => layerGroupChange(enable, layer: layer));
  }

  bool layerGroupContains(NLayerGroup layer) {
    return options.activeLayerGroups.contains(layer);
  }

  void requestLocationPermission(BuildContext context,
      {required void Function() onGranted}) {
    AlertUtil.openAlertIfResultTrue("위치 권한이 없습니다.\n위치를 가져오려면 권한을 허용해주세요.",
        context: context, callback: () async {
      final isGranted = await ExampleLocationUtil.requestAndGrantedCheck();
      if (isGranted) onGranted();
      final needShowAlert = !isGranted;
      return needShowAlert;
    });
  }
}

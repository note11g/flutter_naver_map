import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../design/custom_widget.dart';
import '../../design/theme.dart';
import '../../util/location_util.dart';
import '../../util/alert_util.dart';

class NaverMapViewOptionsExample extends StatelessWidget {
  final NaverMapViewOptions options;
  final Function(NaverMapViewOptions options) onOptionsChanged;
  final bool canScroll;

  NaverMapViewOptionsExample({
    Key? key,
    required this.options,
    required this.onOptionsChanged,
    required this.canScroll,
  }) : super(key: key);

  set options(NaverMapViewOptions value) {
    final changedOptions = prepareOptionChange(value);
    onOptionsChanged(changedOptions);
  }

  void clearOptions() => onOptionsChanged(const NaverMapViewOptions());

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

  final refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SmartRefresher(
      controller: refreshController,
      onRefresh: () =>
          Future.delayed(const Duration(milliseconds: 300)).then((value) {
        clearOptions();
        refreshController.refreshToIdle();
      }),
      header: const ClassicHeader(
        refreshingText: "초기화가 완료되었습니다",
        releaseText: "옵션 초기화",
        idleText: "옵션을 모두 초기화하려면 계속해서 당겨주세요",
      ),
      child: CustomScrollView(
          primary: true,
          physics: canScroll
              ? const BouncingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          slivers: [
            sliverColumn([
              _settingItem("지도 유형",
                  methodName: "mapType",
                  selector: EasyDropdown(
                      items: NMapType.values,
                      value: options.mapType,
                      onChanged: (v) => options = options.copyWith(mapType: v)),
                  context: context),
              _settingItem("로고 위치",
                  methodName: "logoAlign",
                  selector: EasyDropdown(
                      items: NLogoAlign.values,
                      value: options.logoAlign,
                      onChanged: (v) =>
                          options = options.copyWith(logoAlign: v)),
                  context: context)
            ]),
            sliverMultiSwitcherGrid([
              TextSwitcher(
                  title: "축척 바",
                  methodName: "scaleBarEnable",
                  value: options.scaleBarEnable,
                  onChanged: (v) =>
                      options = options.copyWith(scaleBarEnable: v)),
              TextSwitcher(
                  title: "내 위치 버튼",
                  methodName: "locationButtonEnable",
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
                    methodName: "indoorEnable",
                    value: options.indoorEnable,
                    onChanged: (v) =>
                        options = options.copyWith(indoorEnable: v)),
              if (indoorAvailable)
                TextSwitcher(
                    title: "실내 지도 레벨 피커",
                    methodName: "indoorLevelPickerEnable",
                    value: options.indoorLevelPickerEnable,
                    onChanged: (v) =>
                        options = options.copyWith(indoorLevelPickerEnable: v)),
              if (liteModeAvailable)
                TextSwitcher(
                    title: "경량 모드",
                    methodName: "liteModeEnable",
                    value: options.liteModeEnable,
                    onChanged: (v) =>
                        options = options.copyWith(liteModeEnable: v)),
              if (nightModeAvailable)
                TextSwitcher(
                    title: "야간 모드",
                    methodName: "nightModeEnable",
                    value: options.nightModeEnable,
                    onChanged: (v) =>
                        options = options.copyWith(nightModeEnable: v)),
            ]),
            sliverColumn([
              if (options.indoorEnable)
                _settingItem("실내 지도 유지 반경",
                    methodName: "indoorFocusRadius",
                    context: context,
                    selector: EasySlider(
                        value: options.indoorFocusRadius,
                        onChanged: (v) =>
                            options = options.copyWith(indoorFocusRadius: v))),
              _settingItem("지도 명도",
                  methodName: "lightness",
                  context: context,
                  selector: EasySlider(
                      min: -1,
                      max: 1,
                      floatingPoint: 1,
                      value: options.lightness,
                      onChanged: (v) =>
                          options = options.copyWith(lightness: v))),
              _settingItem("건물 3D 높이",
                  methodName: "lightness",
                  context: context,
                  selector: EasySlider(
                      max: 1,
                      floatingPoint: 1,
                      value: options.buildingHeight,
                      onChanged: (v) =>
                          options = options.copyWith(buildingHeight: v))),
              _settingItem("심볼 크기",
                  methodName: "symbolScale",
                  context: context,
                  selector: EasySlider(
                      max: 2,
                      floatingPoint: 1,
                      value: options.symbolScale,
                      onChanged: (v) =>
                          options = options.copyWith(symbolScale: v))),
              _settingItem("심볼 원근 계수",
                  methodName: "symbolPerspectiveRatio",
                  context: context,
                  selector: EasySlider(
                      max: 1,
                      floatingPoint: 1,
                      value: options.symbolPerspectiveRatio,
                      onChanged: (v) => options =
                          options.copyWith(symbolPerspectiveRatio: v))),
            ]),
            sliverTitle("제스처 제어", context: context),
            sliverMultiSwitcherGrid([
              TextSwitcher(
                  title: "스크롤 제스처",
                  methodName: "scrollGesturesEnable",
                  value: options.scrollGesturesEnable,
                  onChanged: (v) =>
                      options = options.copyWith(scrollGesturesEnable: v)),
              TextSwitcher(
                  title: "줌 제스처",
                  methodName: "zoomGesturesEnable",
                  value: options.zoomGesturesEnable,
                  onChanged: (v) =>
                      options = options.copyWith(zoomGesturesEnable: v)),
              TextSwitcher(
                  title: "회전 제스처",
                  methodName: "rotationGesturesEnable",
                  value: options.rotationGesturesEnable,
                  onChanged: (v) =>
                      options = options.copyWith(rotationGesturesEnable: v)),
              TextSwitcher(
                  title: "기울임 제스처",
                  methodName: "tiltGesturesEnable",
                  value: options.tiltGesturesEnable,
                  onChanged: (v) =>
                      options = options.copyWith(tiltGesturesEnable: v)),
              TextSwitcher(
                  title: "멈춤 제스처",
                  methodName: "stopGesturesEnable",
                  value: options.stopGesturesEnable,
                  onChanged: (v) =>
                      options = options.copyWith(stopGesturesEnable: v)),
              TextSwitcher(
                  title: "심볼 터치 소비",
                  methodName: "consumeSymbolTapEvents",
                  value: options.consumeSymbolTapEvents,
                  onChanged: (v) =>
                      options = options.copyWith(consumeSymbolTapEvents: v)),
              TextSwitcher(
                  title: "로고 클릭",
                  methodName: "logoClickEnable",
                  value: options.logoClickEnable,
                  onChanged: (v) =>
                      options = options.copyWith(logoClickEnable: v)),
            ]),
            sliverColumn([
              _settingItem("오버레이 및 심볼\n터치 반경",
                  methodName: "pickTolerance",
                  context: context,
                  selector: EasySlider(
                      max: 8,
                      divisions: 8,
                      value: options.pickTolerance,
                      onChanged: (v) =>
                          options = options.copyWith(pickTolerance: v))),
              _settingItem("스크롤 마찰 계수",
                  methodName: "scrollGesturesFriction",
                  context: context,
                  selector: EasySlider(
                      max: 1,
                      divisions: null,
                      floatingPoint: 3,
                      value: options.scrollGesturesFriction,
                      defaultValue:
                          NaverMapViewOptions.defaultScrollGesturesFriction,
                      onChanged: (v) => options =
                          options.copyWith(scrollGesturesFriction: v))),
              _settingItem("줌 마찰 계수",
                  methodName: "zoomGesturesFriction",
                  context: context,
                  selector: EasySlider(
                      max: 1,
                      divisions: null,
                      floatingPoint: 3,
                      value: options.zoomGesturesFriction,
                      defaultValue:
                          NaverMapViewOptions.defaultZoomGesturesFriction,
                      onChanged: (v) =>
                          options = options.copyWith(zoomGesturesFriction: v))),
              _settingItem("회전 마찰 계수",
                  methodName: "rotationGesturesFriction",
                  context: context,
                  selector: EasySlider(
                      max: 1,
                      divisions: null,
                      floatingPoint: 3,
                      value: options.rotationGesturesFriction,
                      defaultValue:
                          NaverMapViewOptions.defaultRotationGesturesFriction,
                      onChanged: (v) => options =
                          options.copyWith(rotationGesturesFriction: v))),
            ]),
            sliverTitle("표시할 정보 레이어",
                description: ".activeLayerGroups", context: context),
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
            sliverTitle("이동 제한", context: context),
            sliverColumn([
              _settingItem("최소 줌 제한",
                  methodName: "minZoom",
                  context: context,
                  selector: EasySlider(
                      max: 21,
                      divisions: 21,
                      value: options.minZoom,
                      onChanged: (v) =>
                          options = options.copyWith(minZoom: v))),
              _settingItem("최대 줌 제한",
                  methodName: "maxZoom",
                  context: context,
                  selector: EasySlider(
                      max: 21,
                      divisions: 21,
                      value: options.maxZoom,
                      onChanged: (v) =>
                          options = options.copyWith(maxZoom: v))),
              _settingItem("최대 기울임 제한",
                  methodName: "maxTilt",
                  context: context,
                  selector: EasySlider(
                      max: 63,
                      divisions: 63,
                      value: options.maxTilt,
                      onChanged: (v) =>
                          options = options.copyWith(maxTilt: v))),
            ]),
            SliverPadding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom)),
          ]),
    ));
  }

  Widget _settingItem(String title,
      {required String methodName,
      required EasySelectorWidget selector,
      required BuildContext context}) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        child: Row(children: [
          Expanded(
              flex: 1,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: getTextTheme(context).titleMedium),
                    const SizedBox(height: 2),
                    Text(".$methodName",
                        style: getTextTheme(context).bodySmall),
                  ])),
          Expanded(flex: selector.expand ? 2 : 0, child: selector)
        ]));
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

  bool layerGroupContains(NLayerGroup layer) {
    return options.activeLayerGroups.contains(layer);
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
        methodName: layer.name,
        enable: enable && options.mapType != NMapType.none,
        value: layerGroupContains(layer),
        onChanged: (enable) => layerGroupChange(enable, layer: layer));
  }

  SliverPadding sliverTitle(String title,
      {String? description, required BuildContext context}) {
    return SliverPadding(
        padding: const EdgeInsets.only(left: 24, top: 12),
        sliver: SliverToBoxAdapter(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
              Text(title, style: getTextTheme(context).titleMedium),
              if (description != null) const SizedBox(width: 4),
              if (description != null)
                Text(description, style: getTextTheme(context).bodySmall),
            ])));
  }

  SliverToBoxAdapter sliverColumn(List<Widget> children) {
    return SliverToBoxAdapter(
      child: Column(children: children),
    );
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

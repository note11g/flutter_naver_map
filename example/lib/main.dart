import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bottom_drawer/flutter_bottom_drawer.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_naver_map_example/design/custom_widget.dart';
import 'package:flutter_naver_map_example/pages/others/example_page_data.dart';
import 'package:flutter_naver_map_example/pages/others/routes.dart';
import 'package:flutter_naver_map_example/util/example_location_tracker.dart';
import 'package:flutter_naver_map_example/util/overlay_portal_util.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'design/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterNaverMap().init(
      clientId: 'dzx1zs89q6',
      onAuthFailed: (ex) {
        switch (ex) {
          case NQuotaExceededException(:final message):
            print("사용량 초과 (message: $message)");
            break;
          case NUnauthorizedClientException() ||
                NClientUnspecifiedException() ||
                NAnotherAuthFailedException():
            print("인증 실패: $ex");
            break;
        }
      });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: goRouter,
        theme: ExampleAppTheme.lightThemeData,
        darkTheme: ExampleAppTheme.darkThemeData);
  }
}

class FNMapPage extends StatefulWidget {
  final Widget bottomSheetPage;
  final Stream<ExamplePageData?> pageObserveStream;
  final Stream<NaverMapViewOptions> sharedMapViewOptionChangeStream;

  const FNMapPage({
    Key? key,
    required this.bottomSheetPage,
    required this.pageObserveStream,
    required this.sharedMapViewOptionChangeStream,
  }) : super(key: key);

  @override
  State<FNMapPage> createState() => _FNMapPageState();
}

class _FNMapPageState extends State<FNMapPage> {
  late NaverMapController mapController;
  final _onCameraChangeStreamController =
      StreamController<NCameraUpdateReason>.broadcast();
  final _mapKey = UniqueKey();

  Widget mapWidget(BuildContext context, NaverMapViewOptions options) {
    final safeArea = MediaQuery.paddingOf(context);
    final mapPadding =
        EdgeInsets.only(top: safeArea.top, bottom: _drawerHandleHeight);
    return NaverMap(
      key: _mapKey,
      options: options.copyWith(contentPadding: mapPadding),
      clusterOptions: NaverMapClusteringOptions(
          mergeStrategy: const NClusterMergeStrategy(
            willMergedScreenDistance: {
              NaverMapClusteringOptions.defaultClusteringZoomRange: 35,
            },
          ),
          clusterMarkerBuilder: (info, clusterMarker) {
            print("[flutter] clusterMarkerBuilder: $info");
            if (clusterIcon != null) clusterMarker.setIcon(clusterIcon!);
            clusterMarker.setIsFlat(true);
            clusterMarker.setCaption(NOverlayCaption(
                text: info.size.toString(),
                color: Colors.white,
                haloColor: Colors.blueAccent));
          }),
      onMapReady: onMapReady,
      onMapLoaded: onMapLoaded,
      onMapTapped: onMapTapped,
      onMapLongTapped: onMapLongTapped,
      onSymbolTapped: onSymbolTapped,
      onCameraChange: onCameraChange,
      onCameraIdle: onCameraIdle,
      onSelectedIndoorChanged: onSelectedIndoorChanged,
      onCustomStyleLoaded: onCustomStyleLoaded,
      onCustomStyleLoadFailed: onCustomStyleLoadFailed,
    );
  }

  /* ----- Events ----- */

  void onMapReady(NaverMapController controller) {
    mapController = controller;
    GetIt.I.registerSingleton(controller);
    // controller.setMyLocationTracker(NExampleMyLocationTracker());
  }

  void onMapLoaded() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("onMapLoaded"),
    ));
  }

  void onMapTapped(NPoint point, NLatLng latLng) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("onMapTapped\n$latLng"),
    ));
  }

  void onMapLongTapped(NPoint point, NLatLng latLng) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("onMapLongTapped\n$latLng"),
    ));
  }

  void onSymbolTapped(NSymbolInfo symbolInfo) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
          Text("onSymbolTapped: ${symbolInfo.caption}\n${symbolInfo.position}"),
    ));
  }

  void onCameraChange(NCameraUpdateReason reason, bool isGesture) {
    // ...
    _onCameraChangeStreamController.sink.add(reason);
  }

  void onCameraIdle() {
    // ...
  }

  void onSelectedIndoorChanged(NSelectedIndoor? selectedIndoor) {
    // ...
  }

  void onCustomStyleLoaded() {
    // ...
  }

  void onCustomStyleLoadFailed(Exception exception) {
    // ...
  }

  NOverlayImage? clusterIcon;

  @override
  void initState() {
    GetIt.I.registerLazySingleton<Stream<NCameraUpdateReason>>(
        () => _onCameraChangeStreamController.stream);
    GetIt.I.registerLazySingleton(() => nOverlayInfoOverlayPortalController);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // 고정된 이미지라면, NOverlayImage.fromAsset 혹은 NOverlayImage.fromFile 을 사용하는 것이 좋습니다.
      // fromWidget은 비용이 비싸기 때문에, 되도록 사용하지 않되, 사용할 경우 미리 생성해둔 하나의 객체를 사용하는 것이 좋습니다.
      // 예제에서는, 패키지의 용량을 줄이기 위해 이렇게 생성합니다.
      NOverlayImage.fromWidget(
              widget: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                      color: Colors.blueAccent, shape: BoxShape.circle)),
              context: context)
          .then((value) {
        clusterIcon = value;
      });
    });
  }

  /* ----- UI Size ----- */
  double drawerHeight = 0;
  double? initMainDrawerHeight;

  final nOverlayInfoOverlayPortalController = NInfoOverlayPortalController();
  DrawerMoveController? drawerController;
  final drawerKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox.expand(
      child: Stack(children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 150),
          left: 0,
          right: 0,
          top: 0,
          bottom: drawerHeight - _drawerHandleHeight,
          child: StreamBuilder(
              stream: widget.sharedMapViewOptionChangeStream,
              builder: (context, snapshot) => mapWidget(
                  context, snapshot.data ?? const NaverMapViewOptions())),
        ),
        _bottomDrawer(context),
        _overlayPortalSection(),
      ]),
    ));
  }

  static const _drawerHandleHeight = 20.0;

  Widget _bottomDrawer(BuildContext context) => BottomDrawer(
      key: drawerKey,
      height: initMainDrawerHeight /* cached height */,
      expandedHeight: MediaQuery.sizeOf(context).height / 2,
      handleSectionHeight: _drawerHandleHeight,
      handleColor: getColorTheme(context).secondary,
      backgroundColor: getColorTheme(context).background,
      onReady: (controller) => drawerController = controller,
      onHeightChanged: (height) {
        initMainDrawerHeight ??= height;
        drawerHeight = height;
        setState(() {});
      },
      builder: (state, setState, context) => Column(children: [
            _headerSection(context),
            Expanded(
                flex: initMainDrawerHeight != null ? 1 : 0,
                child: widget.bottomSheetPage),
            // todo: prevent scroll gesture when state != DrawerState.opened
          ]));

  Widget _overlayPortalSection() => OverlayPortal(
      controller: nOverlayInfoOverlayPortalController,
      overlayChildBuilder: (context) =>
          nOverlayInfoOverlayPortalController.builder(context, mapController));

  Widget _headerSection(BuildContext context) => StreamBuilder(
      stream: widget.pageObserveStream,
      builder: (context, snapshot) {
        return snapshot.data != null
            ? getHeaderByPageData(snapshot.data!)
            : getMainHeader(context);
      });

  Widget getMainHeader(BuildContext context) => BaseDrawerHeader(
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text("지도 기능 둘러보기", style: getTextTheme(context).titleLarge),
        const SizedBox(width: 8),
        const Flexible(
            child: Align(
                alignment: Alignment.centerRight, child: VersionInfoWidget())),
      ]));

  Widget getHeaderByPageData(ExamplePageData data) => BaseDrawerHeader(
      padding: EdgeInsets.zero,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              IconButton(
                  onPressed: context.pop,
                  padding: const EdgeInsets.all(12),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20)),
              Text(data.title, style: getTextTheme(context).titleLarge),
            ]),
            _drawerAutoControlButton(),
          ]));

  Widget _drawerAutoControlButton() {
    if (drawerController == null) return const SizedBox();
    DrawerState drawerState = drawerController!.nowState;

    return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: StatefulBuilder(builder: (context, setStateButton) {
          return InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () {
                if (drawerController == null) return;
                drawerController!.autoMove();
                drawerState = drawerController!.nowState;
                setStateButton(() {});
              },
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(drawerState == DrawerState.opened ? "접기" : "펼치기",
                      style: getTextTheme(context)
                          .labelSmall
                          ?.copyWith(color: getColorTheme(context).primary))));
        }));
  }
}

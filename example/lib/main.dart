import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bottom_drawer/flutter_bottom_drawer.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_naver_map_example/design/custom_widget.dart';
import 'package:flutter_naver_map_example/pages/others/example_page_data.dart';
import 'package:flutter_naver_map_example/pages/others/routes.dart';
import 'package:flutter_naver_map_example/util/overlay_portal_util.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'design/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NaverMapSdk.instance.initialize(
      clientId: '2vkiu8dsqb',
      onAuthFailed: (error) {
        print('Auth failed: $error');
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

  Widget mapWidget(BuildContext context, NaverMapViewOptions options) {
    final safeArea = MediaQuery.paddingOf(context);
    final mapPadding =
        safeArea.copyWith(bottom: drawerHeight - safeArea.bottom);
    return NaverMap(
      options: options.copyWith(contentPadding: mapPadding),
      onMapReady: onMapReady,
      onMapTapped: onMapTapped,
      onSymbolTapped: onSymbolTapped,
      onCameraChange: onCameraChange,
      onCameraIdle: onCameraIdle,
      onSelectedIndoorChanged: onSelectedIndoorChanged,
    );
  }

  /* ----- Events ----- */

  void onMapReady(NaverMapController controller) {
    mapController = controller;
    GetIt.I.registerSingleton(controller);
  }

  void onMapTapped(NPoint point, NLatLng latLng) async {
    // ...
  }

  void onSymbolTapped(NSymbolInfo symbolInfo) {
    // ...
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

  @override
  void initState() {
    GetIt.I.registerLazySingleton<Stream<NCameraUpdateReason>>(
        () => _onCameraChangeStreamController.stream);
    GetIt.I.registerLazySingleton(() => nOverlayInfoOverlayPortalController);
    super.initState();
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
        body: Stack(children: [
      StreamBuilder(
          stream: widget.sharedMapViewOptionChangeStream,
          builder: (context, snapshot) =>
              mapWidget(context, snapshot.data ?? const NaverMapViewOptions())),
      _bottomDrawer(context),
      _overlayPortalSection(),
    ]));
  }

  Widget _bottomDrawer(BuildContext context) => BottomDrawer(
      key: drawerKey,
      height: initMainDrawerHeight /* cached height */,
      expandedHeight: MediaQuery.sizeOf(context).height / 2,
      handleSectionHeight: 20,
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

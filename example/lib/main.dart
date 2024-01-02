import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_naver_map_example/pages/examples/controller_example.dart';
import 'package:flutter_naver_map_example/pages/examples/overlay_example.dart';

import 'pages/bottom_drawer.dart';
import 'pages/new_window_page.dart';
import 'design/map_function_item.dart';
import 'design/theme.dart';

import 'pages/examples/options_example.dart';

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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const FNMapPage(),
        theme: ExampleAppTheme.lightThemeData,
        darkTheme: ExampleAppTheme.darkThemeData);
  }
}

class FNMapPage extends StatefulWidget {
  const FNMapPage({Key? key}) : super(key: key);

  @override
  State<FNMapPage> createState() => _FNMapPageState();
}

class _FNMapPageState extends State<FNMapPage> {
  /* ----- UI Size ----- */
  late EdgeInsets safeArea;
  double drawerHeight = 0;

  @override
  Widget build(BuildContext context) {
    safeArea = MediaQuery.of(context).padding;
    return WillPopScope(
      onWillPop: () async => drawerTool.processWillPop(),
      child: Stack(children: [
        Positioned.fill(child: mapWidget()),
        drawerTool.bottomDrawer,
      ]),
    );
  }

  /*
    --- Naver Map Widget ---
  */

  late NaverMapController mapController;
  NaverMapViewOptions options = const NaverMapViewOptions();

  Widget mapWidget() {
    final mapPadding = EdgeInsets.only(bottom: drawerHeight - safeArea.bottom);
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
  }

  void onMapTapped(NPoint point, NLatLng latLng) {
    // ...
  }

  void onSymbolTapped(NSymbolInfo symbolInfo) {
    // ...
  }

  void onCameraChange(NCameraUpdateReason reason, bool isGesture) {
    // ...
    _onCameraChangeStreamController.sink.add(null);
  }

  void onCameraIdle() {
    // ...
  }

  void onSelectedIndoorChanged(NSelectedIndoor? selectedIndoor) {
    // ...
  }

  final _onCameraChangeStreamController = StreamController.broadcast();

  /*
    --- Bottom Drawer Widget ---
  */

  late final drawerTool = ExampleAppBottomDrawer(
      context: context,
      onDrawerHeightChanged: (height) => setState(() => drawerHeight = height),
      rebuild: () => setState(() {}),
      pages: pages);

  late final List<MapFunctionItem> pages = [
    MapFunctionItem(
        title: "NaverMapViewOptions 변경",
        description: "지도의 옵션을 변경할 수 있어요",
        page: (canScroll) => NaverMapViewOptionsExample(
            canScroll: canScroll,
            options: options,
            onOptionsChanged: (changed) {
              if (changed != options) setState(() => options = changed);
            })),
    MapFunctionItem(
        title: "오버레이 추가 / 제거",
        description: "마커, 경로 등의 각종 오버레이들을 추가하고 제거할 수 있어요",
        isScrollPage: false,
        page: (canScroll) => NOverlayExample(
            canScroll: canScroll, mapController: mapController)),
    MapFunctionItem(
        title: "카메라 이동",
        description: "지도에 보이는 영역을 카메라를 이동하여 바꿀 수 있어요",
        page: (canScroll) => _cameraMoveTestPage(mapController)),
    MapFunctionItem(
        title: "기타 컨트롤러 기능",
        description: "컨트롤러로 지도의 상태를 가져오거나 변경할 수 있습니다.",
        isScrollPage: false,
        page: (canScroll) => NaverMapControllerExample(
              canScroll: canScroll,
              mapController: mapController,
              onCameraChangeStream: _onCameraChangeStreamController.stream,
            )),
    MapFunctionItem(
        title: "주변 심볼 및 오버레이 가져오기",
        description: "특정 영역 주변의 심볼 및 오버레이를 가져올 수 있어요",
        page: (canScroll) => _pickTestPage()),
    MapFunctionItem(
      title: "새 페이지에서 지도 보기",
      description: "새 페이지에서 지도를 봅니다. (메모리 누수 확인용)",
      onTap: (_) => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const NewWindowTestPage())),
    ),
  ];

  Widget _cameraMoveTestPage(NaverMapController mapController) {
    return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          // todo
          const Text("_cameraMoveTestPage"),
          const Text("카메라 이동"),
          ElevatedButton(
              onPressed: () {
                mapController.updateCamera(NCameraUpdate.fromCameraPosition(
                    const NCameraPosition(
                        target: NLatLng(37.56362422812855, 126.96269803941277),
                        zoom: 17.00922642853924,
                        bearing: 119.62995870263971)));
              },
              child: const Text('카메라 회전')),
        ]));
  }

  Widget _pickTestPage() {
    return const Padding(
        padding: EdgeInsets.all(24),
        child: Column(children: [
          // todo
          Text("_pickTestPage"),
          Text("주변 심볼 및 오버레이 가져오기"),
        ]));
  }
}

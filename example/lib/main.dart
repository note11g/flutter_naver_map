import 'dart:async';
import 'dart:developer' show log;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

void main() async {
  await _initialize();
  runApp(const MyApp());
}

Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: 'put your client id here',
      onAuthFailed: (ex) => print("********* 네이버맵 인증오류 : $ex *********"));
}

@visibleForTesting
Future<void> mainWithTest(int testId) async {
  print("---------------- NEW TEST : $testId ----------------");
  print("*** running platform: ${Platform.operatingSystem} ***\n");

  await _initialize();

  runApp(MyApp(testId: testId));
}

class MyApp extends StatelessWidget {
  final int? testId;

  const MyApp({super.key, this.testId});

  @override
  Widget build(BuildContext context) => MaterialApp(
      home: TestPage(key: testId == null ? null : Key("testPage_$testId")));
}

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  late NaverMapController _mapController;
  final Completer<NaverMapController> mapControllerCompleter = Completer();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final pixelRatio = mediaQuery.devicePixelRatio;
    final mapSize =
        Size(mediaQuery.size.width - 32, mediaQuery.size.height - 72);
    final physicalSize =
        Size(mapSize.width * pixelRatio, mapSize.height * pixelRatio);

    print("physicalSize: $physicalSize");

    return Scaffold(
        backgroundColor: const Color(0xFF343945),
        body: Center(
            child: Container(
                width: mapSize.width,
                height: mapSize.height,
                color: Colors.greenAccent,
                child: _naverMapSection())),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await _mapController.clearOverlays();
            },
            child: const Icon(Icons.clear_rounded)));
  }

  Widget _naverMapSection() => NaverMap(
        options: const NaverMapViewOptions(
            indoorEnable: true,
            locationButtonEnable: true,
            consumeSymbolTapEvents: false),
        onMapReady: (controller) async {
          _mapController = controller;
          mapControllerCompleter.complete(controller);
        },
        onMapTapped: (point, latLng) async {
          log("onMapTapped: $point, $latLng", name: "onMapTapped");
          final marker = NMarker(id: latLng.toString(), position: latLng);
          _mapController.addOverlay(marker);
        },
      );
}

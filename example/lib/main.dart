import 'dart:async';
import 'dart:developer' show log;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';

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
      home: testId == null
          ? const FirstPage()
          : TestPage(key: Key("testPage_$testId")));
}

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('First Page')),
        body: Center(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TestPage()));
                },
                child: const Text('Go to Second Page'))));
  }
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
                // color: Colors.greenAccent,
                child: _naverMapSection())),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              const latLngList = [
                NLatLng(37.497175, 127.027926), // 강남
                NLatLng(37.484147, 127.034631), // 양재
                NLatLng(37.470023, 127.038573), // 양재 시민의 숲
                NLatLng(37.447211, 127.055664), // 청계산 입구
                NLatLng(37.394761, 127.111217), // 판교
                NLatLng(37.367381, 127.108847), // 정자
              ];

              final markerList = latLngList.map(
                  (point) => NMarker(id: point.toString(), position: point));

              final latLngBounds = NLatLngBounds.from(latLngList);

              _mapController.addOverlayAll(markerList.toSet());

              final cameraUpdate = NCameraUpdate.fitBounds(latLngBounds,
                  padding: const EdgeInsets.all(120));

              await _mapController.updateCamera(cameraUpdate);
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
          log("onMapReady", name: "onMapReady");
        },
        onMapTapped: (point, latLng) async {
          log("onMapTapped: $point, $latLng", name: "onMapTapped");
          final marker = NMarker(id: latLng.toString(), position: latLng);
          _mapController.addOverlay(marker);

          final infoWindow =
              NInfoWindow.onMarker(id: "$point$latLng", text: "$point");
          infoWindow.setOnTapListener((overlay) => overlay.close());

          await marker.openInfoWindow(infoWindow);
        },
      );

  void showDialogWithImage(BuildContext context, File file) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Image.file(file),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _locationPermissionRequest();
  }

  Future<void> _locationPermissionRequest() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final requestPermission = await Geolocator.requestPermission();
      if (requestPermission == LocationPermission.denied) {
        // 권한이 거절 됨
      }
    }
  }
}

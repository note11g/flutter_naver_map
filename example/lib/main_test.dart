import 'dart:async';
import 'dart:developer' show log;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

// 통합 테스트를 위한 main 입니다.

@visibleForTesting
Future<void> mainWithTest(String tag) async {
  print("---------------- NEW TEST : $tag ----------------");
  print("*** running platform: ${Platform.operatingSystem} ***\n");

  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(clientId: '', onAuthFailed: (ex) {});

  runApp(MyApp(tag: tag));
}

@visibleForTesting
class MyApp extends StatelessWidget {
  final String tag;

  const MyApp({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: newTestPage(tag));
  }
}

@visibleForTesting
TestPage newTestPage(String tag) {
  return TestPage(key: Key("testPage_$tag"));
}

@visibleForTesting
class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => TestPageState();
}

@visibleForTesting
class TestPageState extends State<TestPage> {
  final Completer<NaverMapController> mapControllerCompleter = Completer();
  final onCameraChangeStreamController =
      StreamController<(NCameraUpdateReason, bool)>.broadcast();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: 300,
      height: 300,
      child: NaverMap(
        options: const NaverMapViewOptions(
            initialCameraPosition:
                NCameraPosition(target: NLatLng(37, 127), zoom: 14),
            indoorEnable: true,
            locationButtonEnable: true,
            consumeSymbolTapEvents: false),
        onMapReady: (controller) async {
          mapControllerCompleter.complete(controller);
          log("onMapReady", name: "onMapReady");
        },
        onCameraIdle: () {
          print("onCameraIdle: ${DateTime.now().millisecondsSinceEpoch}");
        },
        onCameraChange: (reason, animated) {
          onCameraChangeStreamController.add((reason, animated));
        },
      ),
    ));
  }

  void newMapTestPage(String tag) {
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => newTestPage(tag)));
  }
}

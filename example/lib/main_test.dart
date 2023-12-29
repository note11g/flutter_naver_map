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

class MyApp extends StatelessWidget {
  final String tag;

  const MyApp({super.key, required this.tag});

  @override
  Widget build(BuildContext context) =>
      MaterialApp(home: TestPage(key: Key("testPage_$tag")));
}

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  final Completer<NaverMapController> mapControllerCompleter = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NaverMap(
            options: const NaverMapViewOptions(
                indoorEnable: true,
                locationButtonEnable: true,
                consumeSymbolTapEvents: false),
            onMapReady: (controller) async {
              mapControllerCompleter.complete(controller);
              log("onMapReady", name: "onMapReady");
            }));
  }
}

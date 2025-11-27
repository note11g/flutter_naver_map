import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_naver_map_example/main_test.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:meta/meta.dart';

@visibleForTesting
class NaverMapTester {
  final WidgetTester flutterWidgetTester;
  final app.TestPageState testPageState;

  NaverMapTester(this.flutterWidgetTester, this.testPageState);

  Future<void> runGoldenTest({
    required String fileName,
  }) async {
    if (Platform.isAndroid) {
      print("[golden test] "
          "passed on android. "
          "because of this issue: https://github.com/flutter/flutter/issues/103222");
      return;
    }

    const imageWidgetKey = Key("GoldenTestImage");

    final mapController = await _getNaverMapForTest(testPageState);
    final snapshot = await mapController.takeSnapshot();
    showDialog(
        context: testPageState.context,
        builder: (context) => Stack(children: [
              Positioned(
                left: 0,
                top: 0,
                child: SizedBox(
                    width: 300,
                    height: 300,
                    child: RepaintBoundary(
                        key: imageWidgetKey, child: Image.file(snapshot))),
              )
            ]));

    await flutterWidgetTester.pumpAndSettle();

    await Future.delayed(const Duration(seconds: 1));

    // todo: change to naverMapGoldenTest method?
    await expectLater(find.byKey(imageWidgetKey), matchesGoldenFile(fileName));
  }
}

@visibleForTesting
@isTest
void testNaverMap(
  String tag,
  Future<void> Function(NaverMapController controller, NaverMapTester tester)
      callback,
) {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("test for \"$tag\"", (tester) async {
    await app.mainWithTest(tag);
    await tester.pumpAndSettle();
    final testPageState = _getTestPageState(tester, tag);
    final controller = await _getNaverMapForTest(testPageState);
    await callback.call(controller, NaverMapTester(tester, testPageState));
  });
}

app.TestPageState _getTestPageState(WidgetTester tester, String tag) {
  final finder = find.byKey(Key("testPage_$tag"));
  final state = tester.state(finder) as app.TestPageState;
  return state;
}

Future<NaverMapController> _getNaverMapForTest(app.TestPageState state) async {
  final controller = await state.mapControllerCompleter.future;
  print("controller: $controller");
  return controller;
}

@visibleForTesting
Future<NaverMapController> createNewNaverMapPageForTest(NaverMapTester tester,
    {required String tag}) async {
  tester.testPageState.newMapTestPage(tag);
  await tester.flutterWidgetTester.pumpAndSettle();
  final newTestPageState = _getTestPageState(tester.flutterWidgetTester, tag);
  final newController = await _getNaverMapForTest(newTestPageState);
  return newController;
}

@visibleForTesting
void expectCameraPosition(NCameraPosition actual, NCameraPosition expected) {
  expectLatLng(actual.target, expected.target);
  expect(actual.zoom, closeTo(expected.zoom, 0.000001));
  expect(actual.bearing, closeTo(expected.bearing, 0.000001));
  expect(actual.tilt, closeTo(expected.tilt, 0.000001));
}

@visibleForTesting
void expectLatLng(NLatLng actual, NLatLng expected) {
  expect(actual.latitude, closeTo(expected.latitude, 0.000001));
  expect(actual.longitude, closeTo(expected.longitude, 0.000001));
}

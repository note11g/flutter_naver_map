import 'dart:async';
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

  Future<void> pumpAndSettleOnMap({
    int maxAttempts = 20,
    Duration stabilityDelay = const Duration(milliseconds: 100),
    Duration initialDelay = const Duration(milliseconds: 500),
  }) async {
    // Initial delay for NaverMap to initialize
    await Future.delayed(initialDelay);
    await flutterWidgetTester.pump();

    int stableCount = 0;
    const requiredStableFrames = 3; // Need 3 consecutive stable frames

    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      final hadScheduledFrame = flutterWidgetTester.binding.hasScheduledFrame;
      await flutterWidgetTester.pump();
      await Future.delayed(stabilityDelay);

      // If no new frames scheduled during this cycle, count as stable
      if (!hadScheduledFrame &&
          !flutterWidgetTester.binding.hasScheduledFrame) {
        stableCount++;
        if (stableCount >= requiredStableFrames) {
          break; // Found stability!
        }
      } else {
        stableCount = 0; // Reset stability counter
      }
    }

    // Final pump to ensure everything is rendered
    await flutterWidgetTester.pump();
  }

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

    await pumpAndSettleOnMap(initialDelay: const Duration(seconds: 2));

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
    print("Starting test for: $tag");

    print("Calling mainWithTest...");
    await app.mainWithTest(tag);

    print("Calling initial pump...");
    await tester.pump();

    print("Waiting for map initialization...");
    await Future.delayed(const Duration(milliseconds: 2000));

    print("Calling final pump...");
    await tester.pump();

    print("Getting test page state...");
    final testPageState = _getTestPageState(tester, tag);

    print("Getting naver map controller...");
    final controller = await _getNaverMapForTest(testPageState);

    print("Executing test callback...");
    await callback.call(controller, NaverMapTester(tester, testPageState));

    print("Test completed for: $tag");
  });
}

app.TestPageState _getTestPageState(WidgetTester tester, String tag) {
  final finder = find.byKey(Key("testPage_$tag"));
  final state = tester.state(finder) as app.TestPageState;
  return state;
}

Future<NaverMapController> _getNaverMapForTest(app.TestPageState state) async {
  print("Waiting for map controller completion...");

  // 타임아웃 추가 (10초)
  final controller = await state.mapControllerCompleter.future
      .timeout(const Duration(seconds: 10), onTimeout: () {
    print("ERROR: Map controller completion timed out after 10 seconds");
    throw TimeoutException(
        "Map controller completion timed out", const Duration(seconds: 10));
  });

  print("controller completed: $controller");
  return controller;
}

@visibleForTesting
Future<NaverMapController> createNewNaverMapPageForTest(NaverMapTester tester,
    {required String tag}) async {
  tester.testPageState.newMapTestPage(tag);
  await tester.pumpAndSettleOnMap(initialDelay: const Duration(seconds: 2));
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

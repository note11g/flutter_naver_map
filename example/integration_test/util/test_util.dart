import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_naver_map_example/main_test.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

class NaverMapTester {
  final WidgetTester flutterWidgetTester;
  final app.TestPageState testPageState;

  NaverMapTester(this.flutterWidgetTester, this.testPageState);
}

@visibleForTesting
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
    final controller = await _initializeNaverMapForTest(testPageState);
    await callback.call(controller, NaverMapTester(tester, testPageState));
  });
}

app.TestPageState _getTestPageState(WidgetTester tester, String tag) {
  final finder = find.byKey(Key("testPage_$tag"));
  final state = tester.state(finder) as app.TestPageState;
  return state;
}

Future<NaverMapController> _initializeNaverMapForTest(
    app.TestPageState state) async {
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
  final newController = await _initializeNaverMapForTest(newTestPageState);
  return newController;
}

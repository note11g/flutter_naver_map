import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_naver_map_example/main_test.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

@visibleForTesting
void testNaverMap(
    String tag,
    Future<void> Function(NaverMapController controller, BuildContext context)
    callback,
    ) {
  app.TestPageState getTestPageState(WidgetTester tester) {
    final finder = find.byKey(Key("testPage_$tag"));
    final state = tester.state(finder) as app.TestPageState;
    return state;
  }

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("test for \"$tag\"", (tester) async {
    await app.mainWithTest(tag);
    await tester.pumpAndSettle();
    final testPageState = getTestPageState(tester);
    final controller = await _initializeNaverMapForTest(testPageState);
    await callback.call(controller, testPageState.context);
  });
}

Future<NaverMapController> _initializeNaverMapForTest(
    app.TestPageState state) async {
  final controller = await state.mapControllerCompleter.future;
  print("controller: $controller");
  return controller;
}

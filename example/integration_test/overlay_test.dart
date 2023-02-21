import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_naver_map_example/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<NaverMapController> initializeNaverMap(app.TestPageState state) async {
    final controller = await state.mapControllerCompleter.future;
    expect(controller.runtimeType.toString(), "_NaverMapControllerImpl");
    print("controller: $controller");
    return controller;
  }

  group('end-to-end test', () {
    int testId = 0;

    app.TestPageState getTestPageState(WidgetTester tester) {
      final finder = find.byKey(Key("testPage_${testId++}"));
      final state = tester.state(finder) as app.TestPageState;
      return state;
    }

    testWidgets('verify common overlay methods', (WidgetTester tester) async {
      await app.mainWithTest(testId);
      await tester.pumpAndSettle();

      final testPageState = getTestPageState(tester);
      final controller = await initializeNaverMap(testPageState);

      final locationOverlay = await controller.getLocationOverlay();
      expect(locationOverlay.info.type, NOverlayType.locationOverlay);

      /*
        --- OnTapListener Test ---
      */
      final onDoneCompleter = Completer<NOverlayInfo>();

      locationOverlay.setOnTapListener(
          (overlay) => onDoneCompleter.complete(overlay.info));

      locationOverlay.performClick();

      final completedOverlayInfo = await onDoneCompleter.future;

      print("[onTapListener] $completedOverlayInfo");
      expect(completedOverlayInfo, locationOverlay.info);
    });

    testWidgets('verify addable overlays', (WidgetTester tester) async {
      await app.mainWithTest(testId);
      await tester.pumpAndSettle();

      final testPageState = getTestPageState(tester);
      final controller = await initializeNaverMap(testPageState);

      final nowPosition =
          await controller.getCameraPosition().then((p) => p.target);

      final positionList = [
        nowPosition,
        nowPosition.offsetByMeter(northMeter: 100, eastMeter: 30),
        nowPosition.offsetByMeter(northMeter: -100, eastMeter: -50),
        nowPosition.offsetByMeter(northMeter: 60, eastMeter: -50),
        nowPosition.offsetByMeter(northMeter: -60, eastMeter: 20),
        nowPosition,
      ];

      final img = await NOverlayImage.fromWidget(
          widget: const FlutterLogo(),
          size: const Size(24, 24),
          context: testPageState.context);

      final overlaySet = <NAddableOverlay>{
        NMarker(id: "1", position: nowPosition),
        NMarker(id: "m1", position: nowPosition),
        NInfoWindow.onMap(id: "2", text: "인포윈도우", position: nowPosition),
        NCircleOverlay(id: "3", center: nowPosition, radius: 100),
        NPolygonOverlay(id: "4", coords: positionList),
        NPolylineOverlay(id: "5", coords: positionList),
        NGroundOverlay(
            id: "6", bounds: NLatLngBounds.from(positionList), image: img),
        NPathOverlay(id: "7", coords: positionList),
        NMultipartPathOverlay(id: "8", paths: [
          NMultipartPath(coords: positionList),
        ]),
        NArrowheadPathOverlay(id: "9", coords: positionList),
      };

      await controller.addOverlayAll(overlaySet);

      final locationOverlay = await controller.getLocationOverlay();

      locationOverlay
        ..setPosition(nowPosition)
        ..setIsVisible(true);

      await Future.delayed(const Duration(milliseconds: 200));

      final nPoint = await controller.latLngToScreenLocation(nowPosition);
      final overlays1 = await controller
          .pickAll(nPoint, radius: 800)
          .then((e) => e.whereType<NOverlayInfo>());

      for (final overlay in overlays1) {
        print("[pickAll] $overlay");
      }

      expect(overlays1.length, overlaySet.length);

      await controller.clearOverlays(type: NOverlayType.marker);

      final overlays2 = await controller
          .pickAll(nPoint, radius: 800)
          .then((e) => e.whereType<NOverlayInfo>());
      expect(overlays2.length,
          overlaySet.length - overlaySet.whereType<NMarker>().length);

      await controller.clearOverlays();

      final overlays3 = await controller
          .pickAll(nPoint, radius: 800)
          .then((e) => e.whereType<NOverlayInfo>());
      expect(overlays3.length, 0);
    });
  });
}

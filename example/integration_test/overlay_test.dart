import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_naver_map_example/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> expectWithGetSet<T>({
    required T value,
    required Function(T) setMethod,
    required Future<T> Function() getMethod,
    required String name,
  }) async {
    final defaultValue = await getMethod();

    print("[$name] default value: $defaultValue (setValue: $value)");
    expect(defaultValue != value, true,
        reason: "[$name] default value should be different from $value");

    setMethod(value);
    final getValue = await getMethod();

    print("[$name] test : $value, $getValue");
    if (T == double) {
      final dValue = (value as double).toInt();
      final getDValue = (getValue as double).toInt();
      expect(dValue, getDValue, reason: "[$name] getValue should be $value");
    } else {
      expect(getValue, value, reason: "[$name] getValue should be $value");
    }
  }

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

      await expectWithGetSet(
          value: 30,
          setMethod: locationOverlay.setZIndex,
          getMethod: locationOverlay.getZIndex,
          name: "zIndex");

      await expectWithGetSet(
        value: 30,
        setMethod: locationOverlay.setGlobalZIndex,
        getMethod: locationOverlay.getGlobalZIndex,
        name: "globalZIndex",
      );

      await expectWithGetSet<String?>(
        value: "30",
        setMethod: (s) => locationOverlay.setTag(s!),
        getMethod: locationOverlay.getTag,
        name: "tag",
      );

      final isAdded = await locationOverlay.getIsAdded();
      print("[isAdded] $isAdded");
      expect(isAdded, true);

      await expectWithGetSet(
        value: true,
        setMethod: locationOverlay.setIsVisible,
        getMethod: locationOverlay.getIsVisible,
        name: "isVisible",
      );

      await expectWithGetSet(
        value: 10.0,
        setMethod: locationOverlay.setMinZoom,
        getMethod: locationOverlay.getMinZoom,
        name: "minZoom",
      );

      await expectWithGetSet(
        value: 15.0,
        setMethod: locationOverlay.setMaxZoom,
        getMethod: locationOverlay.getMaxZoom,
        name: "maxZoom",
      );

      await expectWithGetSet(
        value: false,
        setMethod: locationOverlay.setIsMinZoomInclusive,
        getMethod: locationOverlay.getIsMinZoomInclusive,
        name: "isMinZoomInclusive",
      );

      await expectWithGetSet(
        value: false,
        setMethod: locationOverlay.setIsMaxZoomInclusive,
        getMethod: locationOverlay.getIsMaxZoomInclusive,
        name: "isMaxZoomInclusive",
      );

      /*
        --- OnTapListener Test ---
      */
      final onDoneCompleter = Completer<NOverlayInfo>();

      locationOverlay.setOnTapListener(
          (overlay) => onDoneCompleter.complete(overlay.info));

      await locationOverlay.performClick();

      final completedOverlayInfo = await onDoneCompleter.future;

      print("[onTapListener] $completedOverlayInfo");
      expect(completedOverlayInfo, locationOverlay.info);
    });

    testWidgets('verify location overlay methods', (WidgetTester tester) async {
      await app.mainWithTest(testId);
      await tester.pumpAndSettle();

      final testPageState = getTestPageState(tester);
      final controller = await initializeNaverMap(testPageState);

      final locationOverlay = await controller.getLocationOverlay();
      expect(locationOverlay.info.type, NOverlayType.locationOverlay);

      await expectWithGetSet(
        value: const NPoint(0.2, 0.6),
        setMethod: locationOverlay.setAnchor,
        getMethod: locationOverlay.getAnchor,
        name: "anchor",
      );

      await expectWithGetSet(
        value: 30.0,
        setMethod: locationOverlay.setBearing,
        getMethod: locationOverlay.getBearing,
        name: "bearing",
      );

      await expectWithGetSet(
        value: const Color(0xFF0000FF),
        setMethod: locationOverlay.setCircleColor,
        getMethod: locationOverlay.getCircleColor,
        name: "circleColor",
      );

      await expectWithGetSet(
        value: const Color(0xFF00FF00),
        setMethod: locationOverlay.setCircleOutlineColor,
        getMethod: locationOverlay.getCircleOutlineColor,
        name: "circleOutlineColor",
      );

      await expectWithGetSet(
        value: 30.0,
        setMethod: locationOverlay.setCircleOutlineWidth,
        getMethod: locationOverlay.getCircleOutlineWidth,
        name: "circleOutlineWidth",
      );

      await expectWithGetSet(
        value: 30.0,
        setMethod: locationOverlay.setCircleRadius,
        getMethod: locationOverlay.getCircleRadius,
        name: "circleRadius",
      );

      await expectWithGetSet(
        value: const NSize(72, 48),
        setMethod: locationOverlay.setIconSize,
        getMethod: locationOverlay.getIconSize,
        name: "iconSize",
      );

      await expectWithGetSet(
        value: const NLatLng(37.508, 127.062),
        setMethod: locationOverlay.setPosition,
        getMethod: locationOverlay.getPosition,
        name: "position",
      );

      await expectWithGetSet(
        value: const NPoint(0.2, 0.6),
        setMethod: locationOverlay.setSubAnchor,
        getMethod: locationOverlay.getSubAnchor,
        name: "subAnchor",
      );

      await expectWithGetSet(
        value: const NSize(64, 80),
        setMethod: locationOverlay.setSubIconSize,
        getMethod: locationOverlay.getSubIconSize,
        name: "subIconSize",
      );
    });
  });
}

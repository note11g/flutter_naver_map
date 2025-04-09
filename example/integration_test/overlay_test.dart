import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

import 'util/test_util.dart';

@isTestGroup
void overlayTests() {
  group("location overlay tests", () {
    testNaverMap("location overlay onTap test", (controller, tester) async {
      final locationOverlay = controller.getLocationOverlay();
      expect(locationOverlay.info.type, NOverlayType.locationOverlay);

      final tappedVerifyCompleter = Completer<NOverlayInfo>();

      locationOverlay.setOnTapListener((overlay) {
        tappedVerifyCompleter.complete(overlay.info);
      });

      await locationOverlay.performClick();

      final completedOverlayInfo = await tappedVerifyCompleter.future;

      print("[onTapListener] $completedOverlayInfo");
      expect(completedOverlayInfo, locationOverlay.info);
    });

    testNaverMap("location overlay sync test", (controller, tester) async {
      final locationOverlay = controller.getLocationOverlay();
      expect(locationOverlay.info.type, NOverlayType.locationOverlay);

      locationOverlay.setIsVisible(true);

      final testPoints = [
        const NLatLng(37.497175, 127.027926),
        const NLatLng(37.484147, 127.034631),
        const NLatLng(37.470023, 127.038573),
        const NLatLng(37.447211, 127.055664),
        const NLatLng(37.394761, 127.111217),
        const NLatLng(37.367381, 127.108847),
      ];

      for (final point in testPoints) {
        locationOverlay.setPosition(point);
        expect(await locationOverlay.getPosition(), point);
      }

      for (double bearing = 359.0; bearing >= 30.0; bearing -= 0.5) {
        locationOverlay.setBearing(bearing);
        expect(await locationOverlay.getBearing(), bearing);
      }

      locationOverlay.setSubIcon(NLocationOverlay.faceModeSubIcon);

      await controller.updateCamera(
          NCameraUpdate.scrollAndZoomTo(target: testPoints.last)
            ..setAnimation(duration: Duration.zero));
      await Future.delayed(const Duration(seconds: 1));

      expectLatLng(controller.nowCameraPosition.target, testPoints.last);

      await tester.runGoldenTest(
          fileName: "golden/location_overlay_sync_test.png");
    });
  });

  testNaverMap('addable overlays add & pick test', (controller, tester) async {
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
        context: tester.testPageState.context);

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

  group("issue case test", () {
    /// #127 issue test (https://github.com/note11g/flutter_naver_map/issues/127)
    testNaverMap("AddableOverlay deletion test", (controller, tester) async {
      final marker = NMarker(id: "1", position: const NLatLng(127, 37));
      await controller.addOverlay(marker);
      await controller.deleteOverlay(marker.info);
      marker.setAlpha(0.5);
      expect(marker.alpha, 0.5);
    });

    /// #128 issue test  (https://github.com/note11g/flutter_naver_map/issues/128)
    testNaverMap("overlay with multiple map test",
        (map1Controller, tester) async {
      final marker = NMarker(id: "multi-1", position: const NLatLng(127, 37));
      await map1Controller.addOverlay(marker);
      marker.setAlpha(0.1);
      expect(marker.alpha, 0.1);

      final map2Controller =
          await createNewNaverMapPageForTest(tester, tag: "map2");
      await map2Controller.addOverlay(marker);
      marker.setAlpha(0.2);
      expect(marker.alpha, 0.2);
      await map2Controller.deleteOverlay(marker.info);

      final map3Controller =
          await createNewNaverMapPageForTest(tester, tag: "map3");
      marker.setAlpha(0.4);
      expect(marker.alpha, 0.4);
      await map3Controller.addOverlay(marker);
      marker.setAlpha(0.5);
      expect(marker.alpha, 0.5);
      await map3Controller.deleteOverlay(marker.info);
      marker.setAlpha(0.6);
      expect(marker.alpha, 0.6);
      await map1Controller.clearOverlays();
      marker.setAlpha(0.8);
      expect(marker.alpha, 0.8);
    });

    /// #154 issue test (https://github.com/note11g/flutter_naver_map/issues/154)
    testNaverMap("NInfoWindow.onMarker test", (controller, tester) async {
      final cameraTarget =
          await controller.getCameraPosition().then((cp) => cp.target);
      final marker = NMarker(id: "1", position: cameraTarget);
      await controller.addOverlay(marker);
      final infoWindow =
          NInfoWindow.onMarker(id: "2", text: "infowindow", offsetX: 0.1)
            ..setMinZoom(13);
      await marker.openInfoWindow(infoWindow);
      expect(infoWindow.offsetX, 0.1);
      expect(infoWindow.minZoom, 13);

      await Future.delayed(const Duration(milliseconds: 200));
      final screenTarget =
          await controller.latLngToScreenLocation(cameraTarget);

      Future<List<NOverlayInfo>> pickNOverlayInfo() {
        return controller
            .pickAll(screenTarget, radius: 800)
            .then((pickable) => pickable.whereType<NOverlayInfo>().toList());
      }

      final pickedInfoListByDefaultZoom = await pickNOverlayInfo();
      print(pickedInfoListByDefaultZoom);
      expect(pickedInfoListByDefaultZoom.contains(infoWindow.info), true);

      await controller.updateCamera(NCameraUpdate.scrollAndZoomTo(zoom: 12)
        ..setAnimation(duration: Duration.zero));

      await Future.delayed(const Duration(milliseconds: 200));

      final pickedInfoListWhenZoomOut = await pickNOverlayInfo();
      print(pickedInfoListWhenZoomOut);
      expect(pickedInfoListWhenZoomOut.contains(infoWindow.info), false);
    });
  });
}

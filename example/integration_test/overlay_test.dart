import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_test/flutter_test.dart';

import 'util/test_util.dart';

void main() {
  testNaverMap("location overlay onTap test", (controller, context) async {
    final locationOverlay = await controller.getLocationOverlay();
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

  testNaverMap('addable overlays add & pick test', (controller, context) async {
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
        context: context);

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
    testNaverMap("AddableOverlay deletion test", (controller, context) async {
      final nowCameraPosition = await controller.getCameraPosition();
      final marker = NMarker(id: "1", position: nowCameraPosition.target);
      await controller.addOverlay(marker);
      await controller.deleteOverlay(marker.info);
      marker.setAlpha(0.5);
      expect(marker.alpha, 0.5);
    });
  });
}

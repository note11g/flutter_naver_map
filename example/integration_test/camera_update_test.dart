import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

import 'util/test_util.dart';

@isTestGroup
void cameraUpdateTests() {
  testNaverMap("Camera Update With Reason Test", (controller, tester) async {
    (NCameraUpdateReason, bool)? lastMovedData;

    await Future.delayed(const Duration(milliseconds: 300));
    final onCameraChangeStreamSubscription = tester
        .testPageState.onCameraChangeStreamController.stream
        .listen((event) {
      lastMovedData = event;
      print("[moved] $event");
    });

    final cameraUpdate = NCameraUpdate.zoomIn()
      ..setAnimation(duration: Duration.zero)
      ..setReason(NCameraUpdateReason.control); // 위치 UI는 location.

    await controller.updateCamera(cameraUpdate);
    await Future.delayed(const Duration(milliseconds: 100));

    print(lastMovedData);

    expect(lastMovedData?.$1, NCameraUpdateReason.control);
    expect(lastMovedData?.$2, false);
    onCameraChangeStreamSubscription.cancel();
  });

  testNaverMap("nowCameraPositionStream emits latest camera data",
      (controller, tester) async {
    const expectedPosition = NCameraPosition(
        target: NLatLng(37.5651, 126.9783), zoom: 13, tilt: 0, bearing: 0);
    const expectedReason = NCameraUpdateReason.control;

    final movingEventFuture = controller.nowCameraPositionStream.firstWhere(
        (event) => event.reason == expectedReason && !event.isIdle);

    final idleEventFuture = controller.nowCameraPositionStream.firstWhere(
        (event) =>
            event.reason == expectedReason &&
            event.isIdle &&
            _isSameTarget(event.position.target, expectedPosition.target));

    final update = NCameraUpdate.withParams(
        target: expectedPosition.target, zoom: expectedPosition.zoom)
      ..setReason(expectedReason);

    await controller.updateCamera(update);

    final movingEvent =
        await movingEventFuture.timeout(const Duration(seconds: 5));
    final idleEvent =
        await idleEventFuture.timeout(const Duration(seconds: 5));

    expect(movingEvent.isIdle, isFalse);
    expectCameraPosition(idleEvent.position, expectedPosition);
    expect(idleEvent.reason, expectedReason);
    expectCameraPosition(controller.nowCameraPosition, expectedPosition);
    final fetchedPosition = await controller.getCameraPosition();
    expectCameraPosition(fetchedPosition, expectedPosition);
  });
}

bool _isSameTarget(NLatLng actual, NLatLng expected) {
  const threshold = 0.00001;
  return (actual.latitude - expected.latitude).abs() < threshold &&
      (actual.longitude - expected.longitude).abs() < threshold;
}

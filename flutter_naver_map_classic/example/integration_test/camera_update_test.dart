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
}

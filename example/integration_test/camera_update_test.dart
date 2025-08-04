import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

import 'util/test_util.dart';

void main() {
  cameraUpdateTests();
}

@isTestGroup
void cameraUpdateTests() {
  group("Camera Update Tests", () {
    testNaverMap("Camera Update With Reason Test", (controller, tester) async {
      (NCameraUpdateReason, bool)? lastMovedData;
      bool cameraUpdateReceived = false;

      // 스트림 리스너를 먼저 설정하여 초기 이벤트를 놓치지 않도록 함
      final onCameraChangeStreamSubscription = tester
          .testPageState.onCameraChangeStreamController.stream
          .listen((event) {
        lastMovedData = event;
        cameraUpdateReceived = true;
        print("[moved] $event");
      });

      // 맵 초기화 완료를 위한 충분한 대기 시간
      await Future.delayed(const Duration(milliseconds: 500));

      final cameraUpdate = NCameraUpdate.zoomIn()
        ..setAnimation(duration: Duration.zero)
        ..setReason(NCameraUpdateReason.control); // 위치 UI는 location.

      print("Updating camera with reason: ${NCameraUpdateReason.control}");
      await controller.updateCamera(cameraUpdate);

      // 카메라 업데이트 이벤트를 받을 때까지 대기 (최대 3초)
      int attempts = 0;
      const maxAttempts = 30; // 3초 (100ms * 30)
      while (!cameraUpdateReceived && attempts < maxAttempts) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
        print("Waiting for camera update event... attempt: $attempts");
      }

      print(
          "Camera update received: $cameraUpdateReceived, data: $lastMovedData");

      expect(cameraUpdateReceived, true,
          reason:
              "Camera update event should be received within timeout period");
      expect(lastMovedData?.$1, NCameraUpdateReason.control);
      expect(lastMovedData?.$2, false);
      onCameraChangeStreamSubscription.cancel();
    });
  });
}

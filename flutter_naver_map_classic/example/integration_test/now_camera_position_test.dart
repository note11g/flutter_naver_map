import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

import 'util/test_util.dart';

@isTestGroup
void nowCameraPositionTests() {
  testNaverMap("now Camera position test", (controller, tester) async {
    final NCameraPosition cameraPositionFromFlutter =
        controller.nowCameraPosition;
    final cameraPositionFromPlatform = await controller.getCameraPosition();

    // 오차범위 존재. 32bit 미만 자를 수 있는지 검토 필요.
    expectCameraPosition(cameraPositionFromFlutter, cameraPositionFromPlatform);

    const position1 =
        NCameraPosition(target: NLatLng(37.21312, 127.02321), zoom: 20);
    await controller.updateCamera(NCameraUpdate.fromCameraPosition(position1)
      ..setAnimation(duration: Duration.zero));
    print("future completed: ${DateTime.now().millisecondsSinceEpoch}");

    // iOS에서만 모두 이동되지 않았음에도 Future Complete 됨. Report needed.
    // (onCameraIdle) - (FutureComplete)
    // 3s animation : 76ms(ios) / 2ms(android),
    // 0s animation : 79ms(ios) / 1ms(android)
    await Future.delayed(const Duration(milliseconds: 200));

    expectCameraPosition(controller.nowCameraPosition, position1);
    final cameraPositionFromPlatform2 = await controller.getCameraPosition();
    expectCameraPosition(
        controller.nowCameraPosition, cameraPositionFromPlatform2);
  });
}

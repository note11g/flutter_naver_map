import 'dart:async';

import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

import 'util/test_util.dart';

@isTestGroup
void clusteringTests() {
  group("clustering tests", () {
    testNaverMap("clustering marker setOnTapListener test",
        (controller, tester) async {
      final clusterableMarker = NClusterableMarker(
        id: "test",
        position: controller.nowCameraPosition.target,
      );

      final completer = Completer<NClusterableMarkerInfo>();
      clusterableMarker.setOnTapListener((cm) => completer.complete(cm.info));

      await controller.addOverlay(clusterableMarker);
      await tester.flutterWidgetTester.pumpAndSettle();

      await clusterableMarker.performClick();

      final tappedInfo = await completer.future;
      print("Tapped info: $tappedInfo");
      expect(tappedInfo, clusterableMarker.info);
    });
  });
}

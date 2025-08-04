import 'dart:async';

import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

import 'util/test_util.dart';

void main() {
  clusteringTests();
}

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
      await tester.pumpAndSettleOnMap();

      await clusterableMarker.performClick();

      final tappedInfo = await completer.future;
      print("Tapped info: $tappedInfo");
      expect(tappedInfo, clusterableMarker.info);
    });

    testNaverMap("clustering marker after clear all overlays (issue #342)",
        (controller, tester) async {
      final NCameraPosition(target: currentPosition, :zoom) =
          controller.nowCameraPosition;
      final fourteenMeterToLogicalPixel = controller.getMeterPerDpAtLatitude(
          latitude: currentPosition.latitude, zoom: zoom);
      const centerOfCurrentPosition = NPoint(150, 150);

      final tenClusterableMarkers = List<NClusterableMarker>.generate(
        10,
        (index) => NClusterableMarker(
          id: "test_$index",
          position: currentPosition.offsetByMeter(
              eastMeter: (index % 2 == 0 ? index.toDouble() : 0.0) * 20.0,
              northMeter: (index % 2 == 1 ? index.toDouble() : 0.0) * -20.0),
        ),
      );
      await controller.addOverlayAll(tenClusterableMarkers.toSet());
      await tester.pumpAndSettleOnMap();

      // Check if markers are clustered
      final infos = await controller.pickAll(
        centerOfCurrentPosition,
        radius: fourteenMeterToLogicalPixel * 2,
      );

      print(infos);
      expect(infos.firstOrNull, isA<NOverlayInfo>());
      expect((infos.firstOrNull as NOverlayInfo?)?.type,
          NOverlayType.clusterableMarker);

      await controller.clearOverlays();
      await tester.pumpAndSettleOnMap();

      final newClusterableMarkers = tenClusterableMarkers.map(
        (marker) => NClusterableMarker(
          id: marker.info.id,
          position: marker.position,
        ),
      );

      await controller.addOverlayAll(newClusterableMarkers.toSet());
      await tester.pumpAndSettleOnMap();

      final newInfos = await controller.pickAll(
        centerOfCurrentPosition,
        radius: fourteenMeterToLogicalPixel * 2,
      );

      print(newInfos);
      expect(newInfos.firstOrNull, isA<NOverlayInfo>());
      expect((newInfos.firstOrNull as NOverlayInfo?)?.type,
          NOverlayType.clusterableMarker);
    });
  });
}

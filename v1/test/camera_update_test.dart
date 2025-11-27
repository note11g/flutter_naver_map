import "package:flutter_naver_map/flutter_naver_map.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  test("cameraUpdateTest", () {
    const target1 = NLatLng(37.5666102, 126.9783881);
    const zoom1 = 17.0;
    const tilt1 = 30.0;
    const bearing1 = 45.0;
    final cu1 = NCameraUpdate.withParams(
        tilt: tilt1, zoom: zoom1, bearing: bearing1, target: target1);

    expect(cu1.toString(),
        "NCameraUpdate: {target: {lat: ${target1.latitude}, lng: ${target1.longitude}}, zoom: $zoom1, tilt: $tilt1, bearing: $bearing1, animation: easing, duration: 800, sign: withParams}");

    const target2 = NLatLng(37.5662, 126.97);
    const zoom2 = 17.0;
    const tilt2 = 30.0;
    const bearing2 = 45.0;
    final cu2 = NCameraUpdate.withParams(
        tiltBy: tilt2, zoomBy: zoom2, bearingBy: bearing2, target: target2);

    expect(cu2.toString(),
        "NCameraUpdate: {target: {lat: ${target2.latitude}, lng: ${target2.longitude}}, zoomBy: $zoom2, tiltBy: $tilt2, bearingBy: $bearing2, animation: easing, duration: 800, sign: withParams}");
  });

  test("cameraUpdateAssertionTest", () {
    try {
      final cu = NCameraUpdate.withParams(tilt: 1, zoom: 1, zoomBy: 1);
      expect(cu, 1);
    } catch (e) {
      expect(e.runtimeType.toString(), "_AssertionError");
    }
  });
}

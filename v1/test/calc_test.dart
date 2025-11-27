import "package:flutter_naver_map/flutter_naver_map.dart";
import "package:flutter_naver_map/src/util/math.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  test("create random latlng test", () {
    // 계산 오차 허용 범위 1000dp 기준으로 측정시 0.1mm
    expect(MathUtil.calcMeterPerDp(37.566658794690994, 11),
        closeTo(30.29369736797371, 0.0000001)); // 0.01m == 1cm,
    expect(MathUtil.calcMeterPerDp(37.58233329511972, 15.111723569204258),
        closeTo(1.751897698224819, 0.0000001));
    expect(MathUtil.calcMeterPerDp(33.117793960720206, 16.180300007459696),
        closeTo(0.8827919701389101, 0.0000001));

    /// 32bit float test (latlng)
    const originLat1 = NLatLng.maximumLatitude - 0.01;
    const originLat2 = 43.00972;
    // worst case: lat=90, zoomLevel=0 (NLatLng.maximumLatitude, NaverMapViewOptions.minimumZoom)
    // 약 13.661m/dp (±0.0013661m), 1000dp 기준 오차범위 ±0.1dp (pixelRatio ≦ 3일때, < 0.5 hardware pixel)
    // 대한민국 기준 worst case: lat=43.00972 (한반도 최북단, 출처: https://library.krihs.re.kr/local/html/landGuide)
    // 약 57235.1m/dp (±0.0009318m), 1000dp 기준 오차범위 ±0.0163dp
    //
    // 따라서, 테스트 허용 오차범위는 worst 값인 ±0.0014m로 설정.
    final original1 =
        MathUtil.calcMeterPerDp(originLat1, NaverMapViewOptions.minimumZoom);
    final margined1 = MathUtil.calcMeterPerDp(
        originLat1 + 0.000001, NaverMapViewOptions.minimumZoom);
    expect(margined1, closeTo(original1, 0.0014));

    final original2 =
        MathUtil.calcMeterPerDp(originLat2, NaverMapViewOptions.minimumZoom);
    final margined2 = MathUtil.calcMeterPerDp(
        originLat2 + 0.000001, NaverMapViewOptions.minimumZoom);
    expect(margined2, closeTo(original2, 0.001));
  });
}

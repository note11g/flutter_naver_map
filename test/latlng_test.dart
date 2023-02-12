import "dart:math";

import "package:flutter_naver_map/flutter_naver_map.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  NLatLng createRandomLatLng() {
    final randomLatitude = (Random().nextDouble() * 180) - 90;
    final randomLongitude = (Random().nextDouble() * 360) - 180;

    return NLatLng(randomLatitude, randomLongitude);
  }

  bool isValidLatLng(NLatLng latLng) {
    final latitudeValid = (-90 <= latLng.latitude) && (latLng.latitude <= 90);
    final longitudeValid =
        (-180 <= latLng.longitude) && (latLng.longitude <= 180);

    return latitudeValid && longitudeValid;
  }

  test("create random latlng test", () {
    for (int i = 0; i < 30000; i++) {
      final randomLatLng = createRandomLatLng();
      final isValid = isValidLatLng(randomLatLng);
      expect(isValid, true);
    }
  });

  test("create latlng bounds test 1", () {
    const northEast = NLatLng(70, 20);
    const mid1 = NLatLng(70, 16.6);
    const mid2 = NLatLng(60, 10);
    const southWest = NLatLng(58, 10);

    expect(isValidLatLng(northEast), true);
    expect(isValidLatLng(mid1), true);
    expect(isValidLatLng(mid2), true);
    expect(isValidLatLng(southWest), true);

    final latLngBounds = NLatLngBounds.from([northEast, southWest, mid1, mid2]);

    expect(latLngBounds.southWest, southWest);
    expect(latLngBounds.northEast, northEast);
  });

  test("create latlng bounds test 2", () {
    final List<NLatLng> points = [];

    double maxLatitude = -90;
    double minLatitude = 90;
    double maxLongitude = -180;
    double minLongitude = 180;

    for (int i = 0; i < 30000; i++) {
      final randomLatLng = createRandomLatLng();

      if (randomLatLng.latitude > maxLatitude) {
        maxLatitude = randomLatLng.latitude;
      }

      if (randomLatLng.longitude > maxLongitude) {
        maxLongitude = randomLatLng.longitude;
      }

      if (randomLatLng.latitude < minLatitude) {
        minLatitude = randomLatLng.latitude;
      }

      if (randomLatLng.longitude < minLongitude) {
        minLongitude = randomLatLng.longitude;
      }

      points.add(randomLatLng);
    }

    final latLngBounds = NLatLngBounds.from(points);
    expect(latLngBounds.northEast, NLatLng(maxLatitude, maxLongitude));
    expect(latLngBounds.southWest, NLatLng(minLatitude, minLongitude));
  });

  test("type test", () {
    // final json = boundsToJson(LatLng.worldCoverage);
    // print(json);
    //
    // expect(json['southWest'] is Map<String, dynamic>, true);
  });
}

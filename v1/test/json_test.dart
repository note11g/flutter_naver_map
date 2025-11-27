import "package:flutter_naver_map/flutter_naver_map.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  test("option type test", () {
    const option = NaverMapViewOptions(activeLayerGroups: [
      NLayerGroup.transit,
      NLayerGroup.bicycle,
      NLayerGroup.traffic,
      NLayerGroup.cadastral
    ]);

    expect(option.activeLayerGroups, [
      NLayerGroup.transit,
      NLayerGroup.bicycle,
      NLayerGroup.traffic,
      NLayerGroup.cadastral
    ]);
  });
}

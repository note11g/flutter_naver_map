part of "../../../../../flutter_naver_map.dart";

@immutable
class NClusterMergeStrategy {
  // mergeByEachTagEnableZoomLevel: <String, NMapRange>{
  // "gu": NMapRange(11, 13, includeMax: false), // 11 <= range < 13
  // "dong": NMapRange(13, 15), // 13 <= range <= 15
  // "something1": NMapRange(null, 11, includeMax: false),
  // "something2": NMapRange(15, null, includeMin: false),
  // },
  final Map<String, NRange> mergeByEachTagEnableZoomLevel;

  /// 마커간의 거리가 70dp 이하인 경우 병합
  ///
  /// [mergeByEachTagEnableZoomLevel]으로 인한 태그 병합이 이루어질 경우, 무시됩니다.
  ///
  /// 기본 값은 70dp.
  final double willMergedScreenDistance;

  /// 태그로 병합될 수 있는 가장 먼 마커간의 거리를 지정합니다.
  ///
  /// 기본 값은 화면의 가로 세로 중 작은 길이를 가진 변의 2 / 3을 뜻하는 `twoThirdOfMinScreenSizeFlag` 입니다.
  ///
  /// [twoThirdOfMinScreenSizeFlag] = (`(min(screenW, screenH) * 2 / 3)`dp로 계산됨)
  final double maxMergedScreenDistanceByTag;

  /// 클러스터링을 할 수 있는 마커의 최소 개수를 지정합니다.
  ///
  /// 이 값보다 작은 개수의 마커는 클러스터하지 않습니다.
  ///
  /// 클러스터링은 마커 여러 개를 묶는 것이므로, 2 미만의 수는 무시됩니다.
  ///
  /// 기본 값은 제한을 가지지 않는 `2` 입니다.
  // @Min(2)
  final int minClusterChildCount;

  const NClusterMergeStrategy({
    this.mergeByEachTagEnableZoomLevel = const <String, NRange>{},
    this.maxMergedScreenDistanceByTag = twoThirdOfMinScreenSizeFlag,
    this.willMergedScreenDistance = 70,
    this.minClusterChildCount = 2,
  }): assert(minClusterChildCount >= 2);

  static const twoThirdOfMinScreenSizeFlag = -1.0;
}

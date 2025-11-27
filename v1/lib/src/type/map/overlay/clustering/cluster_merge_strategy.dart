part of "../../../../../flutter_naver_map.dart";

@immutable
class NClusterMergeStrategy with NMessageableWithMap {
  // mergeByEachTagEnableZoomLevel: <String, NMapRange>{
  // "gu": NMapRange(11, 13, includeMax: false), // 11 <= range < 13
  // "dong": NMapRange(13, 15), // 13 <= range <= 15
  // "something1": NMapRange(null, 11, includeMax: false),
  // "something2": NMapRange(15, null, includeMin: false),
  // },
  // final Map<String, NInclusiveRange<int>> mergeByEachTagEnableZoomRanges;

//  /// 마커간의 거리가 70dp 이하인 경우 병합
//  ///
//  /// [mergeByEachTagEnableZoomLevel]으로 인한 태그 병합이 이루어질 경우, 무시됩니다.
  ///
  /// 마커가 화면상에서 병합될 수 있는 거리를 지정합니다.
  ///
  /// 해당 거리보다 가까운 마커는 병합됩니다.
  ///
  /// 줌 레벨에 따라 다른 거리를 지정할 수 있습니다.
  ///
  /// 지정되지 않은 범위의 경우, 기본 값이 적용됩니다. (70dp)
  ///
  /// 기본 값은 모든 줌 범위에서 거리가 70dp 미만의 마커는 병합한다는 기본 전략을 뜻하는 `{}` 입니다.
  ///
  /// example
  ///
  /// ```dart
  /// {
  ///    NInclusiveRange(0, 5): 100.0, // 0.0 <= zoom < 6.0 일 때 100dp 이하인 마커는 병합
  ///    NInclusiveRange(6, 10): 50.0, // 6.0 <= zoom < 11.0 일 때 50dp 이하인 마커는 병합
  ///    NInclusiveRange(18, null): 35.0, // 18.0 <= zoom 일 때 35dp 이하인 마커는 병합
  ///    // 이외의 줌레벨(11.0 이상)에는 70dp 이하인 마커는 병합
  /// }
  /// ```
  ///
  /// 겹치는 범위가 있을 경우, 먼저 선언된 범위가 우선됩니다. (switch-case 문과 유사)
  final Map<NInclusiveRange<int>, double> willMergedScreenDistance;

  /// 병합될 수 있는 가장 먼 마커간의 화면 상의 거리를 지정합니다.
  ///
  /// 이 값보다 먼 거리에 있는 마커는 병합되지 않습니다. (탐색 공간을 제한하여, 성능을 향상시킵니다.)
  ///
  /// 기본 값은 70dp.
  final double maxMergeableScreenDistance;

  // /// 클러스터링을 할 수 있는 마커의 최소 개수를 지정합니다.
  // ///
  // /// 이 값보다 작은 개수의 마커는 클러스터하지 않습니다.
  // ///
  // /// 클러스터링은 마커 여러 개를 묶는 것이므로, 2 미만의 수는 무시됩니다.
  // ///
  // /// 기본 값은 제한을 가지지 않는 `2` 입니다.
  // // @Min(2)
  // final int minClusterChildCount;

  const NClusterMergeStrategy({
    // this.mergeByEachTagEnableZoomRanges = const {},
    this.maxMergeableScreenDistance = 70,
    this.willMergedScreenDistance = const {},
    // this.minClusterChildCount = 2,
  }) /*: assert(minClusterChildCount >= 2)*/;

  @override
  NPayload toNPayload() => NPayload.make({
        // "mergeByEachTagEnableZoomRanges": mergeByEachTagEnableZoomRanges,
        "willMergedScreenDistance": willMergedScreenDistance,
        "maxMergeableScreenDistance": maxMergeableScreenDistance,
        // "minClusterChildCount": minClusterChildCount,
      });

  @override
  String toString() => "$runtimeType: ${toNPayload().map}";

  NClusterMergeStrategy copyWith({
    // Map<String, NInclusiveRange<int>>? mergeByEachTagEnableZoomRanges,
    Map<NInclusiveRange<int>, double>? willMergedScreenDistance,
    double? maxMergeableScreenDistance,
    // int? minClusterChildCount,
  }) =>
      NClusterMergeStrategy(
        // mergeByEachTagEnableZoomRanges:
        // mergeByEachTagEnableZoomRanges ?? this.mergeByEachTagEnableZoomRanges,
        willMergedScreenDistance:
            willMergedScreenDistance ?? this.willMergedScreenDistance,
        maxMergeableScreenDistance:
            maxMergeableScreenDistance ?? this.maxMergeableScreenDistance,
        // minClusterChildCount: minClusterChildCount ?? this.minClusterChildCount,
      );

//region equals & hashCode

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NClusterMergeStrategy &&
          runtimeType == other.runtimeType &&
          // mergeByEachTagEnableZoomRanges ==
          //     other.mergeByEachTagEnableZoomRanges &&
          willMergedScreenDistance == other.willMergedScreenDistance &&
          maxMergeableScreenDistance == other.maxMergeableScreenDistance
      // && minClusterChildCount == other.minClusterChildCount
      ;

  @override
  int get hashCode =>
      // mergeByEachTagEnableZoomRanges.hashCode ^
      willMergedScreenDistance.hashCode ^ maxMergeableScreenDistance.hashCode
      // ^ minClusterChildCount.hashCode
      ;

//endregion
}

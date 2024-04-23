part of "../../../../../flutter_naver_map.dart";

/// 클러스터링 기능에 대한 옵션들입니다.
class NaverMapClusterOptions {
  /// 클러스터링 기능이 활성화 될 줌 범위를 지정합니다.
  ///
  /// 기본 값은 기본 줌 범위를 의미하는 [NRange.mapZoomRange].
  final NRange enableZoomLevel;

  /// 클러스터링이 이루어질 때 애니메이션을 실행할 지 여부를 나타냅니다.
  ///
  /// 기본 값은 `true`.
  final bool animate;

  /// 클러스터링 기능이 활성화 될 줌 범위를 지정합니다.
  ///
  /// 기본 값은 ``.
  final NClusterMergeStrategy mergeStrategy;


  /// 클러스터 마커의 속성을 지정할 수 있습니다.
  ///
  /// 기본 값은 null이며, 이때는 기본적으로 [NaverMapClusterOptions.defaultClusterMarkerBuilder]가 실행됩니다.
  final Function(NClusterInfo info, NClusterMarker clusterMarker)?
      clusterMarkerBuilder;

  const NaverMapClusterOptions({
    this.enableZoomLevel = NRange.mapZoomRange,
    this.animate = true,
    this.mergeStrategy = const NClusterMergeStrategy(),
    this.clusterMarkerBuilder,
  });

  static void defaultClusterMarkerBuilder(
      NClusterInfo info, NClusterMarker clusterMarker) {
    clusterMarker.setCaption(NOverlayCaption(
      text: info.size.toString(),
      color: Colors.white,
      haloColor: Colors.transparent,
    ));
  }
}

part of "../../../../../flutter_naver_map.dart";

/// 너무 많은 마커가 몰려 있을 때, 사용자 경험과 지도의 성능을 향상시키기 위해 클러스터링 기능을 사용하면,
/// 실제 장소를 나타내는 마커([NClusterableMarker]) 여러 개를 대신하여 볼 수 있는 클러스터 마커입니다.
///
/// `NaverMap.clusterOptions.mergeStrategy`에 따라, 여러 개의 [NClusterableMarker] 대신 [NClusterMarker]로 병합할 지 전략을 지정할 수 있습니다.
///
/// NClusterMarker 는 라이브러리에 의해 자동으로 생성되며, 직접 생성할 수 없습니다.
///
/// `NaverMap.clusterOptions.clusterMarkerBuilder`를 통해, 커스텀할 수 있습니다.
class NClusterMarker extends _NMarkerWrapper<NClusterMarker> {
  NClusterMarker._({
    required super.id,
    required super.position,
  }) : super(type: NOverlayType.clusterableMarker) {
    _captionAligns = const [NAlign.center];
    _anchor = NPoint.relativeCenter;
  }

  Future<void> _apply(_NOverlayController overlayController) async {
    setIsVisible(true);
    _addedOnMap(overlayController); // TODO: 삭제시 핸들링 유지 유무 확인
    _send("lSyncClusterMarker", this);
  }

  /// 캡션이 어디에 위치하는 지 나타냅니다.
  ///
  /// 캡션이 겹칠 때를 대비하여, index가 0에 가까운 아이템 순서대로 우선하여 캡션을 위치합니다.
  ///
  /// 캡션이 겹칠 때, 숨기는 옵션인 [isHideCollidedCaptions]가 활성화된다면, 첫번째 요소만 참고합니다.
  ///
  /// 클러스터 마커의 기본 값은 아이콘의 중앙에 위치함을 의미하는 [NAlign.center]입니다.
  @override
  List<NAlign> get captionAligns => super.captionAligns;

  /// 캡션이 어디에 위치할 지 지정합니다.
  ///
  /// 캡션이 겹칠 때를 대비하여, index가 0에 가까운 아이템 순서대로 우선하여 캡션을 위치합니다.
  ///
  /// 캡션이 겹칠 때, 숨기는 옵션인 [isHideCollidedCaptions]가 활성화된다면, 첫번째 요소만 참고합니다.
  ///
  /// 클러스터 마커의 기본 값은 아이콘의 중앙에 위치함을 의미하는 [NAlign.center]입니다.
  @override
  void setCaptionAligns(Iterable<NAlign> value) =>
      super.setCaptionAligns(value);

  /// 좌표가 아이콘의 어느 지점에 위치하는 지인 기준점을 나타냅니다.
  /// 값 범위는 (0, 0) ~ (1, 1)입니다.
  ///
  /// 클러스터 마커의 anchor 기본 값은 중앙을 나타내는 [NPoint.relativeCenter]입니다.
  @override
  NPoint get anchor => super.anchor;

  /// 좌표가 아이콘의 어느 지점에 위치하는 지인 기준점을 지정합니다.
  /// 값 범위는 좌측 상단(0, 0) ~ 우측하단(1, 1)입니다.
  ///
  /// 클러스터 마커의 anchor 기본 값은 중앙을 나타내는 [NPoint.relativeCenter]입니다.
  @override
  void setAnchor(NPoint value) => super.setAnchor(value);
}

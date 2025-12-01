part of "../../../../../flutter_naver_map.dart";

/// 너무 많은 마커가 몰려 있을 때, 사용자 경험과 지도의 성능을 향상시키기 위해 클러스터링 기능을 사용할 수 있는 마커입니다.
///
/// 기존 `NMarker`를 대신하여 [NaverMapController.addOverlay] 혹은 [NaverMapController.addOverlayAll]을 통해 지도에 추가하면 됩니다.
///
/// `NaverMap.clusterOptions.mergeStrategy`에 따라, 여러 개의 [NClusterableMarker] 대신 [NClusterMarker]로 병합할 지 전략을 지정할 수 있습니다.
class NClusterableMarker extends _NMarkerWrapper<NClusterableMarker> {
  // todo: 병합 전략 설명 추가
  /// `NClusterableMarker`의 태그를 지정할 수 있습니다.
  ///
  /// 이 태그에 따라, 여러 개의 클러스터블 마커를 [NClusterMarker]로 어떻게 병합할 지 전략을 지정할 수도 있습니다.

  @override
  NClusterableMarkerInfo get info =>
      NClusterableMarkerInfo(id: super.info.id, tags: tags, position: position);

  final Map<String, String> tags;

  NClusterableMarker({
    required super.id,
    required super.position,
    this.tags = const {},
    super.icon,
    super.iconTintColor,
    super.alpha,
    super.angle,
    super.anchor,
    super.size,
    super.caption,
    super.subCaption,
    super.captionAligns,
    super.captionOffset,
    super.isCaptionPerspectiveEnabled,
    super.isIconPerspectiveEnabled,
    super.isFlat,
    super.isForceShowCaption,
    super.isForceShowIcon,
    super.isHideCollidedCaptions,
    super.isHideCollidedMarkers,
    super.isHideCollidedSymbols,
  }) : super(type: NOverlayType.clusterableMarker);

  @override
  NPayload toNPayload() {
    return super.toNPayload().expandWith({
      "info": info,
    });
  }
}

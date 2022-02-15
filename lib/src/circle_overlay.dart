part of flutter_naver_map;

/// <p>원형 오버레이를 지도 위에 표시하기 위해 사용되는 객체</p>
class CircleOverlay {
  /// <h3>원형 오버레이의 식별자로 사용됩니다.</h3>
  final String overlayId;

  /// <h3>원형 오버레이의 중심점</h3>
  LatLng? center;

  /// <h3>원형 오버레이의 반지름</h3>
  double radius;

  /// <h3>원형 오버레이의 중심부의 색갈</h3>
  Color? color;

  /// <h3>원형 오버레이의 외곽선 색갈</h3>
  Color? outlineColor;

  /// <h3>원형 오버레이의 외곽선의 두께</h3>
  int? outlineWidth;

  /// <h3>원형 오버레이 z-index</h3>
  int? zIndex;

  /// <h3>원형 오버레이 전역 z-index</h3>
  int? globalZIndex;

  /// <h3>지도에 표시되는 최소 줌크기</h3>
  /// <p>[minZoom]이나 [maxZoom]이 설정되면 지도의 줌에 따라 원형 오버레이의 <br/>
  /// visible 상태가 변경된다.</p>
  /// <p>지도의 줌이 [minZoom]보다 크고 [maxZoom]보다 작을때 오버레이 표시</p>
  double? minZoom;

  /// <h3>지도에 표시되는 최대 줌크기</h3>
  /// <p>[minZoom]이나 [maxZoom]이 설정되면 지도의 줌에 따라 원형 오버레이의 <br/>
  /// visible 상태가 변경된다.</p>
  /// <p>지도의 줌이 [minZoom]보다 크고 [maxZoom]보다 작을때 오버레이 표시</p>
  double? maxZoom;

  /// <h3>원형 오버레이가 눌러졌을 때</h3>
  final void Function(String overlayId)? onTap;

  CircleOverlay({
    required this.overlayId,
    required this.center,
    required this.radius,
    this.color,
    this.outlineColor,
    this.outlineWidth,
    this.zIndex,
    this.globalZIndex,
    this.onTap,
    this.minZoom,
    this.maxZoom,
  });

  @override
  int get hashCode => overlayId.hashCode;

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    return other is CircleOverlay
        ? overlayId == other.overlayId &&
            center == other.center &&
            radius == other.radius &&
            color == other.color &&
            outlineColor == other.color &&
            outlineWidth == other.outlineWidth &&
            zIndex == other.zIndex &&
            globalZIndex == other.globalZIndex &&
            minZoom == other.minZoom &&
            maxZoom == other.maxZoom
        : false;
  }

  @override
  String toString() => _toJson().toString();

  CircleOverlay clone() => CircleOverlay(
        overlayId: overlayId,
        center: center,
        radius: radius,
        color: color,
        outlineColor: outlineColor,
        outlineWidth: outlineWidth,
        zIndex: zIndex,
        globalZIndex: globalZIndex,
        onTap: onTap,
        minZoom: minZoom,
        maxZoom: maxZoom,
      );

  Map<String, dynamic> _toJson() {
    final Map<String, dynamic> json = {};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('overlayId', overlayId);
    addIfPresent('center', center?._toJson());
    addIfPresent('radius', radius);
    addIfPresent('color', color?.value);
    addIfPresent('outlineColor', outlineColor?.value);
    addIfPresent('outlineWidth', outlineWidth);
    addIfPresent('zIndex', zIndex);
    addIfPresent('globalZIndex', globalZIndex);
    addIfPresent('minZoom', minZoom);
    addIfPresent('maxZoom', maxZoom);
    return json;
  }
}

List<Map<String, dynamic>>? _serializeCircleSet(
    Iterable<CircleOverlay?>? circles) {
  if (circles == null) return null;
  return circles.map<Map<String, dynamic>>((e) => e!._toJson()).toList();
}

Map<String, CircleOverlay> _keyByCircleId(Iterable<CircleOverlay> circles) {
  return Map<String, CircleOverlay>.fromEntries(circles
      .map((e) => MapEntry<String, CircleOverlay>(e.overlayId, e.clone())));
}

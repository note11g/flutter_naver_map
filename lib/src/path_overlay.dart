part of flutter_naver_map;

/// [NaverMap]의 [PathOverlay]에 대한 유일 식별자
///
/// 전역적으로 유일할 필요는 없으며 목록상에서 유일하면 된다.
@immutable
class PathOverlayId {
  PathOverlayId(this.value);

  final String value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is PathOverlayId && value == other.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return 'PathOverlayId{value: $value}';
  }
}

/// 지도에 경로선을 나타내는 오버레이.
///
/// 하나의 선을 나타낸다는 측면에서는 [PolylineOverlay]와 유사하나, 다음과 같이 경로선에 특화된 특징이 있습니다.
/// * 테두리와 패턴 이미지를 적용할 수 있습니다.
/// * 지도를 기울이더라도 두께가 일정하게 유지됩니다.
/// * 자기교차(self-intersection)가 일어나더라도 테두리, 패턴 이미지가 자연스럽게 나타납니다.
/// * 진척률을 지정할 수 있으며, 지나온/지나갈 경로에 각각 다른 색상과 테두리를 지정할 수 있습니다.
/// * 충돌하는 마커 및 심벌을 숨길 수 있습니다.
/// * 점선 패턴, 끝 지점/연결점의 모양은 지정할 수 없습니다.
class PathOverlay {
  /// 기본 전역 Z 인덱스.
  static const int defaultGlobalZIndex = -100000;

  /// [PathOverlayId]의 유일 식별자.
  ///
  /// null일 수 없습니다.
  final PathOverlayId pathOverlayId;

  /// 좌표열을 지정합니다.
  ///
  /// null이거나 [List.length]가 2 미만일 수 없습니다.
  List<LatLng> coords;

  ///  전역 Z 인덱스를 지정합니다.
  ///
  ///  여러 오버레이가 화면에서 겹쳐지면 전역 Z 인덱스가 큰 오버레이가 작은 오버레이를 덮습니다. 또한 값이 0 이상이면 오버레이가 심벌 위에, 0 미만이면 심벌 아래에 그려집니다.
  ///  기본값은 [defaultGlobalZIndex]입니다.
  int globalZIndex;

  /// 경로선과 마커의 캡션이 겹칠 경우 마커의 캡션을 숨길지 여부를 지정합니다.
  ///
  /// 기본값은 false입니다.
  bool hideCollidedCaptions;

  /// 경로선과 마커가 겹칠 경우 마커를 숨길지 여부를 지정합니다.
  ///
  /// 기본값은 false입니다.
  bool hideCollidedMarkers;

  /// 경로선과 지도 심벌이 겹칠 경우 지도 심벌을 숨길지 여부를 지정합니다.
  ///
  /// 기본값은 false입니다.
  bool hideCollidedSymbols;

  /// 경로선의 색상을 지정합니다.
  ///
  /// 경로선의 색상은 반투명일 수 없으며, 완전히 투명하거나 완전히 불투명해야 합니다. 색상의 알파가 0이 아닌 경우 완전히 불투명한 것으로 간주됩니다. 색상이 투명할 경우 테두리도 그려지지 않습니다.
  /// 기본값은 [Colors.white]입니다.
  Color color;

  /// 경로선의 테두리 색상을 지정합니다.
  ///
  /// 경로선의 테두리 색상은 반투명일 수 없으며, 완전히 투명하거나 완전히 불투명해야 합니다. 색상의 알파가 0이 아닌 경우 완전히 불투명한 것으로 간주됩니다.
  /// 기본값은 [Colors.black]입니다.
  Color outlineColor;

  /// 테두리의 두께를 지정합니다.
  ///
  /// 0일 경우 테두리가 그려지지 않습니다.
  /// 기본값은 2입니다.
  /// <p>단위는 상대크기 단위입니다.</p>
  int outlineWidth;

  /// 지나온 경로선의 색상을 지정합니다.
  ///
  /// 지나온 경로선의 색상은 반투명일 수 없으며, 완전히 투명하거나 완전히 불투명해야 합니다. 색상의 알파가 0이 아닌 경우 완전히 불투명한 것으로 간주됩니다. 색상이 투명할 경우 테두리도 그려지지 않습니다.
  /// 기본값은 [Colors.white]입니다.
  Color passedColor;

  /// 지나온 경로선의 테두리 색상을 지정합니다.
  ///
  /// 지나온 경로선의 테두리 색상은 반투명일 수 없으며, 완전히 투명하거나 완전히 불투명해야 합니다. 색상의 알파가 0이 아닌 경우 완전히 불투명한 것으로 간주됩니다.
  /// 기본값은 [Colors.black]입니다.
  Color passedOutlineColor;

  /// 패턴 이미지를 지정합니다.
  ///
  /// 패턴 이미지의 크기가 경로선의 두께보다 클 경우 경로선의 두께에 맞게 축소됩니다. null일 경우 패턴을 표시하지 않습니다.
  /// 기본값은 null입니다.
  OverlayImage? patternImage;

  /// 패턴 이미지의 간격을 지정합니다.
  ///
  /// 0일 경우 패턴을 표시하지 않습니다.
  /// 기본값은 50입니다.
  int patternInterval;

  /// 진척률을 0.0 ~ 1.0으로 지정합니다.
  ///
  /// 경로선에서 0.0 ~ [progress]의 선형은 지나온 경로로 간주되어 [passedColor]와 [passedOutlineColor]가 사용됩니다. [progress] ~ 1.0의 선형은 지나갈 경로로 간주되어 [color]와 [outlineColor]가 사용됩니다.
  /// 기본값은 0.0입니다.
  double progress;

  /// 두께를 지정합니다.
  /// <p>단위는 상대크기입니다. </p>
  /// 기본값은 10입니다.
  int width;

  /// 패스 오버레이를 탭했을 경우 호출되는 콜백입니다.
  /// <br/>
  ///
  /// 탭 이벤트를 먹은 [PathOverlayId]를 반환합니다.
  OnPathOverlayTab? onPathOverlayTab;

  Map<String, dynamic> get json => {
        'pathOverlayId': pathOverlayId.value,
        'coords': coords.map<List<double>>((coord) => coord.json).toList(),
        'globalZIndex': globalZIndex,
        'hideCollidedCaptions': hideCollidedCaptions,
        'hideCollidedMarkers': hideCollidedMarkers,
        'hideCollidedSymbols': hideCollidedSymbols,
        'color': color.value,
        'outlineColor': outlineColor.value,
        'outlineWidth': outlineWidth,
        'passedColor': passedColor.value,
        'passedOutlineColor': passedOutlineColor.value,
        'patternImage': patternImage?.assetName,
        'patternInterval': patternInterval,
        'progress': progress,
        'width': width,
      };

  PathOverlay(
    this.pathOverlayId,
    this.coords, {
    this.globalZIndex = defaultGlobalZIndex,
    this.hideCollidedCaptions = false,
    this.hideCollidedMarkers = false,
    this.hideCollidedSymbols = false,
    this.color = Colors.white,
    this.outlineColor = Colors.black,
    this.outlineWidth = 2,
    this.passedColor = Colors.white,
    this.passedOutlineColor = Colors.black,
    this.patternImage,
    this.patternInterval = 50,
    this.progress = 0,
    this.width = 10,
    this.onPathOverlayTab,
  }) : assert(coords.length > 1);

  /// 주어진 파라미터를 덮어씌운 새로운 [PathOverlay] 객체를 생성합니다.
  PathOverlay copyWith({
    List<LatLng>? coordsParam,
    int? globalZIndexParams,
    bool? hideCollidedCaptionsParams,
    bool? hideCollidedMarkersParams,
    bool? hideCollidedSymbolsParams,
    bool? visibleParams,
    Color? colorParams,
    Color? outlineColorParams,
    int? outlineWidthParams,
    Color? passedColorParams,
    Color? passedOutlineColorParams,
    OverlayImage? patternImageParams,
    int? patternIntervalParams,
    double? progressParams,
    int? widthParams,
    OnPathOverlayTab? onPathOverlayTabParams,
  }) =>
      PathOverlay(
        pathOverlayId,
        coordsParam ?? coords,
        globalZIndex: globalZIndexParams ?? globalZIndex,
        hideCollidedCaptions:
            hideCollidedCaptionsParams ?? hideCollidedCaptions,
        hideCollidedMarkers: hideCollidedMarkersParams ?? hideCollidedMarkers,
        hideCollidedSymbols: hideCollidedSymbolsParams ?? hideCollidedSymbols,
        color: colorParams ?? color,
        outlineColor: outlineColorParams ?? outlineColor,
        outlineWidth: outlineWidthParams ?? outlineWidth,
        passedColor: passedColorParams ?? passedColor,
        passedOutlineColor: passedOutlineColorParams ?? passedOutlineColor,
        patternImage: patternImageParams ?? patternImage,
        patternInterval: patternIntervalParams ?? patternInterval,
        progress: progressParams ?? progress,
        width: widthParams ?? width,
        onPathOverlayTab: onPathOverlayTabParams ?? onPathOverlayTab,
      );

  /// 같은 값을 지닌 새로운 [PathOverlay] 객체를 생성합니다.
  PathOverlay clone() => copyWith(coordsParam: List<LatLng>.from(coords));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is PathOverlay &&
        pathOverlayId == other.pathOverlayId &&
        listEquals(coords, other.coords) &&
        globalZIndex == other.globalZIndex &&
        hideCollidedCaptions == other.hideCollidedCaptions &&
        hideCollidedMarkers == other.hideCollidedMarkers &&
        hideCollidedSymbols == other.hideCollidedSymbols &&
        color == other.color &&
        outlineColor == other.outlineColor &&
        outlineWidth == other.outlineWidth &&
        passedColor == other.passedColor &&
        passedOutlineColor == other.passedOutlineColor &&
        patternImage == other.patternImage &&
        patternInterval == other.patternInterval &&
        progress == other.progress &&
        width == other.width;
  }

  @override
  int get hashCode => pathOverlayId.hashCode;
}

Map<PathOverlayId, PathOverlay> _keyByPathOverlayId(
    Iterable<PathOverlay>? pathOverlays) {
  if (pathOverlays == null) return {};

  return Map<PathOverlayId, PathOverlay>.fromEntries(pathOverlays.map(
      (PathOverlay pathOverlay) => MapEntry<PathOverlayId, PathOverlay>(
          pathOverlay.pathOverlayId, pathOverlay.clone())));
}

List<Map<String, dynamic>>? _serializePathOverlaySet(
    Set<PathOverlay?>? pathOverlays) {
  if (pathOverlays == null) return null;

  return pathOverlays
      .map<Map<String, dynamic>>((PathOverlay? p) => p!.json)
      .toList();
}

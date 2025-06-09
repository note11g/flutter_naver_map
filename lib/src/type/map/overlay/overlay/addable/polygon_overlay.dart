part of "../../../../../../flutter_naver_map.dart";

/// 다각형을 나타내는 오버레이입니다.
class NPolygonOverlay extends NAddableOverlay<NPolygonOverlay> {
  /// 다각형의 지점들을 나타냅니다.
  List<NLatLng> get coords => _coords.toList();
  Iterable<NLatLng> _coords;

  /// 다각형의 색상을 나타냅니다.
  ///
  /// 기본값은 [Colors.white]
  Color get color => _color;
  Color _color;

  /// 내부에 빈 공간을 나타냅니다.
  List<Iterable<NLatLng>> get holes => _holes.toList();
  Iterable<Iterable<NLatLng>> _holes;

  /// 다각형의 테두리 색상을 나타냅니다.
  ///
  /// 기본값은 [Colors.black]
  Color get outlineColor => _outlineColor;
  Color _outlineColor;

  /// 다각형의 테두리 두께를 나타냅니다.
  ///
  /// 기본값은 [0]
  double get outlineWidth => _outlineWidth;
  double _outlineWidth;

  /// 다각형의 테두리 점선 패턴을 나타냅니다.
  ///
  /// 패턴은 짝수번째 요소가 실선의 길이, 홀수번째 요소는 공백의 길이를 나타냅니다.
  ///
  /// 단위는 플러터에서 사용하는 것과 같은 논리픽셀(DP) 입니다.
  ///
  /// 기본값은 실선을 의미하는 빈 배열.
  Iterable<int> get outlinePattern => _outlinePattern;
  Iterable<int> _outlinePattern;

  @override
  // ignore: prefer_final_fields
  int _globalZIndex = -200000;

  NPolygonOverlay({
    required super.id,
    required Iterable<NLatLng> coords,
    Color color = Colors.white,
    Iterable<Iterable<NLatLng>> holes = const [],
    Color outlineColor = Colors.black,
    double outlineWidth = 0,
    Iterable<int> outlinePattern = const [],
  })  : assert(coords.length >= 3),
        assert(coords.first == coords.last),
        _coords = coords,
        _color = color,
        _holes = holes,
        _outlineColor = outlineColor,
        _outlineWidth = outlineWidth,
        _outlinePattern = outlinePattern,
        super(type: NOverlayType.polygonOverlay);

  /// 다각형의 지점들을 지정합니다.
  /// 다각형의 기본 조건을 따라, 점이 3개 이상 있어야 합니다.
  void setCoords(Iterable<NLatLng> coords) {
    assert(coords.length >= 3);
    _coords = coords;
    _set(_coordsName, coords);
  }

  /// 다각형의 색상을 지정합니다.
  ///
  /// 기본값은 [Colors.white]
  void setColor(Color color) {
    _color = color;
    _set(_colorName, color);
  }

  /// 다각형의 내부가 비어있는 영역을 지정합니다.
  /// [coords]와 반대 방향으로 나열되어야 합니다.
  ///
  /// 예를 들어, [coords]가 시계 방향이라면, [holes]는 반대 방향인 반 시계방향으로 나열되어 있어야 합니다.
  ///
  /// 또한, [coords]와 마찬가지로 다각형의 기본 조건을 따라, 점이 3개 이상 있어야 합니다.
  void setHoles(Iterable<Iterable<NLatLng>> holes) {
    _holes = holes;
    _set(_holesName, holes);
  }

  /// 다각형의 테두리 색상을 지정합니다.
  ///
  /// 기본값은 [Colors.black]
  void setOutlineColor(Color outlineColor) {
    _outlineColor = outlineColor;
    _set(_outlineColorName, outlineColor);
  }

  /// 다각형의 테두리 두께를 지정합니다.
  ///
  /// 기본값은 [0]
  void setOutlineWidth(double outlineWidth) {
    _outlineWidth = outlineWidth;
    _set(_outlineWidthName, outlineWidth);
  }

  /// 다각형의 테두리 점선 패턴을 지정합니다.
  ///
  /// 패턴은 짝수번째 요소가 실선의 길이, 홀수번째 요소는 공백의 길이를 나타냅니다.
  ///
  /// 단위는 플러터에서 사용하는 것과 같은 논리픽셀(DP) 입니다.
  ///
  /// 기본값은 실선을 의미하는 빈 배열.
  void setOutlinePattern(Iterable<int> pattern) {
    _outlinePattern = pattern;
    _set(_outlinePatternName, pattern);
  }

  /// 다각형 오버레이가 차지하는 영역을 반환합니다.
  Future<NLatLngBounds> getBounds() {
    return _getAsyncWithCast(_boundsName, NLatLngBounds.fromMessageable);
  }

  @override
  NPayload toNPayload() => NPayload.make({
        _infoName: info,
        _coordsName: coords,
        _colorName: color,
        _holesName: holes,
        _outlineColorName: outlineColor,
        _outlineWidthName: outlineWidth,
        _outlinePatternName: outlinePattern,
        ..._commonMap,
      });

  /*
    --- Messaging Name Define ---
  */

  static const _infoName = "info";
  static const _coordsName = "coords";
  static const _colorName = "color";
  static const _holesName = "holes";
  static const _outlineColorName = "outlineColor";
  static const _outlineWidthName = "outlineWidth";
  static const _outlinePatternName = "outlinePattern";
  static const _boundsName = "bounds";
}

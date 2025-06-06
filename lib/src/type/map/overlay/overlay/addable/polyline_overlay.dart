part of "../../../../../../flutter_naver_map.dart";

/// 선을 나타내는 오버레이입니다.
class NPolylineOverlay extends NAddableOverlay<NPolylineOverlay> {
  /// 선 오버레이를 구성하는 점들의 위치를 리스트로 나타냅니다.
  List<NLatLng> get coords => _coords.toList();
  Iterable<NLatLng> _coords;

  /// 선 오버레이의 색상을 나타냅니다.
  ///
  /// 기본값은 [Colors.white]
  Color get color => _color;
  Color _color;

  /// 선 오버레이의 두께를 나타냅니다.
  /// 단위는 플러터에서 사용하는 논리픽셀(DP)입니다.
  ///
  /// 기본값은 [2] (dp)
  double get width => _width;
  double _width;

  /// 선 오버레이의 끝점 모양을 나타냅니다.
  ///
  /// 기본값은 [NLineCap.butt]
  NLineCap get lineCap => _lineCap;
  NLineCap _lineCap;

  /// 선 오버레이의 연결점 모양을 나타냅니다.
  ///
  /// 기본값은 [NLineJoin.miter]
  NLineJoin get lineJoin => _lineJoin;
  NLineJoin _lineJoin;

  /// 선 오버래이의 점선 패턴을 나타냅니다.
  ///
  /// 패턴은 짝수번째 요소는 실선의 길이, 홀수번째 요소는 공백의 길이를 나타냅니다.
  ///
  /// 단위는 플러터에서 사용하는 것과 같은 논리픽셀(DP) 입니다.
  ///
  /// 기본값은 실선을 의미하는 빈 배열.
  List<int> get pattern => _pattern.toList();
  Iterable<int> _pattern; // dp(pt)이므로, Android 는 px로 변환 과정에서 오차가 발생할 수 있음.

  @override
  // ignore: prefer_final_fields
  int _globalZIndex = -200000;

  NPolylineOverlay({
    required super.id,
    required Iterable<NLatLng> coords,
    Color color = Colors.white,
    double width = 2,
    NLineCap lineCap = NLineCap.butt,
    NLineJoin lineJoin = NLineJoin.miter,
    Iterable<int> pattern = const [],
  })  : _coords = coords,
        _color = color,
        _width = width,
        _lineCap = lineCap,
        _lineJoin = lineJoin,
        _pattern = pattern,
        super(type: NOverlayType.polylineOverlay);

  /// 선 오버레이를 구성하는 점들의 위치를 리스트로 지정합니다.
  void setCoords(Iterable<NLatLng> coords) {
    _coords = coords;
    _set(_coordsName, coords);
  }

  /// 선 오버레이의 색상을 지정합니다.
  ///
  /// 기본 값은 [Colors.white]
  void setColor(Color color) {
    _color = color;
    _set(_colorName, color);
  }

  /// 선 오버레이의 두께를 지정합니다.
  /// 단위는 플러터에서 사용하는 논리픽셀(DP)입니다.
  ///
  /// 기본값은 [2] (dp)
  void setWidth(double width) {
    _width = width;
    _set(_widthName, width);
  }

  /// 선 오버레이의 끝점 모양을 지정합니다.
  ///
  /// 기본값은 [NLineCap.butt]
  void setLineCap(NLineCap lineCap) {
    _lineCap = lineCap;
    _set(_lineCapName, lineCap);
  }

  /// 선 오버레이의 연결점 모양을 지정합니다.
  ///
  /// 기본값은 [NLineJoin.miter]
  void setLineJoin(NLineJoin lineJoin) {
    _lineJoin = lineJoin;
    _set(_lineJoinName, lineJoin);
  }

  /// 선 오버레이의 점선 패턴을 지정합니다.
  ///
  /// 패턴은 짝수번째 요소는 실선의 길이, 홀수번째 요소는 공백의 길이를 나타냅니다.
  ///
  /// 단위는 플러터에서 사용하는 것과 같은 논리픽셀(DP) 입니다.
  ///
  /// 기본값은 실선을 의미하는 빈 배열.
  void setPattern(Iterable<int> pattern) {
    _pattern = pattern;
    _set(_patternName, pattern);
  }

  /// 선 오버레이가 차지하는 영역을 반환합니다.
  Future<NLatLngBounds> getBounds() {
    return _getAsyncWithCast(_boundsName, NLatLngBounds.fromMessageable);
  }

  @override
  NPayload toNPayload() => NPayload.make({
        _infoName: info,
        _coordsName: coords,
        _colorName: color,
        _widthName: width,
        _lineCapName: lineCap,
        _lineJoinName: lineJoin,
        _patternName: pattern,
        ..._commonMap,
      });

  /*
    --- Messaging Name Define ---
  */

  static const _infoName = "info";
  static const _coordsName = "coords";
  static const _colorName = "color";
  static const _widthName = "width";
  static const _lineCapName = "lineCap";
  static const _lineJoinName = "lineJoin";
  static const _patternName = "pattern";
  static const _boundsName = "bounds";
}

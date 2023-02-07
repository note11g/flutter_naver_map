part of flutter_naver_map;

class NArrowHeadPathOverlay extends NAddableOverlay<NArrowHeadPathOverlay> {
  List<NLatLng> get coords => _coords;
  List<NLatLng> _coords;

  double get width => _width;
  double _width;

  Color get color => _color;
  Color _color;

  double get outlineWidth => _outlineWidth;
  double _outlineWidth;

  Color get outlineColor => _outlineColor;
  Color _outlineColor;

  double get elevation => _elevation;
  double _elevation;

  double get headSizeRatio => _headSizeRatio;
  double _headSizeRatio;

  NArrowHeadPathOverlay({
    required String id,
    required List<NLatLng> coords,
    double width = 4,
    Color color = Colors.white,
    double outlineWidth = 0,
    Color outlineColor = Colors.black,
    double elevation = 0,
    double headSizeRatio = 2.5,
  })  : _coords = coords,
        _width = width,
        _color = color,
        _outlineWidth = outlineWidth,
        _outlineColor = outlineColor,
        _elevation = elevation,
        _headSizeRatio = headSizeRatio,
        super(id: id, type: NOverlayType.arrowheadPathOverlay);

  void setCoords(List<NLatLng> coords) {
    _coords = coords;
    _set(_coordsName, coords);
  }

  void setWidth(double width) {
    _width = width;
    _set(_widthName, width);
  }

  void setColor(Color color) {
    _color = color;
    _set(_colorName, color.value);
  }

  void setOutlineWidth(double outlineWidth) {
    _outlineWidth = outlineWidth;
    _set(_outlineWidthName, outlineWidth);
  }

  void setOutlineColor(Color outlineColor) {
    _outlineColor = outlineColor;
    _set(_outlineColorName, outlineColor.value);
  }

  void setElevation(double elevation) {
    _elevation = elevation;
    _set(_elevationName, elevation);
  }

  void setHeadSizeRatio(double headSizeRatio) {
    _headSizeRatio = headSizeRatio;
    _set(_headSizeRatioName, headSizeRatio);
  }

  Future<NLatLngBounds> getBounds() {
    return _getAsyncWithCast(_boundsName, NLatLngBounds._fromMessageable);
  }

  factory NArrowHeadPathOverlay._fromMessageable(dynamic m) =>
      NArrowHeadPathOverlay(
        id: NOverlayInfo._fromMessageable(m[_infoName]!).id,
        coords: (m[_coordsName] as List).map(NLatLng._fromMessageable).toList(),
        width: m[_widthName],
        color: Color(m[_colorName]),
        outlineWidth: m[_outlineWidthName],
        outlineColor: Color(m[_outlineColorName]),
        elevation: m[_elevationName],
        headSizeRatio: m[_headSizeRatioName],
      );

  @override
  NPayload toNPayload() => NPayload.make({
        _infoName: info,
        _coordsName: _coords,
        _widthName: _width,
        _colorName: _color.value,
        _outlineWidthName: _outlineWidth,
        _outlineColorName: _outlineColor.value,
        _elevationName: _elevation,
        _headSizeRatioName: _headSizeRatio,
      });

  /*
    --- Messaging Name Define ---
  */
  static const _infoName = "info";
  static const _coordsName = "coords";
  static const _widthName = "width";
  static const _colorName = "color";
  static const _outlineWidthName = "outlineWidth";
  static const _outlineColorName = "outlineColor";
  static const _elevationName = "elevation";
  static const _headSizeRatioName = "headSizeRatio";
  static const _boundsName = "bounds";
}

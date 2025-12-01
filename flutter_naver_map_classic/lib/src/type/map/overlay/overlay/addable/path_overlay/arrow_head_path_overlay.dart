part of "../../../../../../../flutter_naver_map.dart";

class NArrowheadPathOverlay extends NAddableOverlay<NArrowheadPathOverlay> {
  List<NLatLng> get coords => _coords.toList();
  Iterable<NLatLng> _coords;

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

  @override
  // ignore: prefer_final_fields
  int _globalZIndex = 100000;

  NArrowheadPathOverlay({
    required super.id,
    required Iterable<NLatLng> coords,
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
        super(type: NOverlayType.arrowheadPathOverlay);

  void setCoords(Iterable<NLatLng> coords) {
    _coords = coords;
    _set(_coordsName, coords);
  }

  void setWidth(double width) {
    _width = width;
    _set(_widthName, width);
  }

  void setColor(Color color) {
    _color = color;
    _set(_colorName, color);
  }

  void setOutlineWidth(double outlineWidth) {
    _outlineWidth = outlineWidth;
    _set(_outlineWidthName, outlineWidth);
  }

  void setOutlineColor(Color outlineColor) {
    _outlineColor = outlineColor;
    _set(_outlineColorName, outlineColor);
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
    return _getAsyncWithCast(_boundsName, NLatLngBounds.fromMessageable);
  }

  @override
  NPayload toNPayload() => NPayload.make({
        _infoName: info,
        _coordsName: _coords,
        _widthName: _width,
        _colorName: _color,
        _outlineWidthName: _outlineWidth,
        _outlineColorName: _outlineColor,
        _elevationName: _elevation,
        _headSizeRatioName: _headSizeRatio,
        ..._commonMap,
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

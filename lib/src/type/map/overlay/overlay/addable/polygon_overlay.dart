part of flutter_naver_map;

class NPolygonOverlay extends NAddableOverlay<NPolygonOverlay> {
  List<NLatLng> get coords => _coords.toList();
  Iterable<NLatLng> _coords;

  Color get color => _color;
  Color _color;

  List<Iterable<NLatLng>> get holes => _holes.toList();
  Iterable<Iterable<NLatLng>> _holes;

  Color get outlineColor => _outlineColor;
  Color _outlineColor;

  double get outlineWidth => _outlineWidth;
  double _outlineWidth;

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
  })  : assert(coords.length >= 3),
        assert(coords.first == coords.last),
        _coords = coords,
        _color = color,
        _holes = holes,
        _outlineColor = outlineColor,
        _outlineWidth = outlineWidth,
        super(type: NOverlayType.polygonOverlay);

  void setCoords(Iterable<NLatLng> coords) {
    assert(coords.length >= 3);
    assert(coords.first == coords.last);
    _coords = coords;
    _set(_coordsName, coords);
  }

  void setColor(Color color) {
    _color = color;
    _set(_colorName, color);
  }

  void setHoles(Iterable<Iterable<NLatLng>> holes) {
    _holes = holes;
    _set(_holesName, holes);
  }

  void setOutlineColor(Color outlineColor) {
    _outlineColor = outlineColor;
    _set(_outlineColorName, outlineColor);
  }

  void setOutlineWidth(double outlineWidth) {
    _outlineWidth = outlineWidth;
    _set(_outlineWidthName, outlineWidth);
  }

  Future<NLatLngBounds> getBounds() {
    return _getAsyncWithCast(_boundsName, NLatLngBounds._fromMessageable);
  }

  @override
  NPayload toNPayload() => NPayload.make({
        _infoName: info,
        _coordsName: coords,
        _colorName: color,
        _holesName: holes,
        _outlineColorName: outlineColor,
        _outlineWidthName: outlineWidth,
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
  static const _boundsName = "bounds";
}

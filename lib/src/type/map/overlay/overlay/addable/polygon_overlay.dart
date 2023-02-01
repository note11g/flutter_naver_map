part of flutter_naver_map;

class NPolygonOverlay extends NAddableOverlay<NPolygonOverlay> {
  List<NLatLng> get coords => _coords;
  List<NLatLng> _coords;

  Color get color => _color;
  Color _color;

  List<List<NLatLng>> get holes => _holes;
  List<List<NLatLng>> _holes;

  Color get outlineColor => _outlineColor;
  Color _outlineColor;

  double get outlineWidth => _outlineWidth;
  double _outlineWidth;

  NPolygonOverlay({
    required String id,
    required List<NLatLng> coords,
    Color color = Colors.white,
    List<List<NLatLng>> holes = const [],
    Color outlineColor = Colors.black,
    double outlineWidth = 0,
  })  : _coords = coords,
        _color = color,
        _holes = holes,
        _outlineColor = outlineColor,
        _outlineWidth = outlineWidth,
        super(id: id, type: NOverlayType.polygonOverlay);

  void setCoords(List<NLatLng> coords) {
    _coords = coords;
    _set(_coordsName, coords);
  }

  void setColor(Color color) {
    _color = color;
    _set(_colorName, color.value);
  }

  void setHoles(List<List<NLatLng>> holes) {
    _holes = holes;
    _set(_holesName, holes);
  }

  void setOutlineColor(Color outlineColor) {
    _outlineColor = outlineColor;
    _set(_outlineColorName, outlineColor.value);
  }

  void setOutlineWidth(double outlineWidth) {
    _outlineWidth = outlineWidth;
    _set(_outlineWidthName, outlineWidth);
  }

  Future<NLatLngBounds> getBounds() {
    return _getAsyncWithCast(_boundsName, NLatLngBounds._fromJson);
  }

  /* ----- Factory Constructor ----- */

  factory NPolygonOverlay._fromJson(dynamic json) => NPolygonOverlay(
        id: NOverlayInfo._fromJson(json[_infoName]!).id,
        coords:
            (json[_coordsName] as List).map((e) => NLatLng._fromJson(e)).toList(),
        color: Color(json[_colorName] as int),
        holes: (json[_holesName] as List)
            .map((e) => (e as List).map((e) => NLatLng._fromJson(e)).toList())
            .toList(),
        outlineColor: Color(json[_outlineColorName] as int),
        outlineWidth: json[_outlineWidthName] as double,
      );

  @override
  NPayload toNPayload() => NPayload.make({
        _infoName: info,
        _coordsName: coords,
        _colorName: color.value,
        _holesName: holes,
        _outlineColorName: outlineColor.value,
        _outlineWidthName: outlineWidth,
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

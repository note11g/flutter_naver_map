part of flutter_naver_map;

class NCircleOverlay extends NAddableOverlay<NCircleOverlay> {
  NLatLng get center => _center;
  NLatLng _center;

  double get radius => _radius;
  double _radius;

  Color get color => _color;
  Color _color;

  Color get outlineColor => _outlineColor;
  Color _outlineColor;

  double get outlineWidth => _outlineWidth;
  double _outlineWidth;

  NCircleOverlay({
    required String id,
    required NLatLng center,
    double radius = 1000, // meter
    Color color = Colors.white,
    Color outlineColor = Colors.black,
    double outlineWidth = 0,
  })  : _center = center,
        _radius = radius,
        _color = color,
        _outlineColor = outlineColor,
        _outlineWidth = outlineWidth,
        super(id: id, type: NOverlayType.circleOverlay);

  void setCenter(NLatLng center) {
    _center = center;
    _set(_centerName, center);
  }

  void setRadius(double radius) {
    _radius = radius;
    _set(_radiusName, radius);
  }

  void setColor(Color color) {
    _color = color;
    _set(_colorName, color.value);
  }

  void setOutlineColor(Color outlineColor) {
    _outlineColor = outlineColor;
    _set(_outlineColorName, outlineColor.value);
  }

  void setOutlineWidth(double outlineWidth) {
    _outlineWidth = outlineWidth;
    _set(_outlineWidthName, outlineWidth);
  }

  Future<NLatLngBounds> getBounds() =>
      _getAsyncWithCast(_boundsName, NLatLngBounds._fromJson);

  factory NCircleOverlay._fromJson(dynamic json) => NCircleOverlay(
        id: NOverlayInfo._fromJson(json[_infoName]).id,
        center: NLatLng._fromJson(json[_centerName]),
        radius: json[_radiusName],
        color: Color(json[_colorName]),
        outlineColor: Color(json[_outlineColorName]),
        outlineWidth: json[_outlineWidthName],
      );

  @override
  NPayload toNPayload() => NPayload.make({
        _infoName: info,
        _centerName: center,
        _radiusName: radius,
        _colorName: color.value,
        _outlineColorName: outlineColor.value,
        _outlineWidthName: outlineWidth,
      });

  /*
    --- Messaging Name Define ---
  */

  static const _infoName = "info";
  static const _centerName = "center";
  static const _radiusName = "radius";
  static const _colorName = "color";
  static const _outlineColorName = "outlineColor";
  static const _outlineWidthName = "outlineWidth";
  static const _boundsName = "bounds";
}

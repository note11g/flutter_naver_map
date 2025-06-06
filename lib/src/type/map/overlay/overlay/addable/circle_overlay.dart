part of "../../../../../../flutter_naver_map.dart";

/// 원으로 특정 영역을 나타낼 수 있는 오버레이입니다.
class NCircleOverlay extends NAddableOverlay<NCircleOverlay> {
  /// 원 오버레이의 중심점을 나타냅니다.
  NLatLng get center => _center;
  NLatLng _center;

  /// 원 오버레이의 반경을 나타냅니다.
  double get radius => _radius;
  double _radius;

  /// 원 오버레이의 색상을 나타냅니다.
  Color get color => _color;
  Color _color;

  /// 원 오버레이의 테두리 색상을 나타냅니다.
  Color get outlineColor => _outlineColor;
  Color _outlineColor;

  /// 원 오버레이의 테두리 두께를 나타냅니다.
  double get outlineWidth => _outlineWidth;
  double _outlineWidth;

  @override
  // ignore: prefer_final_fields
  int _globalZIndex = -200000;

  NCircleOverlay({
    required super.id,
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
        super(type: NOverlayType.circleOverlay);

  /// 원 오버레이의 중심점을 지정합니다.
  void setCenter(NLatLng center) {
    _center = center;
    _set(_centerName, center);
  }

  /// 원 오버레이의 반경을 지정합니다.
  void setRadius(double radius) {
    _radius = radius;
    _set(_radiusName, radius);
  }

  /// 원 오버레이의 색상을 지정합니다.
  void setColor(Color color) {
    _color = color;
    _set(_colorName, color);
  }

  /// 원 오버레이의 테두리 색상을 지정합니다.
  void setOutlineColor(Color outlineColor) {
    _outlineColor = outlineColor;
    _set(_outlineColorName, outlineColor);
  }

  /// 원 오버레이의 테두리 두께를 지정합니다.
  void setOutlineWidth(double outlineWidth) {
    _outlineWidth = outlineWidth;
    _set(_outlineWidthName, outlineWidth);
  }

  /// 원 오버레이가 나타내는 최소 사각형 영역을 반환합니다.
  Future<NLatLngBounds> getBounds() =>
      _getAsyncWithCast(_boundsName, NLatLngBounds.fromMessageable);

  @override
  NPayload toNPayload() => NPayload.make({
        _infoName: info,
        _centerName: center,
        _radiusName: radius,
        _colorName: color,
        _outlineColorName: outlineColor,
        _outlineWidthName: outlineWidth,
        ..._commonMap,
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

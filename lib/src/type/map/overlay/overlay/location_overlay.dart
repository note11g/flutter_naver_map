part of flutter_naver_map;

class NLocationOverlay extends NOverlay<NLocationOverlay> {
  /* ----- Constructor ----- */

  /// 지도 뷰마다 오직 한개씩만 OverlayController 에서 생성됩니다.
  NLocationOverlay._() : super(_locationOverlayInfo);

  static const NOverlayInfo _locationOverlayInfo = NOverlayInfo._withMethod(
      type: NOverlayType.locationOverlay, id: "L", method: null);

  /* ----- Methods ----- */

  Future<NPoint> getAnchor() =>
      _getAsyncWithCast(_anchorName, NPoint._fromMessageable);

  void setAnchor(NPoint anchor) => _set(_anchorName, anchor);

  Future<double> getBearing() => _getAsync(_bearingName);

  void setBearing(double bearing) => _set(_bearingName, bearing);

  Future<Color> getCircleColor() =>
      _getAsyncWithCast(_circleColorName, (rawColor) => Color(rawColor));

  void setCircleColor(Color circleColor) => _set(_circleColorName, circleColor);

  Future<Color> getCircleOutlineColor() =>
      _getAsyncWithCast(_circleOutlineColorName, (rawColor) => Color(rawColor));

  void setCircleOutlineColor(Color circleOutlineColor) =>
      _set(_circleOutlineColorName, circleOutlineColor);

  Future<double> getCircleOutlineWidth() => _getAsync(_circleOutlineWidthName);

  void setCircleOutlineWidth(double circleOutlineWidth) =>
      _set(_circleOutlineWidthName, circleOutlineWidth);

  Future<double> getCircleRadius() => _getAsync(_circleRadiusName);

  void setCircleRadius(double circleRadius) =>
      _set(_circleRadiusName, circleRadius);

  void setIcon(NOverlayImage icon) => _set(_iconName, icon);

  Future<Size> getIconSize() =>
      _getAsyncWithCast(_iconSizeName, NSize._fromMessageable);

  void setIconSize(Size size) => _set(_iconSizeName, size);

  Future<NLatLng> getPosition() =>
      _getAsyncWithCast(_positionName, NLatLng._fromMessageable);

  void setPosition(NLatLng position) => _set(_positionName, position);

  Future<NPoint> getSubAnchor() =>
      _getAsyncWithCast(_subAnchorName, NPoint._fromMessageable);

  void setSubAnchor(NPoint subAnchor) => _set(_subAnchorName, subAnchor);

  void setSubIcon(NOverlayImage? icon) => _set(_subIconName, icon);

  Future<Size> getSubIconSize() =>
      _getAsyncWithCast(_subIconSizeName, NSize._fromMessageable);

  void setSubIconSize(Size size) => _set(_subIconSizeName, size);

  /*
    --- Messaging Name Define ---
  */

  static const _anchorName = "anchor";
  static const _bearingName = "bearing";
  static const _circleColorName = "circleColor";
  static const _circleOutlineColorName = "circleOutlineColor";
  static const _circleOutlineWidthName = "circleOutlineWidth";
  static const _circleRadiusName = "circleRadius";
  static const _iconName = "icon";
  static const _iconSizeName = "iconSize";
  static const _positionName = "position";
  static const _subAnchorName = "subAnchor";
  static const _subIconName = "subIcon";
  static const _subIconSizeName = "subIconSize";
}

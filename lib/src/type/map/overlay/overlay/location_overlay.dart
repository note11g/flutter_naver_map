part of "../../../../../flutter_naver_map.dart";

/// 사용자의 위치를 나타낼 때 사용하는 오버레이입니다.
///
/// 직접 사용할 수 없으며, 지도 위젯별로 1개씩만 존재합니다.
///
/// [NaverMapController.getLocationOverlay] 메서드를 활용해 가져올 수 있습니다.
class NLocationOverlay extends NOverlay<NLocationOverlay> {
  /* ----- Constructor ----- */

  NLocationOverlay._attachToMapWhenFirstUse(_NOverlayController controller)
      : super(_locationOverlayInfo) {
    _addedOnMap(controller);
    _allSyncByDefaultForPlatformDiffProperties();
  }

  static const NOverlayInfo _locationOverlayInfo =
      NOverlayInfo(type: NOverlayType.locationOverlay, id: "L");

  /* ----- Methods ----- */

  @override
  // ignore: prefer_final_fields
  int _globalZIndex = 300000;

  NPoint get anchor => _anchor;
  NPoint _anchor = defaultAnchor;

  Color get circleColor => _circleColor;
  Color _circleColor = defaultCircleColor;

  Color get circleOutlineColor => _circleOutlineColor;
  Color _circleOutlineColor = Colors.transparent;

  double get circleOutlineWidth => _circleOutlineWidth;
  double _circleOutlineWidth = 0.0;

  double get circleRadius => _circleRadius;
  double _circleRadius = defaultCircleRadius;

  Size get iconSize => _iconSize;
  Size _iconSize = autoSize;

  double get iconAlpha => _iconAlpha;
  double _iconAlpha = 1.0;

  NPoint get subAnchor => _subAnchor;
  NPoint _subAnchor = defaultSubAnchor;

  Size get subIconSize => _subIconSize;
  Size _subIconSize = autoSize;

  double get subIconAlpha => _subIconAlpha;
  double _subIconAlpha = 1.0;

  // --- Setters ---

  void setAnchor(NPoint anchor) {
    _anchor = anchor;
    _set(_anchorName, anchor);
  }

  Future<double> getBearing() async {
    return _getAsyncWithCast(_bearingName, (raw) => raw as double);
  }

  void setBearing(double bearing) {
    _set(_bearingName, bearing);
  }

  void setCircleColor(Color circleColor) {
    _circleColor = circleColor;
    _set(_circleColorName, circleColor);
  }

  void setCircleOutlineColor(Color circleOutlineColor) {
    _circleOutlineColor = circleOutlineColor;
    _set(_circleOutlineColorName, circleOutlineColor);
  }

  void setCircleOutlineWidth(double circleOutlineWidth) {
    _circleOutlineWidth = circleOutlineWidth;
    _set(_circleOutlineWidthName, circleOutlineWidth);
  }

  void setCircleRadius(double circleRadius) {
    _circleRadius = circleRadius;
    _set(_circleRadiusName, circleRadius);
  }

  void setIcon(NOverlayImage icon) => _set(_iconName, icon);

  void setIconSize(Size size) {
    _iconSize = size;
    _set(_iconSizeName, size);
  }

  void setIconAlpha(double alpha) {
    _iconAlpha = alpha;
    _set(_iconAlphaName, alpha);
  }

  Future<NLatLng> getPosition() async {
    return _getAsyncWithCast(_positionName, NLatLng.fromMessageable);
  }

  void setPosition(NLatLng position) {
    _set(_positionName, position);
  }

  void setSubAnchor(NPoint subAnchor) {
    _subAnchor = subAnchor;
    _set(_subAnchorName, subAnchor);
  }

  void setSubIcon(NOverlayImage? icon) {
    _set(_subIconName, icon);
  }

  void setSubIconSize(Size size) {
    _subIconSize = size;
    _set(_subIconSizeName, size);
  }

  void setSubIconAlpha(double alpha) {
    _subIconAlpha = alpha;
    _set(_subIconAlphaName, alpha);
  }

  void _allSyncByDefaultForPlatformDiffProperties() {
    setIcon(defaultIcon);
    setCircleColor(defaultCircleColor);
  }

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
  static const _iconAlphaName = "iconAlpha";
  static const _positionName = "position";
  static const _subAnchorName = "subAnchor";
  static const _subIconName = "subIcon";
  static const _subIconSizeName = "subIconSize";
  static const _subIconAlphaName = "subIconAlpha";

  static const defaultAnchor = NPoint.relativeCenter;
  static const defaultSubAnchor = NPoint(0.5, 1.0);
  static const defaultCircleColor = Color(0x141666F0);
  static const defaultCircleRadius = 18.0;
  static const autoSize = Size(0, 0);
  static const defaultIcon = NOverlayImage.fromAssetImage(
      "$_packageIconAssetPath/location_overlay_icon.png");
  static const defaultSubIcon = NOverlayImage.fromAssetImage(
      "$_packageIconAssetPath/location_overlay_sub_icon.png");
  static const faceModeSubIcon = NOverlayImage.fromAssetImage(
      "$_packageIconAssetPath/location_overlay_sub_icon_face.png");
  static const _packageIconAssetPath = "packages/flutter_naver_map/assets/icon";
}

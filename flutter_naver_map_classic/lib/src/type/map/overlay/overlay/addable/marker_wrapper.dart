part of "../../../../../../flutter_naver_map.dart";

/// 마커의 확장을 위한 클래스.
class _NMarkerWrapper<Self extends NMarker> extends NAddableOverlay<NMarker>
    implements NMarker {
  _NMarkerWrapper({
    required super.id,
    required super.type,
    required NLatLng position,
    NOverlayImage? icon,
    Color iconTintColor = Colors.transparent,
    double alpha = 1,
    double angle = 0,
    NPoint anchor = NMarker.defaultAnchor,
    Size size = NMarker.autoSize,
    NOverlayCaption? caption,
    NOverlayCaption? subCaption,
    Iterable<NAlign> captionAligns = const [NAlign.bottom],
    double captionOffset = 0,
    bool isCaptionPerspectiveEnabled = false,
    bool isIconPerspectiveEnabled = false,
    bool isFlat = false,
    bool isForceShowCaption = false,
    bool isForceShowIcon = false,
    bool isHideCollidedCaptions = false,
    bool isHideCollidedMarkers = false,
    bool isHideCollidedSymbols = false,
  }) : _marker = NMarker(
          id: id,
          position: position,
          icon: icon,
          iconTintColor: iconTintColor,
          alpha: alpha,
          angle: angle,
          anchor: anchor,
          size: size,
          caption: caption,
          subCaption: subCaption,
          captionAligns: captionAligns,
          captionOffset: captionOffset,
          isCaptionPerspectiveEnabled: isCaptionPerspectiveEnabled,
          isIconPerspectiveEnabled: isIconPerspectiveEnabled,
          isFlat: isFlat,
          isForceShowCaption: isForceShowCaption,
          isForceShowIcon: isForceShowIcon,
          isHideCollidedCaptions: isHideCollidedCaptions,
          isHideCollidedMarkers: isHideCollidedMarkers,
          isHideCollidedSymbols: isHideCollidedSymbols,
        );

  @override
  void setOnTapListener(Function(Self overlay) listener) {
    super.setOnTapListener((overlay) => listener(overlay as Self));
  }

  final NMarker _marker;

  //region Implementation with Wrapped NMarker

  //region Position
  @override
  NLatLng get _position => _marker._position;

  @override
  set _position(NLatLng v) => _marker._position = v;

  @override
  NLatLng get position => _marker.position;

  @override
  void setPosition(NLatLng value) {
    _position = value;
    _set(NMarker._positionName, _position);
  }

  //endregion

  //region Icon
  @override
  NOverlayImage? get _icon => _marker._icon;

  @override
  NOverlayImage? get icon => _marker.icon;

  @override
  set _icon(NOverlayImage? v) => _marker._icon = v;

  @override
  void setIcon(NOverlayImage? value) {
    _icon = value;
    _set(NMarker._iconName, _icon);
  }

  //endregion

  //region IconTintColor
  @override
  Color get _iconTintColor => _marker._iconTintColor;

  @override
  set _iconTintColor(Color v) => _marker._iconTintColor = v;

  @override
  Color get iconTintColor => _marker.iconTintColor;

  @override
  void setIconTintColor(Color value) {
    _iconTintColor = value;
    _set(NMarker._iconTintColorName, _iconTintColor);
  }

  //endregion

  //region Alpha
  @override
  double get _alpha => _marker._alpha;

  @override
  set _alpha(double v) => _marker._alpha = v;

  @override
  double get alpha => _marker.alpha;

  @override
  void setAlpha(double value) {
    _alpha = value;
    _set(NMarker._alphaName, _alpha);
  }

  //endregion

  //region Angle
  @override
  double get _angle => _marker._angle;

  @override
  set _angle(double v) => _marker._angle = v;

  @override
  double get angle => _marker.angle;

  @override
  void setAngle(double value) {
    _angle = value;
    _set(NMarker._angleName, _angle);
  }

  //endregion

  //region Anchor
  @override
  NPoint get _anchor => _marker._anchor;

  @override
  set _anchor(NPoint v) => _marker._anchor = v;

  @override
  NPoint get anchor => _marker.anchor;

  @override
  void setAnchor(NPoint value) {
    _anchor = value;
    _set(NMarker._anchorName, _anchor);
  }

  //endregion

  //region Size
  @override
  Size get _size => _marker._size;

  @override
  set _size(Size v) => _marker._size = v;

  @override
  Size get size => _marker.size;

  @override
  void setSize(Size value) {
    _size = value;
    _set(NMarker._sizeName, _size);
  }

  //endregion

  //region Caption
  @override
  NOverlayCaption? get _caption => _marker._caption;

  @override
  set _caption(NOverlayCaption? v) => _marker._caption = v;

  @override
  NOverlayCaption? get caption => _marker.caption;

  @override
  void setCaption(NOverlayCaption? value) {
    _caption = value;
    _set(NMarker._captionName, _caption);
  }

  //endregion

  //region SubCaption
  @override
  NOverlayCaption? get _subCaption => _marker._subCaption;

  @override
  set _subCaption(NOverlayCaption? v) => _marker._subCaption = v;

  @override
  NOverlayCaption? get subCaption => _marker._subCaption;

  @override
  void setSubCaption(NOverlayCaption? value) {
    _subCaption = value;
    _set(NMarker._subCaptionName, _subCaption);
  }

  //endregion

  //region CaptionAligns
  @override
  Iterable<NAlign> get _captionAligns => _marker._captionAligns;

  @override
  set _captionAligns(Iterable<NAlign> v) => _marker._captionAligns = v;

  @override
  List<NAlign> get captionAligns => _marker.captionAligns;

  @override
  void setCaptionAligns(Iterable<NAlign> value) {
    _captionAligns = value;
    _set(NMarker._captionAlignsName, _captionAligns);
  }

  //endregion

  //region CaptionOffset

  @override
  double get _captionOffset => _marker._captionOffset;

  @override
  set _captionOffset(double v) => _marker._captionOffset = v;

  @override
  double get captionOffset => _marker.captionOffset;

  @override
  void setCaptionOffset(double value) {
    _captionOffset = value;
    _set(NMarker._captionOffsetName, _captionOffset);
  }

  //endregion

  //region IsCaptionPerspectiveEnabled

  @override
  bool get _isCaptionPerspectiveEnabled => _marker._isCaptionPerspectiveEnabled;

  @override
  set _isCaptionPerspectiveEnabled(bool v) =>
      _marker._isCaptionPerspectiveEnabled = v;

  @override
  bool get isCaptionPerspectiveEnabled => _marker.isCaptionPerspectiveEnabled;

  @override
  void setIsCaptionPerspectiveEnabled(bool value) {
    _isCaptionPerspectiveEnabled = value;
    _set(
        NMarker._isCaptionPerspectiveEnabledName, _isCaptionPerspectiveEnabled);
  }

  //endregion

  //region IsIconPerspectiveEnabled

  @override
  bool get _isIconPerspectiveEnabled => _marker._isIconPerspectiveEnabled;

  @override
  set _isIconPerspectiveEnabled(bool v) =>
      _marker._isIconPerspectiveEnabled = v;

  @override
  bool get isIconPerspectiveEnabled => _marker.isIconPerspectiveEnabled;

  @override
  void setIsIconPerspectiveEnabled(bool value) {
    _isIconPerspectiveEnabled = value;
    _set(NMarker._isIconPerspectiveEnabledName, _isIconPerspectiveEnabled);
  }

  //endregion

  //region IsFlat

  @override
  bool get _isFlat => _marker._isFlat;

  @override
  set _isFlat(bool v) => _marker._isFlat = v;

  @override
  bool get isFlat => _marker.isFlat;

  @override
  void setIsFlat(bool value) {
    _isFlat = value;
    _set(NMarker._isFlatName, _isFlat);
  }

  //endregion

  //region IsForceShowCaption

  @override
  bool get _isForceShowCaption => _marker._isForceShowCaption;

  @override
  set _isForceShowCaption(bool v) => _marker._isForceShowCaption = v;

  @override
  bool get isForceShowCaption => _marker.isForceShowCaption;

  @override
  void setIsForceShowCaption(bool value) {
    _isForceShowCaption = value;
    _set(NMarker._isForceShowCaptionName, _isForceShowCaption);
  }

  //endregion

  //region IsForceShowIcon

  @override
  bool get _isForceShowIcon => _marker._isForceShowIcon;

  @override
  set _isForceShowIcon(bool v) => _marker._isForceShowIcon = v;

  @override
  bool get isForceShowIcon => _marker.isForceShowIcon;

  @override
  void setIsForceShowIcon(bool value) {
    _isForceShowIcon = value;
    _set(NMarker._isForceShowIconName, _isForceShowIcon);
  }

  //endregion

  //region IsHideCollidedCaptions

  @override
  bool get _isHideCollidedCaptions => _marker._isHideCollidedCaptions;

  @override
  set _isHideCollidedCaptions(bool v) => _marker._isHideCollidedCaptions = v;

  @override
  bool get isHideCollidedCaptions => _marker.isHideCollidedCaptions;

  @override
  void setIsHideCollidedCaptions(bool value) {
    _isHideCollidedCaptions = value;
    _set(NMarker._isHideCollidedCaptionsName, _isHideCollidedCaptions);
  }

  //endregion

  //region IsHideCollidedMarkers

  @override
  bool get _isHideCollidedMarkers => _marker._isHideCollidedMarkers;

  @override
  set _isHideCollidedMarkers(bool v) => _marker._isHideCollidedMarkers = v;

  @override
  bool get isHideCollidedMarkers => _marker.isHideCollidedMarkers;

  @override
  void setIsHideCollidedMarkers(bool value) {
    _isHideCollidedMarkers = value;
    _set(NMarker._isHideCollidedMarkersName, _isHideCollidedMarkers);
  }

  //endregion

  //region IsHideCollidedSymbols

  @override
  bool get _isHideCollidedSymbols => _marker._isHideCollidedSymbols;

  @override
  set _isHideCollidedSymbols(bool v) => _marker._isHideCollidedSymbols = v;

  @override
  bool get isHideCollidedSymbols => _marker.isHideCollidedSymbols;

  @override
  void setHideCollidedSymbols(bool value) {
    _isHideCollidedSymbols = value;
    _set(NMarker._isHideCollidedSymbolsName, _isHideCollidedSymbols);
  }

  //endregion

  //region globalZIndex
  @override
  int get _globalZIndex => _marker._globalZIndex;

  @override
  set _globalZIndex(int v) => _marker._globalZIndex = v;

  //endregion

  //region communication with Native Method

  @override
  NPayload toNPayload() => _marker.toNPayload().expandWith(_commonMap);

  @override
  Future<bool> hasOpenInfoWindow() => _marker.hasOpenInfoWindow();

  @override
  Future<void> openInfoWindow(NInfoWindow infoWindow,
          {NAlign align = NAlign.top}) =>
      _marker.openInfoWindow(infoWindow, align: align);

//endregion

//endregion
}

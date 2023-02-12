part of flutter_naver_map;

class NMarker extends NAddableOverlay<NMarker> {
  NLatLng get position => _position;
  NLatLng _position;

  NOverlayImage? _icon;

  Color get iconTintColor => _iconTintColor;
  Color _iconTintColor;

  double get alpha => _alpha;
  double _alpha;

  double get angle => _angle;
  double _angle;

  NPoint get anchor => _anchor;
  NPoint _anchor;

  Size get size => _size;
  Size _size;

  NOverlayCaption? get caption => _caption;
  NOverlayCaption? _caption;

  NOverlayCaption? get subCaption => _subCaption;
  NOverlayCaption? _subCaption;

  List<NAlign> get captionAligns => _captionAligns;
  List<NAlign> _captionAligns;

  double get captionOffset => _captionOffset;
  double _captionOffset;

  bool get isCaptionPerspectiveEnabled => _isCaptionPerspectiveEnabled;
  bool _isCaptionPerspectiveEnabled;

  bool get isIconPerspectiveEnabled => _isIconPerspectiveEnabled;
  bool _isIconPerspectiveEnabled;

  bool get isFlat => _isFlat;
  bool _isFlat;

  bool get isForceShowCaption => _isForceShowCaption;
  bool _isForceShowCaption;

  bool get isForceShowIcon => _isForceShowIcon;
  bool _isForceShowIcon;

  bool get isHideCollidedCaptions => _isHideCollidedCaptions;
  bool _isHideCollidedCaptions;

  bool get isHideCollidedMarkers => _isHideCollidedMarkers;
  bool _isHideCollidedMarkers;

  bool get isHideCollidedSymbols => _isHideCollidedSymbols;
  bool _isHideCollidedSymbols;

  NMarker({
    required String id,
    required NLatLng position,
    NOverlayImage? icon,
    Color iconTintColor = Colors.transparent,
    double alpha = 1,
    double angle = 0,
    NPoint anchor = defaultAnchor,
    Size size = auto,
    NOverlayCaption? caption,
    NOverlayCaption? subCaption,
    List<NAlign> captionAligns = const [NAlign.bottom],
    double captionOffset = 0,
    bool isCaptionPerspectiveEnabled = false,
    bool isIconPerspectiveEnabled = false,
    bool isFlat = false,
    bool isForceShowCaption = false,
    bool isForceShowIcon = false,
    bool isHideCollidedCaptions = false,
    bool isHideCollidedMarkers = false,
    bool isHideCollidedSymbols = false,
  })  : assert(captionAligns.isNotEmpty),
        _position = position,
        _icon = icon,
        _iconTintColor = iconTintColor,
        _alpha = alpha,
        _angle = angle,
        _anchor = anchor,
        _size = size,
        _caption = caption,
        _subCaption = subCaption,
        _captionAligns = captionAligns,
        _captionOffset = captionOffset,
        _isCaptionPerspectiveEnabled = isCaptionPerspectiveEnabled,
        _isIconPerspectiveEnabled = isIconPerspectiveEnabled,
        _isFlat = isFlat,
        _isForceShowCaption = isForceShowCaption,
        _isForceShowIcon = isForceShowIcon,
        _isHideCollidedCaptions = isHideCollidedCaptions,
        _isHideCollidedMarkers = isHideCollidedMarkers,
        _isHideCollidedSymbols = isHideCollidedSymbols,
        super(id: id, type: NOverlayType.marker);

  /*
    --- constant ---
  */
  static const defaultAnchor = NPoint(0.5, 1.0);
  static const auto = Size(0, 0);

  /*
    --- method ---
  */

  Future<bool> hasOpenInfoWindow() => _runAsync(_hasOpenInfoWindowName);

  Future<void> openInfoWindow(NInfoWindow infoWindow,
      {NAlign align = NAlign.top}) async {
    assert(infoWindow.withMarker);
    assert(_isAdded);

    infoWindow._addedOnMap(_overlayController!);
    assert(infoWindow._isAdded);

    final payload = NPayload.make({"infoWindow": infoWindow, "align": align});
    await _runAsync(_openInfoWindowName, payload);
  }

  void setPosition(NLatLng value) {
    _position = value;
    _set(_positionName, _position);
  }

  void setIcon(NOverlayImage? value) {
    _icon = value;
    _set(_iconName, _icon);
  }

  void setIconTintColor(Color value) {
    _iconTintColor = value;
    _set(_iconTintColorName, _iconTintColor);
  }

  void setAlpha(double value) {
    _alpha = value;
    _set(_alphaName, _alpha);
  }

  void setAngle(double value) {
    _angle = value;
    _set(_angleName, _angle);
  }

  void setAnchor(NPoint value) {
    _anchor = value;
    _set(_anchorName, _anchor);
  }

  void setSize(Size value) {
    _size = value;
    _set(_sizeName, _size);
  }

  void setCaption(NOverlayCaption? value) {
    _caption = value;
    _set(_captionName, _caption);
  }

  void setSubCaption(NOverlayCaption? value) {
    _subCaption = value;
    _set(_subCaptionName, _subCaption);
  }

  void setCaptionAligns(List<NAlign> value) {
    _captionAligns = value;
    _set(_captionAlignsName, _captionAligns);
  }

  void setCaptionOffset(double value) {
    _captionOffset = value;
    _set(_captionOffsetName, _captionOffset);
  }

  void setIsCaptionPerspectiveEnabled(bool value) {
    _isCaptionPerspectiveEnabled = value;
    _set(_isCaptionPerspectiveEnabledName, _isCaptionPerspectiveEnabled);
  }

  void setIsIconPerspectiveEnabled(bool value) {
    _isIconPerspectiveEnabled = value;
    _set(_isIconPerspectiveEnabledName, _isIconPerspectiveEnabled);
  }

  void setIsFlat(bool value) {
    _isFlat = value;
    _set(_isFlatName, _isFlat);
  }

  void setIsForceShowCaption(bool value) {
    _isForceShowCaption = value;
    _set(_isForceShowCaptionName, _isForceShowCaption);
  }

  void setIsForceShowIcon(bool value) {
    _isForceShowIcon = value;
    _set(_isForceShowIconName, _isForceShowIcon);
  }

  void setIsHideCollidedCaptions(bool value) {
    _isHideCollidedCaptions = value;
    _set(_isHideCollidedCaptionsName, _isHideCollidedCaptions);
  }

  void setIsHideCollidedMarkers(bool value) {
    _isHideCollidedMarkers = value;
    _set(_isHideCollidedMarkersName, _isHideCollidedMarkers);
  }

  void setHideCollidedSymbols(bool value) {
    _isHideCollidedSymbols = value;
    _set(_isHideCollidedSymbolsName, _isHideCollidedSymbols);
  }

  factory NMarker._fromMessageable(dynamic m) => NMarker(
        id: NOverlayInfo._fromMessageable(m[_infoName]).id,
        position: NLatLng._fromMessageable(m[_positionName]),
        icon: m[_iconName] != null
            ? NOverlayImage._fromMessageable(m[_iconName])
            : null,
        iconTintColor: Color(m[_iconTintColorName]),
        alpha: m[_alphaName],
        angle: m[_angleName],
        anchor: NPoint._fromMessageable(m[_anchorName]),
        size: NSize._fromMessageable(m[_sizeName]),
        caption: m[_captionName] != null
            ? NOverlayCaption._fromMessageable(m[_captionName])
            : null,
        subCaption: m[_subCaptionName] != null
            ? NOverlayCaption._fromMessageable(m[_subCaptionName])
            : null,
        captionAligns: (m[_captionAlignsName] as List)
            .map(NAlign._fromMessageable)
            .toList(),
        captionOffset: m[_captionOffsetName],
        isCaptionPerspectiveEnabled: m[_isCaptionPerspectiveEnabledName],
        isIconPerspectiveEnabled: m[_isIconPerspectiveEnabledName],
        isFlat: m[_isFlatName],
        isForceShowCaption: m[_isForceShowCaptionName],
        isForceShowIcon: m[_isForceShowIconName],
        isHideCollidedCaptions: m[_isHideCollidedCaptionsName],
        isHideCollidedMarkers: m[_isHideCollidedMarkersName],
        isHideCollidedSymbols: m[_isHideCollidedSymbolsName],
      );

  @override
  NPayload toNPayload() => NPayload.make({
        _infoName: info,
        _positionName: position,
        _iconName: _icon,
        _iconTintColorName: _iconTintColor,
        _alphaName: _alpha,
        _angleName: _angle,
        _anchorName: _anchor,
        _sizeName: _size,
        _captionName: _caption,
        _subCaptionName: _subCaption,
        _captionAlignsName: _captionAligns,
        _captionOffsetName: _captionOffset,
        _isCaptionPerspectiveEnabledName: _isCaptionPerspectiveEnabled,
        _isIconPerspectiveEnabledName: _isIconPerspectiveEnabled,
        _isFlatName: _isFlat,
        _isForceShowCaptionName: _isForceShowCaption,
        _isForceShowIconName: _isForceShowIcon,
        _isHideCollidedCaptionsName: _isHideCollidedCaptions,
        _isHideCollidedMarkersName: _isHideCollidedMarkers,
        _isHideCollidedSymbolsName: _isHideCollidedSymbols,
      });

  /*
    --- Messaging Name Define ---
  */

  static const _infoName = "info";
  static const _hasOpenInfoWindowName = "hasOpenInfoWindow";
  static const _openInfoWindowName = "openInfoWindow";
  static const _positionName = "position";
  static const _iconName = "icon";
  static const _iconTintColorName = "iconTintColor";
  static const _alphaName = "alpha";
  static const _angleName = "angle";
  static const _anchorName = "anchor";
  static const _sizeName = "size";
  static const _captionName = "caption";
  static const _subCaptionName = "subCaption";
  static const _captionAlignsName = "captionAligns";
  static const _captionOffsetName = "captionOffset";
  static const _isCaptionPerspectiveEnabledName = "isCaptionPerspectiveEnabled";
  static const _isIconPerspectiveEnabledName = "isIconPerspectiveEnabled";
  static const _isFlatName = "isFlat";
  static const _isForceShowCaptionName = "isForceShowCaption";
  static const _isForceShowIconName = "isForceShowIcon";
  static const _isHideCollidedCaptionsName = "isHideCollidedCaptions";
  static const _isHideCollidedMarkersName = "isHideCollidedMarkers";
  static const _isHideCollidedSymbolsName = "isHideCollidedSymbols";
}

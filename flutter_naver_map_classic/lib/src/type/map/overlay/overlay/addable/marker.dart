part of "../../../../../../flutter_naver_map.dart";

/// 지도 위의 한 지점에 아이콘과 캡션을 이용하여 정보를 나타낼 수 있는 오버레이입니다.
///
/// 주로, 장소를 나타내곤 합니다.
class NMarker extends NAddableOverlay<NMarker> {
  /// 마커의 위치하는 좌표를 나타냅니다.
  NLatLng get position => _position;
  NLatLng _position;

  /// 마커의 아이콘을 나타냅니다.
  /// `null`로 지정하는 경우, 기본 마커 아이콘을 사용합니다.
  ///
  NOverlayImage? get icon => _icon;
  NOverlayImage? _icon;

  /// 마커의 아이콘에 덧씌우는(혼합) 색상을 나타냅니다. (가산혼합)
  ///
  /// 채도가 있는 곳에 해당 색상이 덧씌워집니다. 단, 알파값은 무시됩니다.
  Color get iconTintColor => _iconTintColor;
  Color _iconTintColor;

  /// 마커의 불투명도를 나타냅니다. (0 ~ 1)
  double get alpha => _alpha;
  double _alpha;

  /// 마커의 회전 각도를 나타냅니다. (0 ~ 360)
  ///
  /// 단위는 도입니다.
  double get angle => _angle;
  double _angle;

  /// 좌표가 아이콘의 어느 지점에 위치하는 지인 기준점을 나타냅니다.
  /// 값 범위는 (0, 0) ~ (1, 1)입니다.
  ///
  /// 기본 값은 중앙 하단을 나타내는 [defaultAnchor]입니다.
  NPoint get anchor => _anchor;
  NPoint _anchor;

  /// 마커의 아이콘 사이즈를 나타냅니다.
  ///
  /// Size에서 사용하는 단위는 플러터 기본 단위인 LogicalPixel(dp) 단위입니다.
  ///
  /// 기본 값은 마커의 아이콘 사이즈를 그대로 사용하는 [autoSize]입니다.
  Size get size => _size;
  Size _size;

  /// 마커에 텍스트 정보를 표시할 수 있는 캡션입니다.
  ///
  /// [NOverlayCaption] 객체를 사용하여 나타낼 수 있습니다.
  ///
  /// 만약 두개의 캡션을 보이게 하고 싶다면, [subCaption]을 이용하세요.
  NOverlayCaption? get caption => _caption;
  NOverlayCaption? _caption;

  /// 마커에 두번째 텍스트 정보를 표시할 수 있는 보조 캡션입니다.
  ///
  /// [NOverlayCaption] 객체를 사용하여 나타낼 수 있습니다.
  ///
  /// 보조 캡션은 주 캡션인 [caption] 바로 아래에 나타납니다.
  NOverlayCaption? get subCaption => _subCaption;
  NOverlayCaption? _subCaption;

  /// 캡션이 어디에 위치하는 지 나타냅니다.
  ///
  /// 캡션이 겹칠 때를 대비하여, index가 0에 가까운 아이템 순서대로 우선하여 캡션을 위치합니다.
  ///
  /// 캡션이 겹칠 때, 숨기는 옵션인 [isHideCollidedCaptions]가 활성화된다면, 첫번째 요소만 참고합니다.
  ///
  /// 기본 값은 아이콘의 하단에 위치함을 의미하는 [NAlign.bottom]
  List<NAlign> get captionAligns => _captionAligns.toList();
  Iterable<NAlign> _captionAligns;

  /// 아이콘과 캡션 사이의 여백이 얼마나 되는지 나타냅니다.
  /// 단위는 플러터에서 사용하는 것과 같은 논리픽셀(dp)입니다.
  ///
  /// 기본 값은 `0`
  double get captionOffset => _captionOffset;
  double _captionOffset;

  /// 캡션에 원근 효과를 사용할 지 여부를 나타냅니다.
  ///
  /// 기본 값은 `false`
  bool get isCaptionPerspectiveEnabled => _isCaptionPerspectiveEnabled;
  bool _isCaptionPerspectiveEnabled;

  /// 아이콘에 원근 효과를 사용할 지 여부를 나타냅니다.
  ///
  /// 기본 값은 `false`
  bool get isIconPerspectiveEnabled => _isIconPerspectiveEnabled;
  bool _isIconPerspectiveEnabled;

  /// 마커가 평평한지 나타냅니다.
  ///
  /// 평평한 경우, 지도에 떠있는 것이 아닌, 지표면에 달라붙습니다.
  ///
  /// 기본 값은 지도에 떠있는 것을 의미하는 `false`
  bool get isFlat => _isFlat;
  bool _isFlat;

  /// 마커가 다른 마커와 겹쳐 보여지는 상황에서,
  /// 다른 마커에 [isHideCollidedCaptions] 옵션이 `true`로 설정되어
  /// 이 마커의 캡션이 숨겨져야 하는 상황에서,
  /// 무조건 보여주어 해당 옵션을 무시할 지 여부를 나타냅니다.
  ///
  /// 기본값은 `false`
  bool get isForceShowCaption => _isForceShowCaption;
  bool _isForceShowCaption;

  /// 마커가 다른 마커와 겹쳐 보여지는 상황에서,
  /// 다른 마커에 [isHideCollidedCaptions] 옵션이 `true`로 설정되어
  /// 이 마커의 아이콘이 숨겨져야 하는 상황에서,
  /// 무조건 보여주어 해당 옵션을 무시할 지 여부를 나타냅니다.
  ///
  /// 기본값은 `false`
  bool get isForceShowIcon => _isForceShowIcon;
  bool _isForceShowIcon;

  /// 이 마커와 다른 마커가 겹칠 경우, 다른 마커의 캡션을 숨길지 여부를 나타냅니다.
  ///
  /// 기본 값은 `false`
  bool get isHideCollidedCaptions => _isHideCollidedCaptions;
  bool _isHideCollidedCaptions;

  /// 이 마커와 다른 마커가 겹칠 경우, 다른 마커의 아이콘을 숨길지 여부를 나타냅니다.
  ///
  /// 기본 값은 `false`
  bool get isHideCollidedMarkers => _isHideCollidedMarkers;
  bool _isHideCollidedMarkers;

  /// 이 마커와 겹치는 심볼이 있을 경우, 심볼을 숨길지 여부를 나타냅니다.
  ///
  /// 기본 값은 `false`
  bool get isHideCollidedSymbols => _isHideCollidedSymbols;
  bool _isHideCollidedSymbols;

  @override
  // ignore: prefer_final_fields
  int _globalZIndex = 200000;

  NMarker({
    required super.id,
    required NLatLng position,
    NOverlayImage? icon,
    Color iconTintColor = Colors.transparent,
    double alpha = 1,
    double angle = 0,
    NPoint anchor = defaultAnchor,
    Size size = autoSize,
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
        super(type: NOverlayType.marker);

  /*
    --- constant ---
  */

  /// 중앙 하단을 나타냅니다.
  static const defaultAnchor = NPoint(0.5, 1.0);

  /// 마커의 아이콘 사이즈를 그대로 사용함을 나타냅니다.
  static const autoSize = Size(0, 0);

  /*
    --- method ---
  */

  /// [openInfoWindow] 메서드를 통해, 이 마커에 열린 정보창이 있는지 여부를 반환합니다.
  Future<bool> hasOpenInfoWindow() => _runAsync(_hasOpenInfoWindowName);

  /// 이 마커에 정보창을 여는 메서드입니다.
  ///
  /// 여기에 사용되는 정보창은 반드시 [NInfoWindow.onMarker]로 생성되어야 합니다.
  /// 또힌, 다른 마커에 열린 정보창은 재사용할 수 없습니다.
  Future<void> openInfoWindow(NInfoWindow infoWindow,
      {NAlign align = NAlign.top}) async {
    assert(infoWindow.withMarker);
    assert(_isAdded);

    _overlayControllers.forEach(infoWindow._addedOnMap);
    assert(infoWindow._isAdded);

    final messageable =
        NMessageable.forOnceWithMap({"infoWindow": infoWindow, "align": align});
    await _runAsync(_openInfoWindowName, messageable);
  }

  /// 마커의 위치하는 좌표를 지정합니다.
  void setPosition(NLatLng value) {
    _position = value;
    _set(_positionName, _position);
  }

  /// 마커의 아이콘을 지정합니다.
  ///
  /// `null`로 지정하는 경우, 기본 마커 아이콘을 사용합니다.
  void setIcon(NOverlayImage? value) {
    _icon = value;
    _set(_iconName, _icon);
  }

  /// 마커의 아이콘에 덧씌우는(혼합) 색상을 지정합니다. (가산혼합)
  ///
  /// 채도가 있는 곳에 해당 색상이 덧씌워집니다. 단, 알파값은 무시됩니다.
  void setIconTintColor(Color value) {
    _iconTintColor = value;
    _set(_iconTintColorName, _iconTintColor);
  }

  /// 마커의 불투명도를 지정합니다. (0 ~ 1)
  void setAlpha(double value) {
    _alpha = value;
    _set(_alphaName, _alpha);
  }

  /// 마커의 회전 각도를 지정합니다. (0 ~ 360)
  ///
  /// 단위는 도입니다.
  void setAngle(double value) {
    _angle = value;
    _set(_angleName, _angle);
  }

  /// 좌표가 아이콘의 어느 지점에 위치하는 지인 기준점을 지정합니다.
  /// 값 범위는 좌측 상단(0, 0) ~ 우측하단(1, 1)입니다.
  ///
  /// 기본 값은 중앙 하단을 나타내는 [defaultAnchor]입니다.
  void setAnchor(NPoint value) {
    _anchor = value;
    _set(_anchorName, _anchor);
  }

  /// 마커의 아이콘 사이즈를 지정합니다.
  ///
  /// Size에서 사용하는 단위는 플러터 기본 단위인 LogicalPixel(dp) 단위입니다.
  ///
  /// 기본 값은 마커의 아이콘 사이즈를 그대로 사용하는 [autoSize]입니다.
  void setSize(Size value) {
    _size = value;
    _set(_sizeName, _size);
  }

  /// 마커에 텍스트 정보를 표시할 수 있는 캡션을 지정합니다.
  ///
  /// [NOverlayCaption] 객체를 사용하여 나타낼 수 있습니다.
  ///
  /// 만약 두개의 캡션을 보이게 하고 싶다면, [subCaption]을 이용하세요.
  void setCaption(NOverlayCaption? value) {
    _caption = value;
    _set(_captionName, _caption);
  }

  /// 마커에 두번째 텍스트 정보를 표시할 수 있는 보조 캡션을 지정합니다.
  ///
  /// [NOverlayCaption] 객체를 사용하여 나타낼 수 있습니다.
  ///
  /// 보조 캡션은 주 캡션인 [caption] 바로 아래에 나타납니다.
  void setSubCaption(NOverlayCaption? value) {
    _subCaption = value;
    _set(_subCaptionName, _subCaption);
  }

  /// 캡션이 어디에 위치할 지 지정합니다.
  ///
  /// 캡션이 겹칠 때를 대비하여, index가 0에 가까운 아이템 순서대로 우선하여 캡션을 위치합니다.
  ///
  /// 캡션이 겹칠 때, 숨기는 옵션인 [isHideCollidedCaptions]가 활성화된다면, 첫번째 요소만 참고합니다.
  ///
  /// 기본 값은 아이콘의 하단에 위치함을 의미하는 [NAlign.bottom]입니다.
  void setCaptionAligns(Iterable<NAlign> value) {
    _captionAligns = value;
    _set(_captionAlignsName, _captionAligns);
  }

  /// 아이콘과 캡션 사이의 여백이 얼마나 될지 지정합니다.
  /// 단위는 플러터에서 사용하는 것과 같은 논리픽셀(dp)입니다.
  ///
  /// 기본 값은 0입니다.
  void setCaptionOffset(double value) {
    _captionOffset = value;
    _set(_captionOffsetName, _captionOffset);
  }

  /// 캡션에 원근 효과를 사용할 지 여부를 지정합니다.
  ///
  /// 기본 값은 `false`
  void setIsCaptionPerspectiveEnabled(bool value) {
    _isCaptionPerspectiveEnabled = value;
    _set(_isCaptionPerspectiveEnabledName, _isCaptionPerspectiveEnabled);
  }

  /// 아이콘에 원근 효과를 사용할 지 여부를 지정합니다.
  ///
  /// 기본 값은 `false`
  void setIsIconPerspectiveEnabled(bool value) {
    _isIconPerspectiveEnabled = value;
    _set(_isIconPerspectiveEnabledName, _isIconPerspectiveEnabled);
  }

  /// 마커를 평평하게 보여줄지 지정합니다.
  ///
  /// 평평한 경우, 지도에 떠있는 것이 아닌, 지표면에 달라붙습니다.
  ///
  /// 기본 값은 지도에 떠있는 것을 의미하는 `false`
  void setIsFlat(bool value) {
    _isFlat = value;
    _set(_isFlatName, _isFlat);
  }

  /// 마커가 다른 마커와 겹쳐 보여지는 상황에서,
  /// 다른 마커에 [isHideCollidedCaptions] 옵션이 `true`로 설정되어
  /// 이 마커의 캡션이 숨겨져야 하는 상황에서,
  /// 무조건 보여주어 해당 옵션을 무시할 지 여부를 정합니다.
  ///
  /// 기본값은 `false`
  void setIsForceShowCaption(bool value) {
    _isForceShowCaption = value;
    _set(_isForceShowCaptionName, _isForceShowCaption);
  }

  /// 마커가 다른 마커와 겹쳐 보여지는 상황에서,
  /// 다른 마커에 [isHideCollidedCaptions] 옵션이 `true`로 설정되어
  /// 이 마커의 아이콘이 숨겨져야 하는 상황에서,
  /// 무조건 보여주어 해당 옵션을 무시할 지 여부를 정합니다.
  ///
  /// 기본값은 `false`
  void setIsForceShowIcon(bool value) {
    _isForceShowIcon = value;
    _set(_isForceShowIconName, _isForceShowIcon);
  }

  /// 이 마커와 다른 마커가 겹칠 경우, 다른 마커의 캡션을 숨길지 여부를 정합니다.
  ///
  /// 기본 값은 `false`
  void setIsHideCollidedCaptions(bool value) {
    _isHideCollidedCaptions = value;
    _set(_isHideCollidedCaptionsName, _isHideCollidedCaptions);
  }

  /// 이 마커와 다른 마커가 겹칠 경우, 다른 마커의 아이콘을 숨길지 여부를 정합니다.
  ///
  /// 기본 값은 `false`
  void setIsHideCollidedMarkers(bool value) {
    _isHideCollidedMarkers = value;
    _set(_isHideCollidedMarkersName, _isHideCollidedMarkers);
  }

  /// 이 마커와 겹치는 심볼이 있을 경우, 심볼을 숨길지 여부를 정합니다.
  ///
  /// 기본 값은 `false`
  void setHideCollidedSymbols(bool value) {
    _isHideCollidedSymbols = value;
    _set(_isHideCollidedSymbolsName, _isHideCollidedSymbols);
  }

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
        ..._commonMap,
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

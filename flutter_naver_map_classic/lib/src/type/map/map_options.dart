part of "../../../flutter_naver_map.dart";

/// 네이버 맵의 보여지는 여러 UI 속성들을 컨트롤 할 수 있는 옵션들입니다.
/// 다음 문서를 참고하세요 : [NaverMapViewOptions 문서](https://note11.dev/flutter_naver_map/element/widget#navermapviewoptions)
class NaverMapViewOptions with NMessageableWithMap {
  /// 지도가 로드될 때, 첫 카메라 위치(영역)을 지정합니다.
  /// 기본값은 [seoulCityHall]으로, 서울 시청 주변을 보여줍니다.
  final NCameraPosition initialCameraPosition;

  /// 지도에서 사용자가 움직일 수 있는 영역을 제한합니다.
  /// 기본값은 제한 없음(`null`)
  final NLatLngBounds? extent;

  /// 지도의 유형을 선택할 수 있습니다.
  ///
  /// 기본값은 `NMapType.basic`
  final NMapType mapType;

  /// 벡터가 아닌 레스터(픽셀) 기반의 경량 지도를 로드합니다.
  /// [mapType]=[navi]가 아닐 때만 지원합니다.
  ///
  /// 기본값은 `false`
  final bool liteModeEnable;

  /// 야간 모드를 활성화할지 여부입니다.
  /// 야간 모드를 켜면 다크 모드와 유사하게 지도가 어둡게 변합니다.
  /// [mapType]=[navi]일 때만 지원합니다.
  ///
  /// 기본값은 `false`
  final bool nightModeEnable;

  /// 실내 지도를 보여줄지 여부입니다.
  ///
  /// 실내 지도는 [NMapType.basic]과 [NMapType.terrain], 두 가지 지도 유형에서만 사용할 수 있습니다.
  ///
  /// 기본값은 `true`
  final bool indoorEnable;

  /// 활성화 할 레이어 그룹들을 지정할 수 있습니다.
  ///
  /// 기본값은 [NLayerGroup.building]
  final Iterable<NLayerGroup> activeLayerGroups;

  /// 3D로 표현될 때, 빌딩의 높이를 지정합니다.
  /// 0 ~ 1 사이에서 값을 조절할 수 있습니다.
  ///
  /// 기본값은 `1`
  final double buildingHeight;

  /// 지도의 명도를 지정합니다.
  /// -1(어두움, 검정색이 섞임) ~ 1(밝음, 흰색이 섞임) 사이에서 값을 조절할 수 있습니다.
  ///
  /// 기본값은 투명함을 나타내는 `0`
  final double lightness;

  /// 심볼의 크기 배율을 나타냅니다.
  ///
  /// 0 ~ 2(배) 사이에서 값을 조절할 수 있습니다.
  ///
  /// 기본값은 `1`
  final double symbolScale;

  /// 심볼의 원근 효과를 조절합니다. 0~1 사이의 값을 가집니다.
  ///
  /// 기본값은 `1`
  final double symbolPerspectiveRatio;

  /// 실내지도 영역 포커스를 유지하는 반경을 지정합니다. 단위는 논리 픽셀(LogicalPixel, dp)입니다.
  ///
  /// 기본값은 `defaultIndoorFocusDp` (55dp)
  final double indoorFocusRadius;

  /// pickable의 터치 반경을 지정합니다. 단위는 논리 픽셀(LogicalPixel, dp)입니다.
  ///
  /// 기본값은 `defaultPickTolerance` (2dp)
  final double pickTolerance;

  /// 회전 제스처를 활성화할지 여부를 지정합니다.
  ///
  /// 기본값은 `true`
  final bool rotationGesturesEnable;

  /// 스크롤 제스처를 활성화할지 여부를 지정합니다.
  ///
  /// 기본값은 `true`
  final bool scrollGesturesEnable;

  /// 틸트 제스처를 활성화할지 여부를 지정합니다.
  ///
  /// 기본값은 `true`
  final bool tiltGesturesEnable;

  /// 줌 제스처를 활성화할지 여부를 지정합니다.
  ///
  /// 기본값은 `true`
  final bool zoomGesturesEnable;

  /// 스톱 제스처를 활성화할지 여부를 지정합니다.
  ///
  /// 기본값은 `true`
  final bool stopGesturesEnable;

  /// 스크롤 제스처의 마찰 계수를 지정합니다. 0~1 사이의 값을 가집니다.
  ///
  /// 기본값은 `defaultGestureFriction`
  final double scrollGesturesFriction;

  /// 줌 제스처의 마찰 계수를 지정합니다. 0~1 사이의 값을 가집니다.
  ///
  /// 기본값은 `defaultGestureFriction`
  final double zoomGesturesFriction;

  /// 회전 제스처의 마찰 계수를 지정합니다. 0~1 사이의 값을 가집니다.
  ///
  /// 기본값은 `defaultGestureFriction`
  final double rotationGesturesFriction;

  /// 심볼 탭 이벤트를 소비할지 여부를 지정합니다.
  ///
  /// 기본값은 `true`
  final bool consumeSymbolTapEvents;

  /// 축적 바를 활성화할지 여부를 지정합니다.
  ///
  /// 기본값은 `true`
  final bool scaleBarEnable;

  /// 실내 지도 레벨 피커를 활성화할지 여부를 지정합니다.
  ///
  /// 기본값은 `true`
  final bool indoorLevelPickerEnable;

  /// 위치 버튼을 활성화할지 여부를 지정합니다.
  ///
  /// 기본값은 `false`
  final bool locationButtonEnable;

  /// 네이버 로고 클릭을 활성화할지 여부를 지정합니다.
  ///
  /// 기본값은 `true`
  final bool logoClickEnable;

  /// 로고의 위치를 정렬합니다.
  ///
  /// 기본값은 `NLogoAlign.leftBottom`
  final NLogoAlign logoAlign;

  /// 로고의 마진을 설정합니다.
  ///
  /// 기본값은 `defaultLogoMargin`
  final EdgeInsets logoMargin;

  /// 콘텐츠의 패딩을 설정합니다.
  ///
  /// 기본값은 `EdgeInsets.zero`
  final EdgeInsets contentPadding;

  /// 지도의 최소 줌 레벨을 설정합니다.
  ///
  /// 기본값은 `minimumZoom` (0.0)
  final double minZoom;

  /// 지도의 최대 줌 레벨을 설정합니다.
  ///
  /// 기본값은 `maximumZoom` (21.0)
  final double maxZoom;

  /// 지도의 최대 틸트 각도를 설정합니다. 단위는 도입니다.
  ///
  /// 기본값은 지도가 지원하는 최대 각도인 `63`(도)
  final double maxTilt;

  /// 지도의 언어를 설정합니다. (한국어, 영어, 일어, 중국어 지원)
  ///
  /// 기본값은 시스템 언어를 따르는 `NLocale.systemLocale`
  final Locale locale;

  /// 커스텀 스타일 ID.
  ///
  /// 기본값은 커스텀 스타일을 사용하지 않음을 의미하는 null입니다.
  final String? customStyleId;

  const NaverMapViewOptions({
    this.initialCameraPosition = seoulCityHall,
    this.extent,
    this.mapType = NMapType.basic,
    this.liteModeEnable = false,
    this.nightModeEnable = false,
    this.indoorEnable = false,
    this.activeLayerGroups = const [NLayerGroup.building],
    this.buildingHeight = 1,
    this.lightness = 0,
    this.symbolScale = 1,
    this.symbolPerspectiveRatio = 1,
    this.indoorFocusRadius = defaultIndoorFocusDp,
    this.pickTolerance = defaultPickTolerance,
    this.rotationGesturesEnable = true,
    this.scrollGesturesEnable = true,
    this.tiltGesturesEnable = true,
    this.zoomGesturesEnable = true,
    this.stopGesturesEnable = true,
    this.scrollGesturesFriction = defaultScrollGesturesFriction,
    this.zoomGesturesFriction = defaultZoomGesturesFriction,
    this.rotationGesturesFriction = defaultRotationGesturesFriction,
    this.consumeSymbolTapEvents = true,
    this.scaleBarEnable = true,
    this.indoorLevelPickerEnable = true,
    this.locationButtonEnable = false,
    this.logoClickEnable = true,
    this.logoAlign = NLogoAlign.leftBottom,
    this.logoMargin = defaultLogoMargin,
    this.contentPadding = EdgeInsets.zero,
    this.minZoom = minimumZoom,
    this.maxZoom = maximumZoom,
    this.maxTilt = 63,
    this.locale = NLocale.systemLocale,
    this.customStyleId,
  });

  @override
  NPayload toNPayload() => NPayload.make({
        "initialCameraPosition": initialCameraPosition,
        "extent": extent,
        "mapType": mapType,
        "liteModeEnable": liteModeEnable,
        "nightModeEnable": nightModeEnable,
        "indoorEnable": indoorEnable,
        "activeLayerGroups": activeLayerGroups,
        "buildingHeight": buildingHeight,
        "lightness": lightness,
        "symbolScale": symbolScale,
        "symbolPerspectiveRatio": symbolPerspectiveRatio,
        "indoorFocusRadius": indoorFocusRadius,
        "pickTolerance": pickTolerance,
        "rotationGesturesEnable": rotationGesturesEnable,
        "scrollGesturesEnable": scrollGesturesEnable,
        "tiltGesturesEnable": tiltGesturesEnable,
        "zoomGesturesEnable": zoomGesturesEnable,
        "stopGesturesEnable": stopGesturesEnable,
        "scrollGesturesFriction": scrollGesturesFriction,
        "zoomGesturesFriction": zoomGesturesFriction,
        "rotationGesturesFriction": rotationGesturesFriction,
        "consumeSymbolTapEvents": consumeSymbolTapEvents,
        "scaleBarEnable": scaleBarEnable,
        "indoorLevelPickerEnable": indoorLevelPickerEnable,
        "locationButtonEnable": locationButtonEnable,
        "logoClickEnable": logoClickEnable,
        "logoAlign": logoAlign,
        "logoMargin": logoMargin,
        "contentPadding": contentPadding,
        "minZoom": minZoom,
        "maxZoom": maxZoom,
        "maxTilt": maxTilt,
        "locale": locale,
        "customStyleId": customStyleId,
      }, sendNull: true);

  @override
  String toString() => "$runtimeType: ${toNPayload().map}";

  NaverMapViewOptions copyWith({
    NCameraPosition? initialCameraPosition,
    NLatLngBounds? extent,
    NMapType? mapType,
    bool? liteModeEnable,
    bool? nightModeEnable,
    bool? indoorEnable,
    Iterable<NLayerGroup>? activeLayerGroups,
    double? buildingHeight,
    double? lightness,
    double? symbolScale,
    double? symbolPerspectiveRatio,
    double? indoorFocusRadius,
    double? pickTolerance,
    bool? rotationGesturesEnable,
    bool? scrollGesturesEnable,
    bool? tiltGesturesEnable,
    bool? zoomGesturesEnable,
    bool? stopGesturesEnable,
    double? scrollGesturesFriction,
    double? zoomGesturesFriction,
    double? rotationGesturesFriction,
    bool? consumeSymbolTapEvents,
    bool? scaleBarEnable,
    bool? indoorLevelPickerEnable,
    bool? locationButtonEnable,
    bool? logoClickEnable,
    NLogoAlign? logoAlign,
    EdgeInsets? logoMargin,
    EdgeInsets? contentPadding,
    double? minZoom,
    double? maxZoom,
    double? maxTilt,
    Locale? locale,
    String? customStyleId,
  }) =>
      NaverMapViewOptions(
        initialCameraPosition:
            initialCameraPosition ?? this.initialCameraPosition,
        extent: extent ?? this.extent,
        mapType: mapType ?? this.mapType,
        liteModeEnable: liteModeEnable ?? this.liteModeEnable,
        nightModeEnable: nightModeEnable ?? this.nightModeEnable,
        indoorEnable: indoorEnable ?? this.indoorEnable,
        activeLayerGroups: activeLayerGroups ?? this.activeLayerGroups,
        buildingHeight: buildingHeight ?? this.buildingHeight,
        lightness: lightness ?? this.lightness,
        symbolScale: symbolScale ?? this.symbolScale,
        symbolPerspectiveRatio:
            symbolPerspectiveRatio ?? this.symbolPerspectiveRatio,
        indoorFocusRadius: indoorFocusRadius ?? this.indoorFocusRadius,
        pickTolerance: pickTolerance ?? this.pickTolerance,
        rotationGesturesEnable:
            rotationGesturesEnable ?? this.rotationGesturesEnable,
        scrollGesturesEnable: scrollGesturesEnable ?? this.scrollGesturesEnable,
        tiltGesturesEnable: tiltGesturesEnable ?? this.tiltGesturesEnable,
        zoomGesturesEnable: zoomGesturesEnable ?? this.zoomGesturesEnable,
        stopGesturesEnable: stopGesturesEnable ?? this.stopGesturesEnable,
        scrollGesturesFriction:
            scrollGesturesFriction ?? this.scrollGesturesFriction,
        zoomGesturesFriction: zoomGesturesFriction ?? this.zoomGesturesFriction,
        rotationGesturesFriction:
            rotationGesturesFriction ?? this.rotationGesturesFriction,
        consumeSymbolTapEvents:
            consumeSymbolTapEvents ?? this.consumeSymbolTapEvents,
        scaleBarEnable: scaleBarEnable ?? this.scaleBarEnable,
        indoorLevelPickerEnable:
            indoorLevelPickerEnable ?? this.indoorLevelPickerEnable,
        locationButtonEnable: locationButtonEnable ?? this.locationButtonEnable,
        logoClickEnable: logoClickEnable ?? this.logoClickEnable,
        logoAlign: logoAlign ?? this.logoAlign,
        logoMargin: logoMargin ?? this.logoMargin,
        contentPadding: contentPadding ?? this.contentPadding,
        minZoom: minZoom ?? this.minZoom,
        maxZoom: maxZoom ?? this.maxZoom,
        maxTilt: maxTilt ?? this.maxTilt,
        locale: locale ?? this.locale,
        customStyleId: customStyleId ?? this.customStyleId,
      );

  /*
    --- Constants ---
  */

  static const seoulCityHall =
      NCameraPosition(target: NLatLng(37.5666, 126.979), zoom: 14);
  static const defaultIndoorFocusDp = 56.0;
  static const defaultPickTolerance = 2.0;
  static const minimumZoom = 0.0;
  static const maximumZoom = 21.0;
  static const defaultScrollGesturesFriction = 0.088;
  static const defaultZoomGesturesFriction = 0.12375;
  static const defaultRotationGesturesFriction = 0.19333;
  static const defaultLogoMargin =
      EdgeInsets.symmetric(horizontal: 12, vertical: 16);

  /*
    --- Equal ---
  */

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NaverMapViewOptions &&
          runtimeType == other.runtimeType &&
          initialCameraPosition == other.initialCameraPosition &&
          extent == other.extent &&
          mapType == other.mapType &&
          liteModeEnable == other.liteModeEnable &&
          nightModeEnable == other.nightModeEnable &&
          indoorEnable == other.indoorEnable &&
          activeLayerGroups == other.activeLayerGroups &&
          buildingHeight == other.buildingHeight &&
          lightness == other.lightness &&
          symbolScale == other.symbolScale &&
          symbolPerspectiveRatio == other.symbolPerspectiveRatio &&
          indoorFocusRadius == other.indoorFocusRadius &&
          pickTolerance == other.pickTolerance &&
          rotationGesturesEnable == other.rotationGesturesEnable &&
          scrollGesturesEnable == other.scrollGesturesEnable &&
          tiltGesturesEnable == other.tiltGesturesEnable &&
          zoomGesturesEnable == other.zoomGesturesEnable &&
          stopGesturesEnable == other.stopGesturesEnable &&
          scrollGesturesFriction == other.scrollGesturesFriction &&
          zoomGesturesFriction == other.zoomGesturesFriction &&
          rotationGesturesFriction == other.rotationGesturesFriction &&
          consumeSymbolTapEvents == other.consumeSymbolTapEvents &&
          scaleBarEnable == other.scaleBarEnable &&
          indoorLevelPickerEnable == other.indoorLevelPickerEnable &&
          locationButtonEnable == other.locationButtonEnable &&
          logoClickEnable == other.logoClickEnable &&
          logoAlign == other.logoAlign &&
          logoMargin == other.logoMargin &&
          contentPadding == other.contentPadding &&
          minZoom == other.minZoom &&
          maxZoom == other.maxZoom &&
          maxTilt == other.maxTilt &&
          locale == other.locale &&
          customStyleId == other.customStyleId;

  @override
  int get hashCode =>
      initialCameraPosition.hashCode ^
      extent.hashCode ^
      mapType.hashCode ^
      liteModeEnable.hashCode ^
      nightModeEnable.hashCode ^
      indoorEnable.hashCode ^
      activeLayerGroups.hashCode ^
      buildingHeight.hashCode ^
      lightness.hashCode ^
      symbolScale.hashCode ^
      symbolPerspectiveRatio.hashCode ^
      indoorFocusRadius.hashCode ^
      pickTolerance.hashCode ^
      rotationGesturesEnable.hashCode ^
      scrollGesturesEnable.hashCode ^
      tiltGesturesEnable.hashCode ^
      zoomGesturesEnable.hashCode ^
      stopGesturesEnable.hashCode ^
      scrollGesturesFriction.hashCode ^
      zoomGesturesFriction.hashCode ^
      rotationGesturesFriction.hashCode ^
      consumeSymbolTapEvents.hashCode ^
      scaleBarEnable.hashCode ^
      indoorLevelPickerEnable.hashCode ^
      locationButtonEnable.hashCode ^
      logoClickEnable.hashCode ^
      logoAlign.hashCode ^
      logoMargin.hashCode ^
      contentPadding.hashCode ^
      minZoom.hashCode ^
      maxZoom.hashCode ^
      maxTilt.hashCode ^
      locale.hashCode ^
      customStyleId.hashCode;
}

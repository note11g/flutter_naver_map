part of flutter_naver_map;

class NaverMapViewOptions with NMessageableWithMap {
  final NCameraPosition? initialCameraPosition;
  final NLatLngBounds? extent;
  final NMapType mapType;

  /// mapType 이 navi 면, 사용할 수 없습니다.
  final bool liteModeEnable;

  /// mapType 이 navi 가 아니면, 사용할 수 없습니다.
  final bool nightModeEnable;

  final bool indoorEnable;
  final Iterable<NLayerGroup> activeLayerGroups;
  final double buildingHeight;
  final double lightness;
  final double symbolScale;
  final double symbolPerspectiveRatio;
  final double indoorFocusRadius;
  final double pickTolerance;
  final bool rotationGesturesEnable;
  final bool scrollGesturesEnable;
  final bool tiltGesturesEnable;
  final bool zoomGesturesEnable;
  final bool stopGesturesEnable;
  final double scrollGesturesFriction;
  final double zoomGesturesFriction;
  final double rotationGesturesFriction;
  final bool consumeSymbolTapEvents;
  final bool scaleBarEnable;
  final bool indoorLevelPickerEnable;
  final bool locationButtonEnable;
  final bool logoClickEnable;
  final NLogoAlign logoAlign;
  final EdgeInsets? logoMargin;
  final EdgeInsets contentPadding;
  final double minZoom;
  final double maxZoom;
  final double maxTilt;
  final Locale locale;

  const NaverMapViewOptions({
    this.initialCameraPosition,
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
    this.scrollGesturesFriction = defaultGestureFriction,
    this.zoomGesturesFriction = defaultGestureFriction,
    this.rotationGesturesFriction = defaultGestureFriction,
    this.consumeSymbolTapEvents = true,
    this.scaleBarEnable = true,
    this.indoorLevelPickerEnable = true,
    this.locationButtonEnable = false,
    this.logoClickEnable = true,
    this.logoAlign = NLogoAlign.leftBottom,
    this.logoMargin,
    this.contentPadding = EdgeInsets.zero,
    this.minZoom = minimumZoom,
    this.maxZoom = maximumZoom,
    this.maxTilt = 63,
    this.locale = NLocale.systemLocale,
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
      });

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
      );

  /*
    --- Constants ---
  */

  static const defaultGestureFriction = -1.0;
  static const defaultIndoorFocusDp = 55.0;
  static const defaultPickTolerance = 2.0;
  static const minimumZoom = 0.0;
  static const maximumZoom = 21.0;

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
          locale == other.locale;

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
      locale.hashCode;
}

package dev.note11.flutter_naver_map.flutter_naver_map.applier.option

internal interface NaverMapOptionApplier {
    fun setInitialCameraPosition(rawPosition: Any)
    fun setExtent(rawLatLngBounds: Any?)
    fun setMapType(rawMapType: Any)
    fun setLiteModeEnable(rawEnable: Any)
    fun setNightModeEnable(rawEnable: Any)
    fun setIndoorEnable(rawEnable: Any)
    fun setActiveLayerGroups(rawLayerGroups: Any)
    fun setBuildingHeight(rawHeight: Any)
    fun setLightness(rawLightness: Any)
    fun setSymbolScale(rawScale: Any)
    fun setSymbolPerspectiveRatio(rawRatio: Any)
    fun setIndoorFocusRadius(rawDp: Any)
    fun setPickTolerance(rawDp: Any)
    fun setRotationGesturesEnable(rawEnable: Any)
    fun setScrollGesturesEnable(rawEnable: Any)
    fun setTiltGesturesEnable(rawEnable: Any)
    fun setZoomGesturesEnable(rawEnable: Any)
    fun setStopGesturesEnable(rawEnable: Any)
    fun setScrollGesturesFriction(rawFriction: Any)
    fun setZoomGesturesFriction(rawFriction: Any)
    fun setRotationGesturesFriction(rawFriction: Any)
    fun setIndoorLevelPickerEnable(rawEnable: Any)
    fun setLogoAlign(rawAlign: Any)
    fun setLogoMargin(rawEdgeInsets: Any)
    fun setContentPadding(rawEdgeInsets: Any)
    fun setMinZoom(rawLevel: Any)
    fun setMaxZoom(rawLevel: Any)
    fun setMaxTilt(rawTilt: Any)
    fun setLocale(rawLocale: Any)
    fun setCustomStyleId(rawCustomStyleId: Any?)
}
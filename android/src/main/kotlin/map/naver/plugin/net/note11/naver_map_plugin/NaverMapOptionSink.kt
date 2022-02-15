package map.naver.plugin.net.note11.naver_map_plugin

interface NaverMapOptionSink {
    fun setNightModeEnable(nightModeEnable: Boolean)
    fun setLiteModeEnable(liteModeEnable: Boolean)
    fun setIndoorEnable(indoorEnable: Boolean)
    fun setMapType(typeIndex: Int)
    fun setBuildingHeight(buildingHeight: Double)
    fun setSymbolScale(symbolScale: Double)
    fun setSymbolPerspectiveRatio(symbolPerspectiveRatio: Double)
    fun setActiveLayers(activeLayers: List<Any?>?)
    fun setLocationButtonEnable(locationButtonEnable: Boolean)
    fun setContentPadding(paddingData: List<Double>?)
    fun setMaxZoom(maxZoom: Double)
    fun setMinZoom(minZoom: Double)

    /**
     * flutter 에서 setState()로 값을 변경해도 반영되지 않는 method. 최초 생성시에만 값변경.
     */
    fun setRotationGestureEnable(rotationGestureEnable: Boolean)
    fun setScrollGestureEnable(scrollGestureEnable: Boolean)
    fun setTiltGestureEnable(tiltGestureEnable: Boolean)
    fun setZoomGestureEnable(zoomGestureEnable: Boolean)
    fun setLocationTrackingMode(locationTrackingMode: Int)
}
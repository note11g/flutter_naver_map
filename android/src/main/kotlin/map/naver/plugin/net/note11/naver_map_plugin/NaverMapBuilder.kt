package map.naver.plugin.net.note11.naver_map_plugin

import android.app.Activity
import com.naver.maps.map.NaverMapOptions
import io.flutter.plugin.common.BinaryMessenger
import android.content.Context
import android.util.Log
import com.naver.maps.map.NaverMap.MapType
import com.naver.maps.map.NaverMap
import map.naver.plugin.net.note11.naver_map_plugin.Convert.toCameraPosition
import java.util.concurrent.atomic.AtomicInteger

class NaverMapBuilder : NaverMapOptionSink {
    private val options = NaverMapOptions()
    private var locationTrackingMode = 0
    private var paddingData: List<Double>? = null
    private var initialMarkers: List<Any?>? = null
    private var initialPaths: List<Any?>? = null
    private var initialCircles: List<Any?>? = null
    private var initialPolygon: List<Any?>? = null

    fun build(
        id: Int, context: Context?, state: AtomicInteger?, binaryMessenger: BinaryMessenger?,
        activity: Activity?
    ): NaverMapController {
        val controller = NaverMapController(
            id,
            context!!,
            state!!,
            binaryMessenger,
            activity!!,
            options,
            initialMarkers!!,
            initialPaths!!,
            initialCircles!!,
            initialPolygon!!
        ).apply {
            init()
            setLocationTrackingMode(locationTrackingMode)
            setContentPadding(paddingData)
        }
        return controller
    }

    override fun setNightModeEnable(nightModeEnable: Boolean) {
        options.nightModeEnabled(nightModeEnable)
    }

    override fun setLiteModeEnable(liteModeEnable: Boolean) {
        options.liteModeEnabled(liteModeEnable)
    }

    override fun setIndoorEnable(indoorEnable: Boolean) {
        options.indoorEnabled(indoorEnable)
        options.indoorLevelPickerEnabled(indoorEnable)
    }

    override fun setMapType(typeIndex: Int) {
        val type: MapType = when (typeIndex) {
            1 -> MapType.Navi
            2 -> MapType.Satellite
            3 -> MapType.Hybrid
            4 -> MapType.Terrain
            else -> MapType.Basic
        }
        options.mapType(type)
    }

    override fun setBuildingHeight(buildingHeight: Double) {
        options.buildingHeight(buildingHeight.toFloat())
    }

    override fun setSymbolScale(symbolScale: Double) {
        options.symbolScale(symbolScale.toFloat())
    }

    override fun setSymbolPerspectiveRatio(symbolPerspectiveRatio: Double) {
        options.symbolPerspectiveRatio(symbolPerspectiveRatio.toFloat())
    }

    override fun setActiveLayers(activeLayers: List<Int>?) {
        if (activeLayers.isNullOrEmpty()) return
        // 0~5까지의 길이 6개인 리스트 생성 (전체 레이어 타입들.)
        val initList = mutableListOf<Int>()
        for (i in 0..5) initList.add(i)

        // 받은 리스트에 있는 것들을 활성화후 initList 에서 제거
        for (i in activeLayers.indices) {
            val index = activeLayers[i]
            if (initList.contains(index)) initList.remove(Integer.valueOf(index))
            when (index) {
                0 -> options.enabledLayerGroups(NaverMap.LAYER_GROUP_BUILDING)
                1 -> options.enabledLayerGroups(NaverMap.LAYER_GROUP_TRAFFIC)
                2 -> options.enabledLayerGroups(NaverMap.LAYER_GROUP_TRANSIT)
                3 -> options.enabledLayerGroups(NaverMap.LAYER_GROUP_BICYCLE)
                4 -> options.enabledLayerGroups(NaverMap.LAYER_GROUP_MOUNTAIN)
                5 -> options.enabledLayerGroups(NaverMap.LAYER_GROUP_CADASTRAL)
            }
        }

        // initList 에 남은 인덱스들로 레이어 disable.
        if (initList.size == 0) return
        for (idx in initList) {
            when (idx) {
                0 -> options.disabledLayerGroups(NaverMap.LAYER_GROUP_BUILDING)
                1 -> options.disabledLayerGroups(NaverMap.LAYER_GROUP_TRAFFIC)
                2 -> options.disabledLayerGroups(NaverMap.LAYER_GROUP_TRANSIT)
                3 -> options.disabledLayerGroups(NaverMap.LAYER_GROUP_BICYCLE)
                4 -> options.disabledLayerGroups(NaverMap.LAYER_GROUP_MOUNTAIN)
                5 -> options.disabledLayerGroups(NaverMap.LAYER_GROUP_CADASTRAL)
            }
        }
    }

    override fun setRotationGestureEnable(rotationGestureEnable: Boolean) {
        options.rotateGesturesEnabled(rotationGestureEnable)
    }

    override fun setScrollGestureEnable(scrollGestureEnable: Boolean) {
        options.scrollGesturesEnabled(scrollGestureEnable)
    }

    override fun setTiltGestureEnable(tiltGestureEnable: Boolean) {
        options.tiltGesturesEnabled(tiltGestureEnable)
    }

    override fun setZoomGestureEnable(zoomGestureEnable: Boolean) {
        options.zoomGesturesEnabled(zoomGestureEnable)
        options.zoomControlEnabled(false)
    }

    override fun setLocationButtonEnable(locationButtonEnable: Boolean) {
        options.indoorLevelPickerEnabled(true)
            .zoomControlEnabled(false)
            .compassEnabled(false)
        options.locationButtonEnabled(locationButtonEnable)
    }

    override fun setLogoClickEnable(clickEnable: Boolean) {
        options.logoClickEnabled(clickEnable)
    }

    override fun setLocationTrackingMode(locationTrackingMode: Int) {
        this.locationTrackingMode = locationTrackingMode
    }

    override fun setContentPadding(paddingData: List<Double>?) {
        this.paddingData = paddingData
    }

    override fun setMaxZoom(maxZoom: Double) {
        options.maxZoom(maxZoom)
    }

    override fun setMinZoom(minZoom: Double) {
        options.minZoom(minZoom)
    }

    fun setInitialCameraPosition(cameraPosition: Map<String, Any?>?) {
        options.camera(cameraPosition!!.toCameraPosition())
        Log.d("setInitialCamera", cameraPosition.toString())
    }

    fun setViewType(useSurface: Boolean) {
        options.useTextureView(!useSurface)
    }

    fun setInitialMarkers(initialMarkers: List<Any?>?) {
        this.initialMarkers = initialMarkers
    }

    fun setInitialCircles(initialCircles: List<Any?>?) {
        this.initialCircles = initialCircles
    }

    fun setInitialPaths(initialPaths: List<Any?>?) {
        this.initialPaths = initialPaths
    }

    fun setInitialPolygon(initialPolygon: List<Any?>?) {
        this.initialPolygon = initialPolygon
    }
}
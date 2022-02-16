package map.naver.plugin.net.note11.naver_map_plugin

import map.naver.plugin.net.note11.naver_map_plugin.Convert.carveMapOptions
import map.naver.plugin.net.note11.naver_map_plugin.Convert.cameraPositionToJson
import map.naver.plugin.net.note11.naver_map_plugin.Convert.toLatLng
import io.flutter.plugin.common.BinaryMessenger
import android.app.Activity
import com.naver.maps.map.NaverMapOptions
import io.flutter.plugin.platform.PlatformView
import com.naver.maps.map.OnMapReadyCallback
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import android.app.Application.ActivityLifecycleCallbacks
import android.content.Context
import com.naver.maps.map.MapView
import io.flutter.plugin.common.MethodChannel
import com.naver.maps.map.NaverMap
import com.naver.maps.map.util.FusedLocationSource
import com.naver.maps.map.LocationTrackingMode
import io.flutter.plugin.common.MethodCall
import com.naver.maps.map.CameraAnimation
import android.graphics.Bitmap
import android.os.Bundle
import android.view.View
import com.naver.maps.map.NaverMap.MapType
import io.flutter.Log
import map.naver.plugin.net.note11.naver_map_plugin.Convert.latLngBoundsToJson
import map.naver.plugin.net.note11.naver_map_plugin.Convert.toCameraUpdate
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.lang.IllegalArgumentException
import java.util.HashMap
import java.util.concurrent.atomic.AtomicInteger
import kotlin.math.roundToInt

class NaverMapController(
    id: Int,
    context: Context,
    private val activityState: AtomicInteger,
    binaryMessenger: BinaryMessenger?,
    private val activity: Activity,
    options: NaverMapOptions?,
    private val initialMarkers: List<Any?>,
    private val initialPaths: List<Any?>,
    private val initialCircles: List<Any?>,
    private val initialPolygons: List<Any?>
) : PlatformView,
    OnMapReadyCallback,
    MethodCallHandler,
    ActivityLifecycleCallbacks,
    NaverMapOptionSink {

    private val mapView: MapView = MapView(context, options)
    private val methodChannel: MethodChannel =
        MethodChannel(binaryMessenger, "naver_map_plugin_$id")
    private val registrarActivityHashCode: Int = activity.hashCode()
    private lateinit var naverMap: NaverMap
    private var disposed = false
    private var mapReadyResult: MethodChannel.Result? = null
    private var locationTrackingMode = 0
    private var paddingData: List<Double>? = null
    private var maxZoom = 0.0
    private var minZoom = 0.0
    private val density: Float = context.resources.displayMetrics.density
    private lateinit var pathsController: NaverPathsController
    private lateinit var markerController: NaverMarkerController
    private lateinit var circleController: NaverCircleController
    private lateinit var polygonController: NaverPolygonController

    init {
        methodChannel.setMethodCallHandler(this)
    }

    override fun onMapReady(naverMap: NaverMap) {
        this.naverMap = naverMap

        this.naverMap.uiSettings.run {
            // 제대로 동작하지 않는 컨트롤러 UI로 원인이 밝혀지기 전까진 강제 비활성화.
            isZoomControlEnabled = false
            isIndoorLevelPickerEnabled = false

            // 네이버 로고 선택시 Crash 나는 현상 방지
            isLogoClickEnabled = false
        }

        if (mapReadyResult != null) {
            mapReadyResult!!.success(null)
            mapReadyResult = null
        }

        val listeners = NaverMapListeners(methodChannel, mapView.context, naverMap)

        naverMap.run {
            onMapClickListener = listeners
            onMapDoubleTapListener = listeners
            onMapLongClickListener = listeners
            onMapTwoFingerTapListener = listeners
            onSymbolClickListener = listeners
            addOnCameraChangeListener(listeners)
            addOnCameraIdleListener(listeners)
            locationSource = FusedLocationSource(activity, 0xAAFF)
        }

        /// 초기 설정값 빈영
        setLocationTrackingMode(locationTrackingMode)
        setContentPadding(paddingData)

        // 맵 완전히 만들어진 이후에 오버레이 추가.
        // - 패스
        pathsController = NaverPathsController(naverMap, listeners, density)
        pathsController.set(initialPaths)

        // - 마커
        markerController =
            NaverMarkerController(naverMap, listeners, density, mapView.context)
        markerController.add(initialMarkers)

        // - 원형 오버레이
        circleController = NaverCircleController(naverMap, listeners, density)
        circleController.add(initialCircles)


        // - 폴리곤 오버레이
        polygonController = NaverPolygonController(naverMap, listeners, density)
        polygonController.add(initialPolygons)
    }

    override fun getView(): View = mapView

    fun init() {
        when (activityState.get()) {
            NaverMapPlugin.STOPPED -> {
                mapView.onCreate(null)
                mapView.onStart()
                mapView.onResume()
                mapView.onPause()
                mapView.onStop()
            }
            NaverMapPlugin.PAUSED -> {
                mapView.onCreate(null)
                mapView.onStart()
                mapView.onResume()
                mapView.onPause()
            }
            NaverMapPlugin.RESUMED -> {
                mapView.onCreate(null)
                mapView.onStart()
                mapView.onResume()
            }
            NaverMapPlugin.STARTED -> {
                mapView.onCreate(null)
                mapView.onStart()
            }
            NaverMapPlugin.CREATED -> mapView.onCreate(null)
            NaverMapPlugin.DESTROYED -> {}
            else -> throw IllegalArgumentException(
                "Cannot interpret " + activityState.get() + " as an activity state"
            )
        }
        activity.application.registerActivityLifecycleCallbacks(this)
        mapView.getMapAsync(this)
    }

    override fun dispose() {
        if (disposed) return
        disposed = true
        naverMap.locationTrackingMode = LocationTrackingMode.None
        methodChannel.setMethodCallHandler(null)
        mapView.onDestroy()
        activity.application.unregisterActivityLifecycleCallbacks(this)
    }

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        when (methodCall.method) {
            "map#waitForMap" -> {
                if (::naverMap.isInitialized) {
                    result.success(null)
                } else {
                    mapReadyResult = result
                }
            }
            "map#update" -> {
                carveMapOptions(this, methodCall.argument<Map<String, Any>>("options")!!)
                result.success(true)
            }
            "map#getVisibleRegion" -> {
                if (::naverMap.isInitialized) {
                    val latLngBounds = naverMap.contentBounds
                    result.success(latLngBoundsToJson(latLngBounds))
                } else {
                    result.error(
                        "네이버맵 초기화 안됨.",
                        "네이버 지도가 생성되기 전에 이 메서드를 사용할 수 없습니다.",
                        null
                    )
                }
            }
            "map#getPosition" -> {
                if (::naverMap.isInitialized) {
                    val position = naverMap.cameraPosition
                    result.success(cameraPositionToJson(position))
                } else result.error(
                    "네이버맵 초기화 안됨.",
                    "네이버 지도가 생성되기 전에 이 메서드를 사용할 수 없습니다.",
                    null
                )
            }
            "map#getSize" -> {
                if (::naverMap.isInitialized) {
                    val data: MutableMap<String, Int> = HashMap()
                    data["width"] = naverMap.width
                    data["height"] = naverMap.height
                    result.success(data)
                } else result.error(
                    "네이버맵 초기화 안됨.",
                    "네이버 지도가 생성되기 전에 이 메서드를 사용할 수 없습니다.",
                    null
                )
            }
            "camera#move" -> {
                if (::naverMap.isInitialized) {
                    val update = methodCall.argument<Map<String, Any>>("cameraUpdate")!!
                        .toCameraUpdate(density)

                    val isAnimate = methodCall.argument<Boolean>("animation") ?: true
                    if(isAnimate) update.animate(CameraAnimation.Easing)
                    update.finishCallback{
                        result.success(null)
                    }
                    update.cancelCallback{
                        result.success(null)
                    }
                    naverMap.moveCamera(update)
                } else result.error(
                    "네이버맵 초기화 안됨.",
                    "네이버 지도가 생성되기 전에 이 메서드를 사용할 수 없습니다.",
                    null
                )
            }
            "meter#dp" -> {
                if (::naverMap.isInitialized) {
                    result.success(naverMap.projection.metersPerDp)
                } else {
                    Log.e("getMeterPerDp", "네이버맵이 초기화되지 않았습니다.")
                    result.success(null)
                }
            }
            "meter#px" -> {
                if (::naverMap.isInitialized) {
                    result.success(naverMap.projection.metersPerPixel)
                } else {
                    Log.e("getMeterPerDp", "네이버맵이 초기화되지 않았습니다.")
                    result.success(null)
                }
            }
            "markers#update" -> {
                val markersToAdd = methodCall.argument<List<Any?>>("markersToAdd")
                val markersToChange = methodCall.argument<List<Any?>>("markersToChange")
                val markerIdsToRemove = methodCall.argument<List<Any?>>("markerIdsToRemove")
                markerController.run {
                    add(markersToAdd)
                    modify(markersToChange)
                    remove(markerIdsToRemove)
                }
                result.success(null)
            }
            "pathOverlay#update" -> {
                val pathToAddOrUpdate = methodCall.argument<List<Any?>>("pathToAddOrUpdate")
                val pathToRemove = methodCall.argument<List<Any?>>("pathIdsToRemove")
                pathsController.run {
                    set(pathToAddOrUpdate)
                    remove(pathToRemove)
                }
                result.success(null)
            }
            "tracking#mode" -> {
                if (::naverMap.isInitialized) {
                    when (methodCall.argument<Int>("locationTrackingMode")) {
                        0 -> naverMap.locationTrackingMode = LocationTrackingMode.None
                        1 -> naverMap.locationTrackingMode = LocationTrackingMode.NoFollow
                        2 -> naverMap.locationTrackingMode = LocationTrackingMode.Follow
                        else -> naverMap.locationTrackingMode = LocationTrackingMode.Face
                    }
                    result.success(null)
                } else result.error(
                    "네이버맵 초기화 안됨.",
                    "네이버 지도가 생성되기 전에 이 메서드를 사용할 수 없습니다.",
                    null
                )
            }
            "map#type" -> {
                if (::naverMap.isInitialized) {
                    setMapType(methodCall.argument<Int>("mapType")!!)
                } else result.error(
                    "네이버맵 초기화 안됨.",
                    "네이버 지도가 생성되기 전에 이 메서드를 사용할 수 없습니다.",
                    null
                )
            }
            "map#padding" -> {
                if (::naverMap.isInitialized) {
                    val left = methodCall.argument<Float>("left")!!
                    val right = methodCall.argument<Float>("right")!!
                    val top = methodCall.argument<Float>("top")!!
                    val bottom = methodCall.argument<Float>("bottom")!!
                    setContentPadding(left, top, right, bottom)
                }
                result.success(null)
            }
            "map#capture" -> {
                if (::naverMap.isInitialized) naverMap.takeSnapshot { snapshot: Bitmap ->
                    treatCapture(snapshot)
                }
                result.success(null)
            }
            "circleOverlay#update" -> {
                val circlesToAdd = methodCall.argument<List<Any?>>("circlesToAdd")
                val circleIdsToRemove = methodCall.argument<List<Any?>>("circleIdsToRemove")
                val circlesToChange = methodCall.argument<List<Any?>>("circlesToChange")
                circleController.run {
                    add(circlesToAdd)
                    remove(circleIdsToRemove)
                    modify(circlesToChange)
                }
                result.success(null)
            }
            "polygonOverlay#update" -> {
                val polygonToAdd = methodCall.argument<List<Any?>>("polygonToAdd")
                val polygonToRemove = methodCall.argument<List<Any?>>("polygonToRemove")
                val polygonToModify = methodCall.argument<List<Any?>>("polygonToChange")
                polygonController.run {
                    add(polygonToAdd)
                    modify(polygonToModify)
                    remove(polygonToRemove)
                }
                result.success(null)
            }
            "LO#set#position" -> {
                if (::naverMap.isInitialized) {
                    val position = methodCall.argument<Any>("position")!!.toLatLng()
                    naverMap.locationOverlay.position = position
                    result.success(null)
                } else result.error(
                    "네이버맵 초기화 안됨.",
                    "네이버 지도가 생성되기 전에 이 메서드를 사용할 수 없습니다.",
                    null
                )
            }
            "LO#set#bearing" -> {
                if (::naverMap.isInitialized) {
                    naverMap.locationOverlay.bearing = methodCall.argument<Float>("bearing")!!
                    result.success(null)
                } else result.error(
                    "네이버맵 초기화 안됨.",
                    "네이버 지도가 생성되기 전에 이 메서드를 사용할 수 없습니다.",
                    null
                )
            }
        }
    }

    private fun treatCapture(snapshot: Bitmap) {
        var result: String? = null
        try {
            val file = File.createTempFile("road", ".jpg", activity.applicationContext.cacheDir)
            val fos = FileOutputStream(file)
            snapshot.compress(Bitmap.CompressFormat.JPEG, 100, fos)
            fos.flush()
            fos.close()
            result = file.path
        } catch (e: IOException) {
            Log.e("takeCapture", e.message!!)
        }
        val arg = HashMap<String, String?>(2)
        arg["path"] = result
        methodChannel.invokeMethod("snapshot#done", arg)
    }

    override fun onActivityCreated(activity: Activity, bundle: Bundle?) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
        mapView.onCreate(bundle)
    }

    override fun onActivityStarted(activity: Activity) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
        mapView.onStart()
    }

    override fun onActivityResumed(activity: Activity) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
        mapView.onResume()
    }

    override fun onActivityPaused(activity: Activity) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
        mapView.onPause()
    }

    override fun onActivityStopped(activity: Activity) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
        mapView.onStop()
    }

    override fun onActivitySaveInstanceState(activity: Activity, bundle: Bundle) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
        mapView.onSaveInstanceState(bundle)
    }

    override fun onActivityDestroyed(activity: Activity) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
        mapView.onDestroy()
    }

    override fun setNightModeEnable(nightModeEnable: Boolean) {
        naverMap.isNightModeEnabled = nightModeEnable
    }

    override fun setLiteModeEnable(liteModeEnable: Boolean) {
        naverMap.isLiteModeEnabled = liteModeEnable
    }

    override fun setIndoorEnable(indoorEnable: Boolean) {
        naverMap.isIndoorEnabled = indoorEnable
        naverMap.uiSettings.isIndoorLevelPickerEnabled = indoorEnable
    }

    override fun setMapType(typeIndex: Int) {
        val type: MapType = when (typeIndex) {
            1 -> MapType.Navi
            2 -> MapType.Satellite
            3 -> MapType.Hybrid
            4 -> MapType.Terrain
            else -> MapType.Basic
        }
        naverMap.mapType = type
    }

    override fun setBuildingHeight(buildingHeight: Double) {
        naverMap.buildingHeight = buildingHeight.toFloat()
    }

    override fun setSymbolScale(symbolScale: Double) {
        naverMap.symbolScale = symbolScale.toFloat()
    }

    override fun setSymbolPerspectiveRatio(symbolPerspectiveRatio: Double) {
        naverMap.symbolPerspectiveRatio = symbolPerspectiveRatio.toFloat()
    }

    override fun setActiveLayers(activeLayers: List<Any?>?) {
        naverMap.run {
            setLayerGroupEnabled(NaverMap.LAYER_GROUP_BUILDING, false)
            setLayerGroupEnabled(NaverMap.LAYER_GROUP_TRAFFIC, false)
            setLayerGroupEnabled(NaverMap.LAYER_GROUP_TRANSIT, false)
            setLayerGroupEnabled(NaverMap.LAYER_GROUP_BICYCLE, false)
            setLayerGroupEnabled(NaverMap.LAYER_GROUP_MOUNTAIN, false)
            setLayerGroupEnabled(NaverMap.LAYER_GROUP_CADASTRAL, false)
        }
        if (activeLayers != null) {
            for (i in activeLayers.indices) {
                when (activeLayers[i] as Int) {
                    0 -> naverMap.setLayerGroupEnabled(NaverMap.LAYER_GROUP_BUILDING, true)
                    1 -> naverMap.setLayerGroupEnabled(NaverMap.LAYER_GROUP_TRAFFIC, true)
                    2 -> naverMap.setLayerGroupEnabled(NaverMap.LAYER_GROUP_TRANSIT, true)
                    3 -> naverMap.setLayerGroupEnabled(NaverMap.LAYER_GROUP_BICYCLE, true)
                    4 -> naverMap.setLayerGroupEnabled(NaverMap.LAYER_GROUP_MOUNTAIN, true)
                    5 -> naverMap.setLayerGroupEnabled(NaverMap.LAYER_GROUP_CADASTRAL, true)
                }
            }
        }
    }

    override fun setRotationGestureEnable(rotationGestureEnable: Boolean) {
        naverMap.uiSettings.isRotateGesturesEnabled = rotationGestureEnable
    }

    override fun setScrollGestureEnable(scrollGestureEnable: Boolean) {
        naverMap.uiSettings.isScrollGesturesEnabled = scrollGestureEnable
    }

    override fun setTiltGestureEnable(tiltGestureEnable: Boolean) {
        naverMap.uiSettings.isTiltGesturesEnabled = tiltGestureEnable
    }

    override fun setZoomGestureEnable(zoomGestureEnable: Boolean) {
        naverMap.uiSettings.isZoomControlEnabled = zoomGestureEnable
    }

    override fun setLocationButtonEnable(locationButtonEnable: Boolean) {
        naverMap.uiSettings.isLocationButtonEnabled = locationButtonEnable
    }

    override fun setContentPadding(paddingData: List<Double>?) {
        if (paddingData == null) return
        if (paddingData.size < 4) return
        if (::naverMap.isInitialized.not()) {
            this.paddingData = paddingData
            return
        }
        val left = (paddingData[0] * density).roundToInt()
        val top = (paddingData[1] * density).roundToInt()
        val right = (paddingData[2] * density).roundToInt()
        val bottom = (paddingData[3] * density).roundToInt()
        naverMap.setContentPadding(left, top, right, bottom)
    }

    private fun setContentPadding(leftDp: Float, topDp: Float, rightDp: Float, bottomDp: Float) {
        if (::naverMap.isInitialized) {
            val left = (leftDp * density).roundToInt()
            val top = (topDp * density).roundToInt()
            val right = (rightDp * density).roundToInt()
            val bottom = (bottomDp * density).roundToInt()
            naverMap.setContentPadding(left, top, right, bottom)
        }
    }

    override fun setLocationTrackingMode(locationTrackingMode: Int) {
        if (::naverMap.isInitialized) {
            when (locationTrackingMode) {
                0 -> naverMap.locationTrackingMode = LocationTrackingMode.None
                1 -> naverMap.locationTrackingMode = LocationTrackingMode.NoFollow
                2 -> naverMap.locationTrackingMode = LocationTrackingMode.Follow
                3 -> naverMap.locationTrackingMode = LocationTrackingMode.Face
            }
        } else {
            this.locationTrackingMode = locationTrackingMode
        }
    }

    override fun setMaxZoom(maxZoom: Double) {
        if (::naverMap.isInitialized) {
            naverMap.maxZoom = maxZoom
        } else {
            this.maxZoom = maxZoom
        }
    }

    override fun setMinZoom(minZoom: Double) {
        if (::naverMap.isInitialized) {
            naverMap.minZoom = minZoom
        } else {
            this.minZoom = minZoom
        }
    }
}
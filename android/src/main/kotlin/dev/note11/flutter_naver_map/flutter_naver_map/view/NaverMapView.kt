package dev.note11.flutter_naver_map.flutter_naver_map.view

import android.app.Activity
import android.app.Application
import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.View
import com.naver.maps.map.MapView
import com.naver.maps.map.NaverMap
import com.naver.maps.map.util.FusedLocationSource
import dev.note11.flutter_naver_map.flutter_naver_map.R
import dev.note11.flutter_naver_map.flutter_naver_map.controller.NaverMapControlSender
import dev.note11.flutter_naver_map.flutter_naver_map.controller.NaverMapController
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler
import dev.note11.flutter_naver_map.flutter_naver_map.model.NPoint
import dev.note11.flutter_naver_map.flutter_naver_map.model.NaverMapViewOptions
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView


internal class NaverMapView(
    context: Context,
    private val activity: Activity,
    private val naverMapViewOptions: NaverMapViewOptions,
    private val channel: MethodChannel,
    private val overlayController: OverlayHandler,
) : PlatformView, Application.ActivityLifecycleCallbacks {

    private lateinit var naverMap: NaverMap
    private lateinit var naverMapControlSender: NaverMapControlSender
    private val mapView = MapView(context, naverMapViewOptions.naverMapOptions).apply {
        getMapAsync { naverMap ->
            this@NaverMapView.naverMap = naverMap
            onMapReady()
        }
    }

    private fun onMapReady() {
        initializeMapController()
        setLocationSource()
        setMapTapListener()

        mapView.onCreate(null)
        naverMapControlSender.onMapReady()
    }

    private fun initializeMapController() {
        naverMapControlSender = NaverMapController(
            naverMap, channel, activity.applicationContext, overlayController
        )
    }

    private fun setLocationSource() {
        naverMap.locationSource = FusedLocationSource(activity, LOCATION_PERMISSION_REQUEST_CODE)
    }

    private fun setMapTapListener() {
        naverMap.run {
            setOnMapClickListener { pointFPx, latLng ->
                naverMapControlSender.onMapTapped(NPoint.fromPointFWithPx(pointFPx), latLng)
            }
            setOnSymbolClickListener {
                naverMapControlSender.onSymbolTapped(it)
                    ?: naverMapViewOptions.consumeSymbolTapEvents
            }
            addOnCameraChangeListener(naverMapControlSender::onCameraChange)
            addOnCameraIdleListener(naverMapControlSender::onCameraIdle)
            addOnIndoorSelectionChangeListener(naverMapControlSender::onSelectedIndoorChanged)
        }
    }

    override fun getView(): View = mapView

    init {
        setActivityThemeAppCompat()
        registerLifecycleCallback()
    }

    override fun dispose() {
        Log.i("FlutterNaverMap", "네이버맵 disposed!!!!!!!")
        unRegisterLifecycleCallback()
        mapView.onDestroy()
    }

    // Using AppCompat Theme.
    // default flutter android theme not support naverMap's AppCompatDialog.
    private fun setActivityThemeAppCompat() {
        activity.setTheme(R.style.Theme_AppCompat_Light)
    }

    private fun registerLifecycleCallback() {
        activity.application.registerActivityLifecycleCallbacks(this)
        Log.i("FlutterNaverMap", "네이버맵 registerLifecycleCallback!!!!!!!")
    }

    private fun unRegisterLifecycleCallback() {
        activity.application.unregisterActivityLifecycleCallbacks(this)
        Log.i("FlutterNaverMap", "네이버맵 unRegisterLifecycleCallback!!!!!!!")
    }

    override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
        if (activity != this.activity) return

        mapView.onCreate(savedInstanceState)
        Log.i("FlutterNaverMap", "네이버맵 onActivityCreated!!!!!!!")
    }

    override fun onActivityStarted(activity: Activity) {
        if (activity != this.activity) return

        mapView.onStart()
        Log.i("FlutterNaverMap", "네이버맵 onActivityStarted!!!!!")
    }

    override fun onActivityResumed(activity: Activity) {
        if (activity != this.activity) return

        reloadMap()
        mapView.onResume()
        Log.i("FlutterNaverMap", "네이버맵 onActivityResumed!!!!!!!")
    }

    private fun reloadMap() {
        if (this::naverMap.isInitialized) {
            val nowMapType = naverMap.mapType
            naverMap.mapType = NaverMap.MapType.None
            naverMap.mapType = nowMapType
        }
    }

    override fun onActivityPaused(activity: Activity) {
        if (activity != this.activity) return

        mapView.onPause()
        Log.i("FlutterNaverMap", "네이버맵 onActivityPaused!!!!!")
    }

    override fun onActivityStopped(activity: Activity) {
        if (activity != this.activity) return

        mapView.onStop()
        Log.i("FlutterNaverMap", "네이버맵 onActivityStopped!!!!!!!")
    }

    override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {
        if (activity != this.activity) return

        mapView.onSaveInstanceState(outState)
        Log.i("FlutterNaverMap", "네이버맵 onActivitySaveInstanceState!!!!!")
    }

    override fun onActivityDestroyed(activity: Activity) {
        if (activity != this.activity) return

        mapView.onDestroy()
        unRegisterLifecycleCallback()
        Log.i("FlutterNaverMap", "네이버맵 onActivityDestroyed!!!!!!!")
    }

    companion object {
        private const val LOCATION_PERMISSION_REQUEST_CODE = 9898
    }
}
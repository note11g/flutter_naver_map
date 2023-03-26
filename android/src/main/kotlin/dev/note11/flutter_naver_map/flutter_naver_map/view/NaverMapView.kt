package dev.note11.flutter_naver_map.flutter_naver_map.view

import android.app.Activity
import android.app.Application
import android.content.ComponentCallbacks
import android.content.Context
import android.content.res.Configuration
import android.os.Bundle
import android.util.Log
import android.view.View
import androidx.lifecycle.Lifecycle
import com.naver.maps.map.MapView
import com.naver.maps.map.NaverMap
import dev.note11.flutter_naver_map.flutter_naver_map.R
import dev.note11.flutter_naver_map.flutter_naver_map.controller.NaverMapControlSender
import dev.note11.flutter_naver_map.flutter_naver_map.controller.NaverMapController
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.model.flutter_default_custom.NPoint
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.NaverMapViewOptions
import dev.note11.flutter_naver_map.flutter_naver_map.util.NLocationSource
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView


internal class NaverMapView(
    private val activity: Activity,
    private val naverMapViewOptions: NaverMapViewOptions,
    private val channel: MethodChannel,
    private val overlayController: OverlayHandler,
    private val viewId: Int,
) : PlatformView, Application.ActivityLifecycleCallbacks, ComponentCallbacks {

    private lateinit var naverMap: NaverMap
    private lateinit var naverMapControlSender: NaverMapControlSender
    private val mapView = MapView(activity, naverMapViewOptions.naverMapOptions).apply {
        setTempMethodCallHandler()
        getMapAsync { naverMap ->
            this@NaverMapView.naverMap = naverMap
            onMapReady()
        }
    }
    private var isListenerRegistered = false
    private var rawNaverMapOptionTempCache: Any? = null
    private var lastLifecycle: Lifecycle.Event = Lifecycle.Event.ON_CREATE

    init {
        Log.d("NaverMapViewTrace", "init : $viewId")
        setActivityThemeAppCompat()
        registerLifecycleCallback()
    }

    private fun setTempMethodCallHandler() {
        channel.setMethodCallHandler { call, _ ->
            if (call.method == "updateOptions") rawNaverMapOptionTempCache = call.arguments
        }
    }

    private fun onMapReady() {
        initializeMapController()
        setLocationSource()
        setMapTapListener()

        mapView.onCreate(null)
        Log.d("NaverMapViewTrace", "onMapReady : $viewId")

        naverMapControlSender.onMapReady()
    }

    private fun initializeMapController() {
        naverMapControlSender = NaverMapController(
            naverMap, channel, activity.applicationContext, overlayController
        ).apply {
            rawNaverMapOptionTempCache?.let { updateOptions(it.asMap()) {} }
        }
    }

    private fun setLocationSource() {
        naverMap.locationSource = NLocationSource(activity)
    }

    private fun setMapTapListener() {
        isListenerRegistered = true
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

    private fun removeMapTapListener() {
        if (isListenerRegistered) {
            naverMap.run {
                onMapClickListener = null
                onSymbolClickListener = null
                removeOnCameraChangeListener(naverMapControlSender::onCameraChange)
                removeOnCameraIdleListener(naverMapControlSender::onCameraIdle)
                removeOnIndoorSelectionChangeListener(naverMapControlSender::onSelectedIndoorChanged)
            }
        }
    }

    override fun getView(): View = mapView

    override fun dispose() {
        Log.d("NaverMapViewTrace", "dispose (last: ${lastLifecycle}) : $viewId")
        unRegisterLifecycleCallback()
        removeMapTapListener()


        mapView.onStop()
        mapView.onDestroy()

        (naverMapControlSender as NaverMapController).remove()
    }

    // Using AppCompat Theme.
    // default flutter android theme not support naverMap's AppCompatDialog.
    private fun setActivityThemeAppCompat() {
        activity.setTheme(R.style.Theme_AppCompat_Light)
    }

    private fun registerLifecycleCallback() {
        mapView.onSaveInstanceState(Bundle())
        activity.registerComponentCallbacks(this)
        activity.application.registerActivityLifecycleCallbacks(this)
    }

    private fun unRegisterLifecycleCallback() {
        activity.unregisterComponentCallbacks(this)
        activity.application.unregisterActivityLifecycleCallbacks(this)
    }

    override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
        if (activity != this.activity) return

        Log.d("NaverMapViewTrace", "onActivityCreated : $viewId")

        mapView.onCreate(savedInstanceState)
        lastLifecycle = Lifecycle.Event.ON_CREATE
    }

    override fun onActivityStarted(activity: Activity) {
        if (activity != this.activity) return

        Log.d("NaverMapViewTrace", "onActivityStarted : $viewId")

        mapView.onStart()
        lastLifecycle = Lifecycle.Event.ON_START
    }

    override fun onActivityResumed(activity: Activity) {
        if (activity != this.activity) return

        Log.d("NaverMapViewTrace", "onActivityResumed : $viewId")

        reloadMap()
        mapView.onResume()
        lastLifecycle = Lifecycle.Event.ON_RESUME
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

        Log.d("NaverMapViewTrace", "onActivityPaused : $viewId")

        mapView.onPause()
        lastLifecycle = Lifecycle.Event.ON_PAUSE
    }

    override fun onActivityStopped(activity: Activity) {
        if (activity != this.activity) return

        Log.d("NaverMapViewTrace", "onActivityStopped : $viewId")

        mapView.onStop()
        lastLifecycle = Lifecycle.Event.ON_STOP
    }

    override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {
        if (activity != this.activity) return

        Log.d("NaverMapViewTrace", "onActivitySaveInstanceState : $viewId")

        mapView.onSaveInstanceState(outState)
    }

    override fun onActivityDestroyed(activity: Activity) {
        if (activity != this.activity) return

        Log.d("NaverMapViewTrace", "onActivityDestroyed : $viewId")

        mapView.onDestroy()
        unRegisterLifecycleCallback()
        lastLifecycle = Lifecycle.Event.ON_DESTROY
    }

    override fun onConfigurationChanged(newConfig: Configuration) {}

    override fun onLowMemory() {
        mapView.onLowMemory()
    }
}
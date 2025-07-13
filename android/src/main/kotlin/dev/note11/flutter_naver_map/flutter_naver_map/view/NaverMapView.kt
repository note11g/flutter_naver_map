package dev.note11.flutter_naver_map.flutter_naver_map.view

import android.app.Activity
import android.app.Application
import android.content.ComponentCallbacks
import android.content.Context
import android.content.res.Configuration
import android.os.Build
import android.os.Bundle
import android.view.View
import com.naver.maps.map.MapView
import com.naver.maps.map.NaverMap
import dev.note11.flutter_naver_map.flutter_naver_map.controller.NaverMapControlSender
import dev.note11.flutter_naver_map.flutter_naver_map.controller.NaverMapController
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asNullableMap
import dev.note11.flutter_naver_map.flutter_naver_map.model.base.NPoint
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.NaverMapViewOptions
import dev.note11.flutter_naver_map.flutter_naver_map.util.NLocationSource
import dev.note11.flutter_naver_map.flutter_naver_map.util.TextureSurfaceViewUtil
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView


internal class NaverMapView(
    private val activity: Activity,
    private val flutterProvidedContext: Context,
    private val naverMapViewOptions: NaverMapViewOptions,
    private val channel: MethodChannel,
    private val overlayController: OverlayHandler,
    private val usingGLSurfaceView: Boolean?,
) : PlatformView, Application.ActivityLifecycleCallbacks, ComponentCallbacks {

    private lateinit var naverMap: NaverMap
    private lateinit var naverMapControlSender: NaverMapControlSender
    private val mapView =
        MapView(flutterProvidedContext, naverMapViewOptions.naverMapOptions.apply {
            if (usingGLSurfaceView != null) {
                useTextureView(!usingGLSurfaceView)
            } else {
                val defaultRenderViewStrategy = Build.VERSION.SDK_INT !in 30..32;
                useTextureView(defaultRenderViewStrategy)
            }
        }).apply {
            setTempMethodCallHandler()
            getMapAsync { naverMap ->
                this@NaverMapView.naverMap = naverMap
                onMapReady()
            }
        }
    private var isListenerRegistered = false
    private var rawNaverMapOptionTempCache: Any? = null

    init {
        registerLifecycleCallback()
        TextureSurfaceViewUtil.installInvalidator(mapView)
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
        naverMapControlSender.onMapReady()
        deactivateLogo()
    }

    private fun deactivateLogo() {
        val logoView = mapView.findViewById<View>(com.naver.maps.map.R.id.navermap_logo) ?: return
        logoView.visibility = View.GONE
    }

    private fun initializeMapController() {
        naverMapControlSender = NaverMapController(
            naverMap, channel, flutterProvidedContext, overlayController, mapView::invalidate
        ).apply {
            rawNaverMapOptionTempCache?.let { updateOptions(it.asNullableMap()) {} }
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


            /** Tap Listener 는 아니지만, 따로 setInitHandler와 같이 메소드를 만들지 않고, 기존 메소드에 추가. Listener 종류가 많아지면 용도에 맞게 분리되면 좋을 것 같음 */
            customStyleId = naverMapViewOptions.naverMapOptions.getCustomStyleId() // nullable
            setCustomStyleId(customStyleId, object : NaverMap.OnCustomStyleLoadCallback {
                override fun onCustomStyleLoaded() {
                    naverMapControlSender.onCustomStyleLoaded()
                }

                override fun onCustomStyleLoadFailed(exception: Exception) {
                    naverMapControlSender.onCustomStyleLoadFailed(exception)
                }
            })
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
        unRegisterLifecycleCallback()
        removeMapTapListener()

        mapView.run {
            onPause()
            onStop()
            onDestroy()
        }

        naverMapControlSender.dispose()
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

    /** 실행되지 않음 */
    override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) = Unit

    override fun onActivityStarted(activity: Activity) = Unit

    override fun onActivityResumed(activity: Activity) {
        if (activity != this.activity) return

        if (::naverMap.isInitialized) {
            naverMap.refreshMapType()
        }
        mapView.onResume()
    }

    override fun onActivityPaused(activity: Activity) {
        if (activity != this.activity) return

        mapView.onPause()
    }

    override fun onActivityStopped(activity: Activity) = Unit

    override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {
        if (activity != this.activity) return

        mapView.onSaveInstanceState(outState)
    }

    override fun onActivityDestroyed(activity: Activity) {
        if (activity != this.activity) return

        mapView.onDestroy()
        unRegisterLifecycleCallback()
    }

    override fun onConfigurationChanged(newConfig: Configuration) {}

    override fun onLowMemory() {
        mapView.onLowMemory()
    }
}

fun NaverMap.refreshMapType() = run {
    val nowMapType = mapType
    mapType = NaverMap.MapType.None
    mapType = nowMapType
}
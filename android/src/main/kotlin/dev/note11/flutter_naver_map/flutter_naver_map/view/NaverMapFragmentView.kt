package dev.note11.flutter_naver_map.flutter_naver_map.view

import android.app.Activity
import android.content.Context
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.view.ViewGroup.LayoutParams
import android.widget.FrameLayout
import androidx.fragment.app.FragmentActivity
import com.naver.maps.map.MapFragment
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


internal class NaverMapFragmentView(
    private val activity: Activity,
    private val naverMapViewOptions: NaverMapViewOptions,
    private val channel: MethodChannel,
    private val overlayController: OverlayHandler,
    private val viewId: Int,
) : PlatformView {

    private lateinit var naverMap: NaverMap
    private lateinit var naverMapControlSender: NaverMapControlSender
    private val mapFragment = MapFragment.newInstance(naverMapViewOptions.naverMapOptions).apply {
        val fragmentManager =
            (this@NaverMapFragmentView.activity as FragmentActivity).supportFragmentManager
        fragmentManager
            .beginTransaction()
            .add(frameLayoutId, this)
            .commitAllowingStateLoss()
        getMapAsync {
            this@NaverMapFragmentView.naverMap = it
            onMapReady()
        }
    }
    private var rawNaverMapOptionTempCache: Any? = null
    private lateinit var frameLayout: FrameLayout
    private val frameLayoutId = viewId

    init {
        Log.d("NaverMapViewTrace", "init : $viewId")
        initializeFragment()
        setTempMethodCallHandler()
        setActivityThemeAppCompat()
    }

    private fun initializeFragment() {
        frameLayout = FrameLayout(activity).apply {
            val params = LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT)
            layoutParams = params
            id = frameLayoutId + 200000
        }
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

    override fun getView(): View {
        return mapFragment.mapView ?: frameLayout
    }

    override fun dispose() {
        Log.d("NaverMapViewTrace", "dispose : $viewId")

        (naverMapControlSender as NaverMapController).remove()
    }

    // Using AppCompat Theme.
    // default flutter android theme not support naverMap's AppCompatDialog.
    private fun setActivityThemeAppCompat() {
        activity.setTheme(R.style.Theme_AppCompat_Light)
    }

    private fun reloadMap() {
        if (this::naverMap.isInitialized) {
            val nowMapType = naverMap.mapType
            naverMap.mapType = NaverMap.MapType.None
            naverMap.mapType = nowMapType
        }
    }

}
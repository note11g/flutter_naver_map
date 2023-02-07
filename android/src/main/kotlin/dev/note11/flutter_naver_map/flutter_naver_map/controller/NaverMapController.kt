package dev.note11.flutter_naver_map.flutter_naver_map.controller

import android.content.Context
import android.graphics.Bitmap
import com.naver.maps.geometry.LatLng
import com.naver.maps.map.CameraUpdate
import com.naver.maps.map.LocationTrackingMode
import com.naver.maps.map.NaverMap
import com.naver.maps.map.Symbol
import com.naver.maps.map.indoor.IndoorSelection
import com.naver.maps.map.overlay.Overlay
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler
import dev.note11.flutter_naver_map.flutter_naver_map.converter.AddableOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.toMessageable
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.toMessageableString
import dev.note11.flutter_naver_map.flutter_naver_map.model.enum.NOverlayType
import dev.note11.flutter_naver_map.flutter_naver_map.model.flutter_default_custom.NPoint
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.NaverMapViewOptions
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.NOverlayInfo
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.NOverlayInfo.Companion.fromString
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.io.IOException

internal class NaverMapController(
    private val naverMap: NaverMap,
    private val channel: MethodChannel,
    private val applicationContext: Context,
    private val overlayController: OverlayHandler,
) : NaverMapControlSender, NaverMapControlHandler {
    private var naverMapViewOptions: NaverMapViewOptions? = null

    init {
        channel.setMethodCallHandler(::handle)
    }

    /*
      --- handler (from dart) ---
    */

    override fun updateCamera(
        cameraUpdate: CameraUpdate, onSuccess: (isCanceled: Boolean) -> Unit,
    ) {
        naverMap.moveCamera(cameraUpdate.apply {
            finishCallback { onSuccess(false) }
            cancelCallback { onSuccess(true) }
        })
    }

    override fun cancelTransitions(reason: Int, onSuccess: () -> Unit) {
        naverMap.cancelTransitions(reason)
        onSuccess()
    }

    override fun getCameraPosition(onSuccess: (cameraPosition: Map<String, Any>) -> Unit) {
        naverMap.cameraPosition.toMessageable().let(onSuccess)
    }

    override fun getContentBounds(
        withPadding: Boolean,
        onSuccess: (latLngBounds: Map<String, Any>) -> Unit,
    ) {
        val bounds = if (withPadding) naverMap.coveringBounds else naverMap.contentBounds
        bounds.toMessageable().let(onSuccess)
    }

    override fun getContentRegion(
        withPadding: Boolean, onSuccess: (latLngs: List<Map<String, Any>>) -> Unit,
    ) {
        val region = if (withPadding) naverMap.coveringRegion else naverMap.contentRegion
        region.map { it.toMessageable() }.let(onSuccess)
    }

    override fun getLocationOverlay(onSuccess: () -> Unit) {
        val info = NOverlayInfo.locationOverlayInfo
        if (!overlayController.hasOverlay(info)) {
            overlayController.saveOverlay(naverMap.locationOverlay, info)
        }
        onSuccess()
    }

    override fun screenLocationToLatLng(
        nPoint: NPoint,
        onSuccess: (latLng: Map<String, Any>) -> Unit,
    ) {
        val latLng = naverMap.projection.fromScreenLocation(nPoint.toPointFWithPx())
        onSuccess(latLng.toMessageable())
    }

    override fun latLngToScreenLocation(
        latLng: LatLng,
        onSuccess: (nPoint: Map<String, Any>) -> Unit,
    ) {
        val nPoint =
            naverMap.projection.toScreenLocation(latLng).let { NPoint.fromPointFWithPx(it) }
        onSuccess(nPoint.toMessageable())
    }

    override fun getMeterPerDp(
        lat: Double?,
        zoom: Double?,
        onSuccess: (meterPerDp: Double) -> Unit,
    ) {
        val meterPerDp = if (lat != null || zoom != null) {
            val willSetLat = lat ?: naverMap.cameraPosition.target.latitude
            val willSetZoom = zoom ?: naverMap.cameraPosition.zoom
            naverMap.projection.getMetersPerPixel(willSetLat, willSetZoom)
        } else {
            naverMap.projection.metersPerDp
        }
        onSuccess(meterPerDp)
    }

    override fun isDestroyed(onSuccess: (destroyed: Boolean) -> Unit) {
        onSuccess(naverMap.isDestroyed)
    }

    override fun pickAll(
        nPoint: NPoint,
        dpRadius: Double,
        onSuccess: (pickables: List<Map<String, Any?>>) -> Unit,
    ) {
        val pickables = naverMap.pickAll(nPoint.toPointFWithPx(), DisplayUtil.dpToPx(dpRadius))
        val result = pickables.map {
            val addPayload = when (it) {
                is Symbol -> it.toMessageable()
                is Overlay -> {
                    val overlayKey = overlayController.getSavedOverlayKey(it)
                        ?: throw Exception("This overlay isn't added with flutter.")
                    val overlay = AddableOverlay.fromOverlay(it, info = fromString(overlayKey))
                    overlay.toMessageable()
                }
                else -> throw Exception("Unsupported pickable type.")
            }.toMutableMap()

            addPayload + mapOf("signature" to if (it is Symbol) "symbol" else "overlay")
        }
        onSuccess(result)
    }

    override fun takeSnapshot(
        showControls: Boolean,
        compressQuality: Int,
        onSuccess: (String) -> Unit, onFailure: (e: Exception) -> Unit,
    ) = naverMap.takeSnapshot(showControls) { bitmap ->
        try {
            val filePath = saveSnapshot(bitmap, compressQuality)
            onSuccess(filePath)
        } catch (e: IOException) {
            onFailure(e)
        }
    }

    private fun saveSnapshot(snapshot: Bitmap, compressQuality: Int): String {
        val file = File.createTempFile("map_capture", ".jpg", applicationContext.cacheDir)
        val outputStream = FileOutputStream(file)
        try {
            snapshot.compress(Bitmap.CompressFormat.JPEG, compressQuality, outputStream)
        } catch (e: IOException) {
            throw e
        } finally {
            outputStream.run { flush(); close() }
        }
        return file.path
    }

    override fun setLocationTrackingMode(
        locationTrackingMode: LocationTrackingMode, onSuccess: () -> Unit,
    ) {
        naverMap.locationTrackingMode = locationTrackingMode
        onSuccess()
    }

    override fun getLocationTrackingMode(onSuccess: (String) -> Unit) {
        onSuccess(naverMap.locationTrackingMode.toMessageableString())
    }

    override fun addOverlayAll(
        rawOverlays: List<Map<String, Any>>,
        onSuccess: () -> Unit,
    ) {
        for (rawOverlay in rawOverlays) {
            val overlayInfo = NOverlayInfo.fromMessageable(rawOverlay["info"]!!)
            val creator = AddableOverlay.fromMessageable(
                info = overlayInfo,
                args = rawOverlay,
                context = applicationContext
            )

            val overlay = overlayController.saveOverlayWithAddable(creator)
            overlay.map = naverMap
        }

        onSuccess()
    }

    override fun deleteOverlay(overlayInfo: NOverlayInfo, onSuccess: () -> Unit) {
        overlayController.deleteOverlay(overlayInfo)
        onSuccess()
    }

    override fun clearOverlays(type: NOverlayType?, onSuccess: () -> Unit) {
        overlayController.run {
            if (type != null) clearOverlays(type)
            else clearOverlays()
        }
        onSuccess()
    }

    override fun updateOptions(options: Map<String, Any>, onSuccess: () -> Unit) {
        naverMapViewOptions = NaverMapViewOptions.updateNaverMapFromMessageable(naverMap, options)
        onSuccess()
    }

    /*
      --- sender (to dart) ---
    */
    override fun onMapReady() {
        channel.invokeMethod("onMapReady", null)
    }

    override fun onMapTapped(nPoint: NPoint, latLng: LatLng) {
        channel.invokeMethod(
            "onMapTapped", mapOf(
                "nPoint" to nPoint.toMessageable(),
                "latLng" to latLng.toMessageable(),
            )
        )
    }

    override fun onSymbolTapped(symbol: Symbol): Boolean? {
        channel.invokeMethod("onSymbolTapped", symbol.toMessageable())
        return naverMapViewOptions?.consumeSymbolTapEvents
    }

    override fun onCameraChange(cameraUpdateReason: Int, animated: Boolean) {
        channel.invokeMethod(
            "onCameraChange", mapOf(
                "reason" to cameraUpdateReason,
                "animated" to animated,
            )
        )
    }

    override fun onCameraIdle() {
        channel.invokeMethod("onCameraIdle", null)
    }

    override fun onSelectedIndoorChanged(selectedIndoor: IndoorSelection?) {
        channel.invokeMethod("onSelectedIndoorChanged", selectedIndoor?.toMessageable())
    }
}
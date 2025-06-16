package dev.note11.flutter_naver_map.flutter_naver_map.controller

import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.os.SystemClock
import android.util.Log
import com.naver.maps.geometry.LatLng
import com.naver.maps.map.CameraUpdate
import com.naver.maps.map.LocationTrackingMode
import com.naver.maps.map.NaverMap
import com.naver.maps.map.Projection
import com.naver.maps.map.Symbol
import com.naver.maps.map.app.LegalNoticeActivity
import com.naver.maps.map.app.LegendActivity
import com.naver.maps.map.app.OpenSourceLicenseActivity
import com.naver.maps.map.indoor.IndoorSelection
import com.naver.maps.map.overlay.LocationOverlay
import com.naver.maps.map.overlay.Overlay
import dev.note11.flutter_naver_map.flutter_naver_map.controller.clustering.ClusteringController
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.toMessageable
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.toMessageableString
import dev.note11.flutter_naver_map.flutter_naver_map.model.enum.NOverlayType
import dev.note11.flutter_naver_map.flutter_naver_map.model.base.NPoint
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.NaverMapViewOptions
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.info.NOverlayInfo
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.info.NPickableInfo
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.info.NSymbolInfo
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.clustering.NaverMapClusterOptions
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.AddableOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.AddableOverlay.Companion.toMessageable
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.LazyOrAddableOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NClusterableMarker
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import kotlinx.coroutines.*

internal class NaverMapController(
    private val naverMap: NaverMap,
    private val channel: MethodChannel,
    private val applicationContext: Context,
    private val overlayController: OverlayHandler,
    viewInvalidator: () -> Unit,
) : NaverMapControlSender, NaverMapControlHandler {
    private var naverMapViewOptions: NaverMapViewOptions? = null
    private val clusteringController =
        ClusteringController(naverMap, overlayController, channel::invokeMethod, viewInvalidator)

    private val controllerJob = SupervisorJob()
    private val scope = CoroutineScope(controllerJob + Dispatchers.Main.immediate)

    init {
        overlayController.initializeLocationOverlay(naverMap.locationOverlay)
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

    override fun getLocationOverlay(onSuccess: (Map<String, Any?>) -> Unit) {
        val overlay = naverMap.locationOverlay
        onSuccess(overlay.toMessageable())
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

    override fun getMeterPerDp(onSuccess: (meterPerDp: Double) -> Unit) {
        onSuccess(naverMap.projection.metersPerDp)
    }

    override fun getMeterPerDp(lat: Double, zoom: Double, onSuccess: (meterPerDp: Double) -> Unit) {
        onSuccess(Projection.getMetersPerDp(lat, zoom))
    }

    override fun pickAll(
        nPoint: NPoint,
        dpRadius: Double,
        onSuccess: (pickables: List<Map<String, Any?>>) -> Unit,
    ) {
        val pickables = naverMap.pickAll(nPoint.toPointFWithPx(), DisplayUtil.dpToPx(dpRadius))

        val messageableResult = pickables.filter { it !is LocationOverlay }.map {
            val info = NPickableInfo.fromPickable(it)
            info.toSignedMessageable()
        }

        onSuccess(messageableResult)
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
        val startTime = SystemClock.elapsedRealtime()
        scope.launch(Dispatchers.IO) {
            Log.d(
                "NaverMapController",
                "Adding ${rawOverlays.size} overlays, start time: $startTime"
            )
            val chunks = rawOverlays.chunked(100)
            val chunkResults = chunks.map { chunk ->
                async {
                    val nonClusterableOverlays = mutableListOf<AddableOverlay<*>>()
                    val clusterableMarkers = mutableListOf<NClusterableMarker>()
                    for (rawOverlay in chunk) {
                        val nOverlay = parseOverlay(rawOverlay)

                        when (nOverlay) {
                            is AddableOverlay<*> -> nonClusterableOverlays.add(nOverlay)
                            is NClusterableMarker -> clusterableMarkers.add(nOverlay)
                            else -> throw IllegalArgumentException("Invalid overlay type")
                        }
                    }
                    return@async Pair(nonClusterableOverlays, clusterableMarkers)
                }
            }.awaitAll()

            val nonClusterableOverlays = mutableListOf<AddableOverlay<out Overlay>>()
            val clusterableMarkers = mutableListOf<NClusterableMarker>()
            for (result in chunkResults) {
                nonClusterableOverlays.addAll(result.first)
                clusterableMarkers.addAll(result.second)
            }
            Log.d(
                "NaverMapController",
                "Overlay parsing completed, elapsed time: ${SystemClock.elapsedRealtime() - startTime} ms"
            )

            val secondaryStartTime = SystemClock.elapsedRealtime()

            val mapOverlays =
                overlayController.saveMultipleOverlaysWithAddableOverlays(nonClusterableOverlays)

            withContext(Dispatchers.Main.immediate) {
                for (mapOverlay in mapOverlays) {
                    mapOverlay.map = naverMap // running on main thread required
                }

                if (clusterableMarkers.isNotEmpty()) {
                    clusteringController.addClusterableMarkerAll(clusterableMarkers)
                }
                Log.d(
                    "NaverMapController",
                    "Overlay addition completed, elapsed time: ${SystemClock.elapsedRealtime() - secondaryStartTime} ms"
                )
                onSuccess()
            }
        }
    }

    private fun parseOverlay(rawOverlay: Map<String, Any>): LazyOrAddableOverlay {
        val overlayInfo = NOverlayInfo.fromMessageable(rawOverlay["info"]!!)
        val nOverlay = LazyOrAddableOverlay.fromMessageable(
            info = overlayInfo, args = rawOverlay, context = applicationContext
        )
        return nOverlay
    }

    override fun deleteOverlay(overlayInfo: NOverlayInfo, onSuccess: () -> Unit) {
        when (overlayInfo.type) {
            NOverlayType.CLUSTERABLE_MARKER -> {
                clusteringController.deleteClusterableMarker(overlayInfo)
            }

            else -> overlayController.deleteOverlay(overlayInfo)
        }
        onSuccess()
    }

    override fun clearOverlays(type: NOverlayType?, onSuccess: () -> Unit) {
        if (type == null) {
            overlayController.clearOverlays()
            clusteringController.clearClusterableMarker()
        } else {
            when (type) {
                NOverlayType.CLUSTERABLE_MARKER -> clusteringController.clearClusterableMarker()
                else -> overlayController.clearOverlays(type)
            }
        }
        onSuccess()
    }

    override fun forceRefresh(onSuccess: () -> Unit) {
        naverMap.forceRefresh()
        onSuccess()
    }

    override fun updateOptions(rawOptions: Map<String, Any>, onSuccess: () -> Unit) {
        naverMapViewOptions =
            NaverMapViewOptions.updateNaverMapFromMessageable(naverMap, rawOptions)
        onSuccess()
    }

    override fun updateClusteringOptions(rawOptions: Map<String, Any>, onSuccess: () -> Unit) {
        try {
            val options = NaverMapClusterOptions.fromMessageable(rawOptions)
            clusteringController.updateClusterOptions(options)
            onSuccess()
        } catch (e: Exception) {
            throw e
        }
    }

    override fun openMapOpenSourceLicense(onSuccess: () -> Unit) {
        val intent = Intent(applicationContext, OpenSourceLicenseActivity::class.java)
        // 전체 화면?
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        applicationContext.startActivity(intent)
        onSuccess()
    }

    override fun openLegend(onSuccess: () -> Unit) {
        val intent = Intent(applicationContext, LegendActivity::class.java)
        applicationContext.startActivity(intent)
        onSuccess()
    }

    override fun openLegalNotice(onSuccess: () -> Unit) {
        val intent = Intent(applicationContext, LegalNoticeActivity::class.java)
        applicationContext.startActivity(intent)
        onSuccess()
    }

    /*
      --- sender (to dart) ---
    */
    override fun onMapReady() {
        channel.invokeMethod("onMapReady", null)
    }

    override fun onMapLoaded() {
        channel.invokeMethod("onMapLoaded", null)
    }

    override fun onMapTapped(nPoint: NPoint, latLng: LatLng) {
        channel.invokeMethod(
            "onMapTapped", mapOf(
                "nPoint" to nPoint.toMessageable(),
                "latLng" to latLng.toMessageable(),
            )
        )
    }

    override fun onMapLongTapped(nPoint: NPoint, latLng: LatLng) {
        channel.invokeMethod(
            "onMapLongTapped", mapOf(
                "nPoint" to nPoint.toMessageable(),
                "latLng" to latLng.toMessageable(),
            )
        )
    }

    override fun onSymbolTapped(symbol: Symbol): Boolean? {
        val symbolInfo = NSymbolInfo(symbol)
        channel.invokeMethod("onSymbolTapped", symbolInfo.toMessageable())
        return naverMapViewOptions?.consumeSymbolTapEvents
    }

    override fun onCameraChange(cameraUpdateReason: Int, animated: Boolean) {
        val cameraPosition = naverMap.cameraPosition
        channel.invokeMethod(
            "onCameraChange", mapOf(
                "reason" to cameraUpdateReason,
                "animated" to animated,
                "position" to cameraPosition.toMessageable()
            )
        )
    }

    override fun onCameraIdle() {
        channel.invokeMethod("onCameraIdle", null)
    }

    override fun onSelectedIndoorChanged(selectedIndoor: IndoorSelection?) {
        channel.invokeMethod("onSelectedIndoorChanged", selectedIndoor?.toMessageable())
    }

    /*
      --- remove ---
    */

    fun remove() {
        controllerJob.cancel()
        channel.setMethodCallHandler(null)
        clusteringController.dispose()
        overlayController.remove()
    }
}
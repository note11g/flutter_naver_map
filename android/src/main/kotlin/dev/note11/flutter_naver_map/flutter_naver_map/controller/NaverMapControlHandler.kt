package dev.note11.flutter_naver_map.flutter_naver_map.controller

import com.naver.maps.geometry.LatLng
import com.naver.maps.map.CameraUpdate
import com.naver.maps.map.LocationTrackingMode
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asBoolean
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asInt
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asList
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLatLng
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLocationTrackingMode
import dev.note11.flutter_naver_map.flutter_naver_map.model.enum.NOverlayType
import dev.note11.flutter_naver_map.flutter_naver_map.model.base.NPoint
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.NCameraUpdate
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.info.NOverlayInfo
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private fun MethodChannel.Result.send(result: Any? = null) = success(result)

private fun MethodChannel.Result.fail(e: Exception) =
    error(e.message ?: "unknownError", e.stackTrace.toString(), null)

internal interface NaverMapControlHandler {
    fun handle(call: MethodCall, result: MethodChannel.Result) = when (call.method) {
        "updateCamera" -> updateCamera(
            cameraUpdate = call.arguments.let(NCameraUpdate::fromMessageable).toCameraUpdate(),
            onSuccess = result::send,
        )
        "cancelTransitions" -> cancelTransitions(
            reason = call.arguments.asInt(), onSuccess = result::send
        )
        "getCameraPosition" -> getCameraPosition(result::send)
        "getContentBounds" -> getContentBounds(
            withPadding = call.arguments.asBoolean(),
            onSuccess = result::send,
        )
        "getContentRegion" -> getContentRegion(
            withPadding = call.arguments.asBoolean(),
            onSuccess = result::send,
        )
        "getLocationOverlay" -> getLocationOverlay(result::send)
        "screenLocationToLatLng" -> screenLocationToLatLng(
            nPoint = NPoint.fromMessageable(call.arguments),
            onSuccess = result::send,
        )
        "latLngToScreenLocation" -> latLngToScreenLocation(
            latLng = call.arguments.asLatLng(),
            onSuccess = result::send,
        )
        "getMeterPerDp" -> {
            val arguments = call.arguments?.asMap()
            val latitude = arguments?.get("latitude")?.asDouble()
            val zoom = arguments?.get("zoom")?.asDouble()
            if (latitude != null && zoom != null) {
                getMeterPerDp(
                        lat = latitude,
                        zoom = zoom,
                        onSuccess = result::send,
                )
            } else {
                getMeterPerDp(result::send)
            }
        }
        "getMeterPerDpAtLatitude" -> call.arguments.asMap().let {
            getMeterPerDp(
                    lat = it["latitude"]!!.asDouble(),
                    zoom = it["zoom"]!!.asDouble(),
                    onSuccess = result::send,
            )
        }
        "pickAll" -> call.arguments.asMap().let {
            pickAll(
                nPoint = NPoint.fromMessageable(it["point"]!!),
                dpRadius = it["radius"]!!.asDouble(),
                onSuccess = result::send,
            )
        }
        "takeSnapshot" -> call.arguments.asMap().let {
            takeSnapshot(
                showControls = it["showControls"]!!.asBoolean(),
                compressQuality = it["compressQuality"]!!.asInt(),
                onSuccess = result::send,
                onFailure = result::fail,
            )
        }
        "setLocationTrackingMode" -> setLocationTrackingMode(
            locationTrackingMode = call.arguments.asLocationTrackingMode(),
            onSuccess = result::send,
        )
        "getLocationTrackingMode" -> getLocationTrackingMode(result::send)
        "addOverlayAll" -> addOverlayAll(
            rawOverlays = call.arguments.asList { it.asMap() },
            onSuccess = result::send,
        )
        "deleteOverlay" -> deleteOverlay(
            overlayInfo = NOverlayInfo.fromMessageable(call.arguments),
            onSuccess = result::send,
        )
        "clearOverlays" -> clearOverlays(
            type = call.arguments?.toString()?.let(NOverlayType::fromString),
            onSuccess = result::send
        )
        "forceRefresh" -> forceRefresh(onSuccess = result::send)
        "updateOptions" -> updateOptions(
            rawOptions = call.arguments.asMap(), onSuccess = result::send,
        )
        "updateClusteringOptions" -> updateClusteringOptions(
            rawOptions = call.arguments.asMap(), onSuccess = result::send,
        )
        "openMapOpenSourceLicense" -> openMapOpenSourceLicense(result::send)
        "openLegend" -> openLegend(result::send)
        "openLegalNotice" -> openLegalNotice(result::send)
        else -> result.notImplemented()
    }

    fun updateCamera(cameraUpdate: CameraUpdate, onSuccess: (isCanceled: Boolean) -> Unit)

    fun cancelTransitions(reason: Int, onSuccess: () -> Unit)

    fun getCameraPosition(onSuccess: (cameraPosition: Map<String, Any>) -> Unit)

    fun getContentBounds(withPadding: Boolean, onSuccess: (latLngBounds: Map<String, Any>) -> Unit)

    fun getContentRegion(withPadding: Boolean, onSuccess: (latLngs: List<Map<String, Any>>) -> Unit)

    fun getLocationOverlay(onSuccess: (Map<String, Any?>) -> Unit)

    fun screenLocationToLatLng(nPoint: NPoint, onSuccess: (latLng: Map<String, Any>) -> Unit)

    fun latLngToScreenLocation(latLng: LatLng, onSuccess: (nPoint: Map<String, Any>) -> Unit)

    fun getMeterPerDp(onSuccess: (meterPerDp: Double) -> Unit)

    fun getMeterPerDp(lat: Double, zoom: Double, onSuccess: (meterPerDp: Double) -> Unit)

    fun pickAll(
        nPoint: NPoint,
        dpRadius: Double,
        onSuccess: (pickables: List<Map<String, Any?>>) -> Unit,
    )

    fun takeSnapshot(
        showControls: Boolean,
        compressQuality: Int,
        onSuccess: (String) -> Unit, onFailure: (e: Exception) -> Unit,
    )

    fun setLocationTrackingMode(locationTrackingMode: LocationTrackingMode, onSuccess: () -> Unit)

    fun getLocationTrackingMode(onSuccess: (String) -> Unit)

    fun addOverlayAll(rawOverlays: List<Map<String, Any>>, onSuccess: () -> Unit)

    fun deleteOverlay(overlayInfo: NOverlayInfo, onSuccess: () -> Unit)

    fun clearOverlays(type: NOverlayType?, onSuccess: () -> Unit)

    fun forceRefresh(onSuccess: () -> Unit)

    fun updateOptions(rawOptions: Map<String, Any?>, onSuccess: () -> Unit)

    fun updateClusteringOptions(rawOptions: Map<String, Any>, onSuccess: () -> Unit)

    fun openMapOpenSourceLicense(onSuccess: () -> Unit)

    fun openLegend(onSuccess: () -> Unit)

    fun openLegalNotice(onSuccess: () -> Unit)
}
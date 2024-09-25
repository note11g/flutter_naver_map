package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.handler

import com.naver.maps.map.overlay.Marker
import com.naver.maps.map.overlay.Overlay
import io.flutter.plugin.common.MethodChannel

internal interface ClusterMarkerHandler {
    fun handleClusterMarker(
        marker: Overlay, method: String, arg: Any?, result: MethodChannel.Result,
    ) = (marker as Marker).let { m ->
        when (method) {
            "lSyncClusterMarker" -> syncClusterMarker(m, arg!!, result::success)
            else -> result.notImplemented()
        }
    }

    fun syncClusterMarker(marker: Marker, rawClusterMarker: Any, success: (Any?) -> Unit)
}
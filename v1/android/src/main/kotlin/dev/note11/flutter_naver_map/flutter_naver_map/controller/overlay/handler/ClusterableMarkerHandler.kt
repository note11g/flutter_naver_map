package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.handler

import com.naver.maps.map.overlay.Marker
import com.naver.maps.map.overlay.Overlay
import io.flutter.plugin.common.MethodChannel

internal interface ClusterableMarkerHandler : MarkerHandler, ClusterMarkerHandler {
    fun handleClusterableMarker(
        marker: Overlay, method: String, arg: Any?, result: MethodChannel.Result,
    ) = (marker as Marker).let { m ->
        val isClusterMarkerMode = method.startsWith("l")
        if (isClusterMarkerMode) {
            return handleClusterMarker(m, method, arg, result)
        }

        when (method) {
            else -> handleMarker(m, method, arg, result)
        }
    }
}
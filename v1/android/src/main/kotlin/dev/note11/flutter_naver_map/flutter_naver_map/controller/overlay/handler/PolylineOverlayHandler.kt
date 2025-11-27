package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.handler

import com.naver.maps.map.overlay.Overlay
import com.naver.maps.map.overlay.PolylineOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler.Companion.getterName
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NPolylineOverlay
import io.flutter.plugin.common.MethodChannel

internal interface PolylineOverlayHandler : OverlayHandler {
    fun handlePolylineOverlay(
        polylineOverlay: Overlay, method: String, arg: Any?, result: MethodChannel.Result,
    ) = (polylineOverlay as PolylineOverlay).let { p ->
        when (method) {
            NPolylineOverlay.coordsName -> setCoords(p, arg!!)
            NPolylineOverlay.colorName -> setColor(p, arg!!)
            NPolylineOverlay.widthName -> setWidth(p, arg!!)
            NPolylineOverlay.lineCapName -> setLineCap(p, arg!!)
            NPolylineOverlay.lineJoinName -> setLineJoin(p, arg!!)
            NPolylineOverlay.patternName -> setPattern(p, arg!!)
            getterName(NPolylineOverlay.boundsName) -> getBounds(p, result::success)
            else -> result.notImplemented()
        }
    }

    fun setCoords(polylineOverlay: PolylineOverlay, rawCoords: Any)

    fun setColor(polylineOverlay: PolylineOverlay, rawColor: Any)

    fun setWidth(polylineOverlay: PolylineOverlay, rawWidthDp: Any)

    fun setLineCap(polylineOverlay: PolylineOverlay, rawLineCap: Any)

    fun setLineJoin(polylineOverlay: PolylineOverlay, rawLineJoin: Any)

    fun setPattern(polylineOverlay: PolylineOverlay, patternDpList: Any)

    fun getBounds(polylineOverlay: PolylineOverlay, success: (bounds: Map<String, Any>) -> Unit)
}
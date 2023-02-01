package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.handler

import com.naver.maps.map.overlay.PolylineOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler.Companion.getterName
import dev.note11.flutter_naver_map.flutter_naver_map.model.overlay.overlay.NPolylineOverlay
import io.flutter.plugin.common.MethodChannel

internal interface PolylineOverlayHandler : OverlayHandler {
    fun handlePolylineOverlay(
        polylineOverlay: PolylineOverlay, method: String, arg: Any?, result: MethodChannel.Result,
    ) = when (method) {
        NPolylineOverlay.coordsName -> setCoords(polylineOverlay, arg!!)
        NPolylineOverlay.colorName -> setColor(polylineOverlay, arg!!)
        NPolylineOverlay.widthName -> setWidth(polylineOverlay, arg!!)
        NPolylineOverlay.lineCapName -> setLineCap(polylineOverlay, arg!!)
        NPolylineOverlay.lineJoinName -> setLineJoin(polylineOverlay, arg!!)
        NPolylineOverlay.patternName -> setPattern(polylineOverlay, arg!!)
        getterName(NPolylineOverlay.boundsName) -> getBounds(polylineOverlay, result::success)
        else -> result.notImplemented()
    }

    fun setCoords(polylineOverlay: PolylineOverlay, rawCoords: Any)

    fun setColor(polylineOverlay: PolylineOverlay, rawColor: Any)

    fun setWidth(polylineOverlay: PolylineOverlay, rawWidthDp: Any)

    fun setLineCap(polylineOverlay: PolylineOverlay, rawLineCap: Any)

    fun setLineJoin(polylineOverlay: PolylineOverlay, rawLineJoin: Any)

    fun setPattern(polylineOverlay: PolylineOverlay, patternDpList: Any)

    fun getBounds(polylineOverlay: PolylineOverlay, success: (bounds: Map<String, Any>) -> Unit)
}
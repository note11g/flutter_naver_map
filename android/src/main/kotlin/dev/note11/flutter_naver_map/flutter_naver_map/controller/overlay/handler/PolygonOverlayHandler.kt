package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.handler

import com.naver.maps.map.overlay.Overlay
import com.naver.maps.map.overlay.PolygonOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler.Companion.getterName
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NPolygonOverlay
import io.flutter.plugin.common.MethodChannel

internal interface PolygonOverlayHandler : OverlayHandler {
    fun handlePolygonOverlay(
        polygonOverlay: Overlay, method: String, arg: Any?, result: MethodChannel.Result,
    ) = (polygonOverlay as PolygonOverlay).let { p ->
        when (method) {
            NPolygonOverlay.coordsName -> setCoords(p, arg!!)
            NPolygonOverlay.colorName -> setColor(p, arg!!)
            NPolygonOverlay.holesName -> setHoles(p, arg!!)
            NPolygonOverlay.outlineColorName -> setOutlineColor(p, arg!!)
            NPolygonOverlay.outlineWidthName -> setOutlineWidth(p, arg!!)
            NPolygonOverlay.outlinePatternName -> setOutlinePattern(p, arg!!)
            getterName(NPolygonOverlay.boundsName) -> getBounds(p, result::success)
            else -> result.notImplemented()
        }
    }

    fun setCoords(polygonOverlay: PolygonOverlay, rawCoords: Any)

    fun setColor(polygonOverlay: PolygonOverlay, rawColor: Any)

    fun setHoles(polygonOverlay: PolygonOverlay, rawHoles: Any)

    fun setOutlineColor(polygonOverlay: PolygonOverlay, rawColor: Any)

    fun setOutlineWidth(polygonOverlay: PolygonOverlay, rawWidthDp: Any)

    fun setOutlinePattern(polygonOverlay: PolygonOverlay, rawPatternDpList: Any)

    fun getBounds(polygonOverlay: PolygonOverlay, success: (bounds: Map<String, Any>) -> Unit)
}
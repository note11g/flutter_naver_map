package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.handler

import com.naver.maps.map.overlay.PolygonOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler.Companion.getterName
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NPolygonOverlay
import io.flutter.plugin.common.MethodChannel

internal interface PolygonOverlayHandler : OverlayHandler {
    fun handlePolygonOverlay(
        polygonOverlay: PolygonOverlay, method: String, arg: Any?, result: MethodChannel.Result,
    ) = when (method) {
        NPolygonOverlay.coordsName -> setCoords(polygonOverlay, arg!!)
        NPolygonOverlay.colorName -> setColor(polygonOverlay, arg!!)
        NPolygonOverlay.holesName -> setHoles(polygonOverlay, arg!!)
        NPolygonOverlay.outlineColorName -> setOutlineColor(polygonOverlay, arg!!)
        NPolygonOverlay.outlineWidthName -> setOutlineWidth(polygonOverlay, arg!!)
        getterName(NPolygonOverlay.boundsName) -> getBounds(polygonOverlay, result::success)
        else -> result.notImplemented()
    }

    fun setCoords(polygonOverlay: PolygonOverlay, rawCoords: Any)

    fun setColor(polygonOverlay: PolygonOverlay, rawColor: Any)

    fun setHoles(polygonOverlay: PolygonOverlay, rawHoles: Any)

    fun setOutlineColor(polygonOverlay: PolygonOverlay, rawColor: Any)

    fun setOutlineWidth(polygonOverlay: PolygonOverlay, rawWidthDp: Any)

    fun getBounds(polygonOverlay: PolygonOverlay, success: (bounds: Map<String, Any>) -> Unit)
}
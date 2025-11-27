package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.handler

import com.naver.maps.map.overlay.ArrowheadPathOverlay
import com.naver.maps.map.overlay.Overlay
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler.Companion.getterName
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NArrowheadPathOverlay
import io.flutter.plugin.common.MethodChannel

internal interface ArrowheadPathOverlayHandler : OverlayHandler {
    fun handleArrowheadPathOverlay(
        arrowheadPathOverlay: Overlay,
        method: String,
        arg: Any?,
        result: MethodChannel.Result,
    ) = (arrowheadPathOverlay as ArrowheadPathOverlay).let { a ->
        when (method) {
            NArrowheadPathOverlay.coordsName -> setCoords(a, arg!!)
            NArrowheadPathOverlay.widthName -> setWidth(a, arg!!)
            NArrowheadPathOverlay.colorName -> setColor(a, arg!!)
            NArrowheadPathOverlay.outlineWidthName -> setOutlineWidth(a, arg!!)
            NArrowheadPathOverlay.outlineColorName -> setOutlineColor(a, arg!!)
            NArrowheadPathOverlay.elevationName -> setElevation(a, arg!!)
            NArrowheadPathOverlay.headSizeRatioName -> setHeadSizeRatio(a, arg!!)
            getterName(NArrowheadPathOverlay.boundsName) -> getBounds(a, result::success)
            else -> result.notImplemented()
        }
    }

    fun setCoords(arrowheadPathOverlay: ArrowheadPathOverlay, rawCoords: Any)

    fun setWidth(arrowheadPathOverlay: ArrowheadPathOverlay, rawWidthDp: Any)

    fun setColor(arrowheadPathOverlay: ArrowheadPathOverlay, rawColor: Any)

    fun setOutlineWidth(arrowheadPathOverlay: ArrowheadPathOverlay, rawWidthDp: Any)

    fun setOutlineColor(arrowheadPathOverlay: ArrowheadPathOverlay, rawColor: Any)

    fun setElevation(arrowheadPathOverlay: ArrowheadPathOverlay, rawElevationDp: Any)

    fun setHeadSizeRatio(arrowheadPathOverlay: ArrowheadPathOverlay, rawRatio: Any)

    fun getBounds(
        arrowheadPathOverlay: ArrowheadPathOverlay,
        success: (bounds: Map<String, Any>) -> Unit,
    )
}
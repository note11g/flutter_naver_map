package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.handler

import com.naver.maps.map.overlay.CircleOverlay
import com.naver.maps.map.overlay.Overlay
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler.Companion.getterName
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NCircleOverlay
import io.flutter.plugin.common.MethodChannel

internal interface CircleOverlayHandler : OverlayHandler {
    fun handleCircleOverlay(
        circleOverlay: Overlay, method: String, arg: Any?, result: MethodChannel.Result,
    ) = (circleOverlay as CircleOverlay).let { c ->
        when (method) {
            NCircleOverlay.centerName -> setCenter(c, arg!!)
            NCircleOverlay.radiusName -> setRadius(c, arg!!)
            NCircleOverlay.colorName -> setColor(c, arg!!)
            NCircleOverlay.outlineColorName -> setOutlineColor(c, arg!!)
            NCircleOverlay.outlineWidthName -> setOutlineWidth(c, arg!!)
            getterName(NCircleOverlay.boundsName) -> getBounds(c, result::success)
            else -> result.notImplemented()
        }
    }

    fun setCenter(circleOverlay: CircleOverlay, rawCenter: Any)

    fun setRadius(circleOverlay: CircleOverlay, rawRadius: Any)

    fun setColor(circleOverlay: CircleOverlay, rawColor: Any)

    fun setOutlineColor(circleOverlay: CircleOverlay, rawOutlineColor: Any)

    fun setOutlineWidth(circleOverlay: CircleOverlay, rawOutlineWidth: Any)

    fun getBounds(circleOverlay: CircleOverlay, result: (bounds: Map<String, Any>) -> Unit)
}
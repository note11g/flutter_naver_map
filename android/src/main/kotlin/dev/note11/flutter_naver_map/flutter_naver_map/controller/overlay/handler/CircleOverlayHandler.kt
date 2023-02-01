package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.handler

import com.naver.maps.map.overlay.CircleOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler.Companion.getterName
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NCircleOverlay
import io.flutter.plugin.common.MethodChannel

internal interface CircleOverlayHandler : OverlayHandler {
    fun handleCircleOverlay(
        groundOverlay: CircleOverlay, method: String, arg: Any?, result: MethodChannel.Result,
    ) = when (method) {
        NCircleOverlay.centerName -> setCenter(groundOverlay, arg!!)
        NCircleOverlay.radiusName -> setRadius(groundOverlay, arg!!)
        NCircleOverlay.colorName -> setColor(groundOverlay, arg!!)
        NCircleOverlay.outlineColorName -> setOutlineColor(groundOverlay, arg!!)
        NCircleOverlay.outlineWidthName -> setOutlineWidth(groundOverlay, arg!!)
        getterName(NCircleOverlay.boundsName) -> getBounds(groundOverlay, result::success)
        else -> result.notImplemented()
    }

    fun setCenter(circleOverlay: CircleOverlay, rawCenter: Any)

    fun setRadius(circleOverlay: CircleOverlay, rawRadius: Any)

    fun setColor(circleOverlay: CircleOverlay, rawColor: Any)

    fun setOutlineColor(circleOverlay: CircleOverlay, rawOutlineColor: Any)

    fun setOutlineWidth(circleOverlay: CircleOverlay, rawOutlineWidth: Any)

    fun getBounds(circleOverlay: CircleOverlay, result: (bounds: Map<String, Any>) -> Unit)
}
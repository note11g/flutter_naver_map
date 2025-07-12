package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.handler

import com.naver.maps.map.overlay.LocationOverlay
import com.naver.maps.map.overlay.Overlay
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler.Companion.getterName
import io.flutter.plugin.common.MethodChannel

internal interface LocationOverlayHandler : OverlayHandler {
    fun handleLocationOverlay(
        overlay: Overlay, method: String, arg: Any?, result: MethodChannel.Result,
    ) = (overlay as LocationOverlay).let { l ->
        when (method) {
            anchorName -> setAnchor(l, arg!!)
            bearingName -> setBearing(l, arg!!)
            circleColorName -> setCircleColor(l, arg!!)
            circleOutlineColorName -> setCircleOutlineColor(l, arg!!)
            circleOutlineWidthName -> setCircleOutlineWidth(l, arg!!)
            circleRadiusName -> setCircleRadius(l, arg!!)
            iconName -> setIcon(l, arg!!)
            iconSizeName -> setIconSize(l, arg!!)
            iconAlphaName -> setIconAlpha(l, arg!!)
            positionName -> setPosition(l, arg!!)
            subAnchorName -> setSubAnchor(l, arg!!)
            subIconName -> setSubIcon(l, arg)
            subIconSizeName -> setSubIconSize(l, arg!!)
            subIconAlphaName -> setSubIconAlpha(l, arg!!)
            getterName(bearingName) -> getBearing(l, result::success)
            getterName(positionName) -> getPosition(l, result::success)
            else -> result.notImplemented()
        }
    }

    fun setAnchor(overlay: LocationOverlay, rawNPoint: Any)

    fun setBearing(overlay: LocationOverlay, rawBearing: Any)

    fun setCircleColor(overlay: LocationOverlay, rawColor: Any)

    fun setCircleOutlineColor(overlay: LocationOverlay, rawColor: Any)

    fun setCircleOutlineWidth(overlay: LocationOverlay, rawWidth: Any)

    fun setCircleRadius(overlay: LocationOverlay, rawRadius: Any)

    fun setIcon(overlay: LocationOverlay, rawNOverlayImage: Any)

    fun setIconSize(overlay: LocationOverlay, rawSize: Any)

    fun setIconAlpha(overlay: LocationOverlay, rawAlpha: Any)

    fun setPosition(overlay: LocationOverlay, rawLatLng: Any)

    fun setSubAnchor(overlay: LocationOverlay, rawNPoint: Any)

    fun setSubIcon(overlay: LocationOverlay, rawNOverlayImage: Any?)

    fun setSubIconSize(overlay: LocationOverlay, rawSize: Any)

    fun setSubIconAlpha(overlay: LocationOverlay, rawAlpha: Any)

    fun getBearing(overlay: LocationOverlay, success: (bearing: Float) -> Unit)

    fun getPosition(overlay: LocationOverlay, success: (latLng: Map<String, Any>) -> Unit)


    companion object {
        /* --- Messaging Name Define --- */
        private const val anchorName = "anchor"
        private const val bearingName = "bearing"
        private const val circleColorName = "circleColor"
        private const val circleOutlineColorName = "circleOutlineColor"
        private const val circleOutlineWidthName = "circleOutlineWidth"
        private const val circleRadiusName = "circleRadius"
        private const val iconName = "icon"
        private const val iconSizeName = "iconSize"
        private const val iconAlphaName = "iconAlpha"
        private const val positionName = "position"
        private const val subAnchorName = "subAnchor"
        private const val subIconName = "subIcon"
        private const val subIconSizeName = "subIconSize"
        private const val subIconAlphaName = "subIconAlpha"
    }
}
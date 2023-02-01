package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.handler

import com.naver.maps.map.overlay.LocationOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler.Companion.getterName
import io.flutter.plugin.common.MethodChannel

internal interface LocationOverlayHandler : OverlayHandler {
    fun handleLocationOverlay(
        overlay: LocationOverlay, method: String, arg: Any?, result: MethodChannel.Result,
    ) = when (method) {
        anchorName -> setAnchor(overlay, arg!!)
        bearingName -> setBearing(overlay, arg!!)
        circleColorName -> setCircleColor(overlay, arg!!)
        circleOutlineColorName -> setCircleOutlineColor(overlay, arg!!)
        circleOutlineWidthName -> setCircleOutlineWidth(overlay, arg!!)
        circleRadiusName -> setCircleRadius(overlay, arg!!)
        iconName -> setIcon(overlay, arg!!)
        iconSizeName -> setIconSize(overlay, arg!!)
        positionName -> setPosition(overlay, arg!!)
        subAnchorName -> setSubAnchor(overlay, arg!!)
        subIconName -> setSubIcon(overlay, arg!!)
        subIconSizeName -> setSubIconSize(overlay, arg!!)

        // Getters
        getterName(anchorName) -> getAnchor(overlay, result::success)
        getterName(bearingName) -> getBearing(overlay, result::success)
        getterName(circleColorName) -> getCircleColor(overlay, result::success)
        getterName(circleOutlineColorName) -> getCircleOutlineColor(overlay, result::success)
        getterName(circleOutlineWidthName) -> getCircleOutlineWidth(overlay, result::success)
        getterName(circleRadiusName) -> getCircleRadius(overlay, result::success)
        getterName(iconName) -> getIconSize(overlay, result::success)
        getterName(iconSizeName) -> getIconSize(overlay, result::success)
        getterName(positionName) -> getPosition(overlay, result::success)
        getterName(subAnchorName) -> getSubAnchor(overlay, result::success)
        getterName(subIconName) -> getSubIconSize(overlay, result::success)
        getterName(subIconSizeName) -> getSubIconSize(overlay, result::success)

        else -> result.notImplemented()
    }

    fun getAnchor(overlay: LocationOverlay, success: (nPoint: Map<String, Any>) -> Unit)

    fun setAnchor(overlay: LocationOverlay, rawNPoint: Any)

    fun getBearing(overlay: LocationOverlay, success: (bearing: Float) -> Unit)

    fun setBearing(overlay: LocationOverlay, rawBearing: Any)

    fun getCircleColor(overlay: LocationOverlay, success: (color: Int) -> Unit)

    fun setCircleColor(overlay: LocationOverlay, rawColor: Any)

    fun getCircleOutlineColor(overlay: LocationOverlay, success: (color: Int) -> Unit)

    fun setCircleOutlineColor(overlay: LocationOverlay, rawColor: Any)

    fun getCircleOutlineWidth(overlay: LocationOverlay, success: (width: Double) -> Unit)

    fun setCircleOutlineWidth(overlay: LocationOverlay, rawWidth: Any)

    fun getCircleRadius(overlay: LocationOverlay, success: (width: Double) -> Unit)

    fun setCircleRadius(overlay: LocationOverlay, rawRadius: Any)

    fun setIcon(overlay: LocationOverlay, rawNOverlayImage: Any)

    fun getIconSize(overlay: LocationOverlay, success: (size: Map<String, Any>) -> Unit)

    fun setIconSize(overlay: LocationOverlay, rawSize: Any)

    fun getPosition(overlay: LocationOverlay, success: (latLng: Map<String, Any>) -> Unit)

    fun setPosition(overlay: LocationOverlay, rawLatLng: Any)

    fun getSubAnchor(overlay: LocationOverlay, success: (nPoint: Map<String, Any>) -> Unit)

    fun setSubAnchor(overlay: LocationOverlay, rawNPoint: Any)

    fun setSubIcon(overlay: LocationOverlay, rawNOverlayImage: Any)

    fun getSubIconSize(overlay: LocationOverlay, success: (size: Map<String, Any>) -> Unit)

    fun setSubIconSize(overlay: LocationOverlay, rawSize: Any)

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
        private const val positionName = "position"
        private const val subAnchorName = "subAnchor"
        private const val subIconName = "subIcon"
        private const val subIconSizeName = "subIconSize"
    }
}
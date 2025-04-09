package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay

import com.naver.maps.map.overlay.LocationOverlay
import com.naver.maps.map.overlay.Overlay
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.AddableOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.model.enum.NOverlayType
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.info.NOverlayInfo
import io.flutter.plugin.common.MethodChannel

internal interface OverlayHandler {

    fun hasOverlay(info: NOverlayInfo): Boolean

    fun saveOverlay(overlay: Overlay, info: NOverlayInfo)

    fun deleteOverlay(info: NOverlayInfo)

    fun clearOverlays()

    fun clearOverlays(type: NOverlayType)

    fun initializeLocationOverlay(overlay: LocationOverlay)

    fun <T : Overlay> saveOverlayWithAddable(
        creator: AddableOverlay<T>,
        createdOverlay: T? = null,
    ): T {
        if (hasOverlay(creator.info)) deleteOverlay(creator.info)

        val overlay =
            if (createdOverlay is T) creator.applyAtRawOverlay(createdOverlay)
            else creator.createMapOverlay()

        creator.applyCommonProperties { name, arg ->
            handleOverlay(overlay, name, arg, null)
        }

        saveOverlay(overlay, creator.info)

        return overlay
    }

    /*
      --- methods ---
    */

    fun handleOverlay(
        overlay: Overlay, method: String, arg: Any?, result: MethodChannel.Result?,
    ): Boolean {
        when (method) {
            zIndexName -> setZIndex(overlay, arg!!)
            globalZIndexName -> setGlobalZIndex(overlay, arg!!)
            isVisibleName -> setIsVisible(overlay, arg!!)
            minZoomName -> setMinZoom(overlay, arg!!)
            maxZoomName -> setMaxZoom(overlay, arg!!)
            isMinZoomInclusiveName -> setIsMinZoomInclusive(overlay, arg!!)
            isMaxZoomInclusiveName -> setIsMaxZoomInclusive(overlay, arg!!)
            performClickName -> performClick(overlay, result!!::success)
            hasOnTapListenerName -> setHasOnTapListener(overlay, arg!!)
            else -> return false
        }
        return true
    }

    fun setZIndex(overlay: Overlay, rawZIndex: Any)

    fun setGlobalZIndex(overlay: Overlay, rawGlobalZIndex: Any)

    fun setIsVisible(overlay: Overlay, rawIsVisible: Any)

    fun setMinZoom(overlay: Overlay, rawMinZoom: Any)

    fun setMaxZoom(overlay: Overlay, rawMaxZoom: Any)

    fun setIsMinZoomInclusive(overlay: Overlay, rawIsMinZoomInclusive: Any)

    fun setIsMaxZoomInclusive(overlay: Overlay, rawIsMaxZoomInclusive: Any)

    fun performClick(overlay: Overlay, success: (Any?) -> Unit)

    fun setHasOnTapListener(overlay: Overlay, rawHasOnTapListener: Any)

    fun remove()

    companion object {
        /* --- Messaging Name Define --- */
        const val zIndexName = "zIndex"
        const val globalZIndexName = "globalZIndex"
        const val isVisibleName = "isVisible"
        const val minZoomName = "minZoom"
        const val maxZoomName = "maxZoom"
        const val isMinZoomInclusiveName = "isMinZoomInclusive"
        const val isMaxZoomInclusiveName = "isMaxZoomInclusive"
        private const val performClickName = "performClick"
        const val hasOnTapListenerName = "hasOnTapListener"
        const val onTapName = "onTap"
        val allPropertyNames = listOf(
            zIndexName,
            globalZIndexName,
            isVisibleName,
            minZoomName,
            maxZoomName,
            isMinZoomInclusiveName,
            isMaxZoomInclusiveName,
            hasOnTapListenerName,
        )

        fun getterName(name: String): String = "get${name}"
    }
}
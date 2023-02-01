package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay

import android.util.Log
import com.naver.maps.map.overlay.Overlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.AddableOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.model.enum.NOverlayType
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.NOverlayInfo
import io.flutter.plugin.common.MethodChannel

internal interface OverlayHandler {

    fun hasOverlay(info: NOverlayInfo): Boolean

    fun saveOverlay(overlay: Overlay, info: NOverlayInfo)

    fun deleteOverlay(info: NOverlayInfo)

    fun clearOverlays()

    fun clearOverlays(type: NOverlayType)

    fun getSavedOverlayKey(overlay: Overlay): String?

    fun <T : Overlay> saveOverlayWithAddable(creator: AddableOverlay<out T>): T {
        if (hasOverlay(creator.info)) deleteOverlay(creator.info)

        return creator.createMapOverlay().also { overlay ->
            saveOverlay(overlay, creator.info)
        }
    }

    /*
      --- methods ---
    */

    fun handleOverlay(
        overlay: Overlay, method: String, arg: Any?, result: MethodChannel.Result,
    ): Boolean {
        val isInvoked = when (method) {
            zIndexName -> setZIndex(overlay, arg!!)
            globalZIndexName -> setGlobalZIndex(overlay, arg!!)
            tagName -> setTag(overlay, arg!!.toString())
            isVisibleName -> setIsVisible(overlay, arg!!)
            minZoomName -> setMinZoom(overlay, arg!!)
            maxZoomName -> setMaxZoom(overlay, arg!!)
            isMinZoomInclusiveName -> setIsMinZoomInclusive(overlay, arg!!)
            isMaxZoomInclusiveName -> setIsMaxZoomInclusive(overlay, arg!!)
            getterName(zIndexName) -> getZIndex(overlay, result::success)
            getterName(globalZIndexName) -> getGlobalZIndex(overlay, result::success)
            getterName(tagName) -> getTag(overlay, result::success)
            getterName(isAddedName) -> getIsAdded(overlay, result::success)
            getterName(isVisibleName) -> getIsVisible(overlay, result::success)
            getterName(minZoomName) -> getMinZoom(overlay, result::success)
            getterName(maxZoomName) -> getMaxZoom(overlay, result::success)
            getterName(isMinZoomInclusiveName) -> getIsMinZoomInclusive(overlay, result::success)
            getterName(isMaxZoomInclusiveName) -> getIsMaxZoomInclusive(overlay, result::success)
            performClickName -> performClick(overlay, result::success)
            else -> null
        } == Unit

        return isInvoked
    }

    fun getZIndex(overlay: Overlay, success: (zIndex: Int) -> Unit)

    fun setZIndex(overlay: Overlay, rawZIndex: Any)

    fun getGlobalZIndex(overlay: Overlay, success: (globalZIndex: Int) -> Unit)

    fun setGlobalZIndex(overlay: Overlay, rawGlobalZIndex: Any)

    fun getTag(overlay: Overlay, success: (tag: String?) -> Unit)

    fun setTag(overlay: Overlay, rawTag: String)

    fun getIsAdded(overlay: Overlay, success: (isAdded: Boolean) -> Unit)

    fun getIsVisible(overlay: Overlay, success: (isVisible: Boolean) -> Unit)

    fun setIsVisible(overlay: Overlay, rawIsVisible: Any)

    fun getMinZoom(overlay: Overlay, success: (minZoom: Double) -> Unit)

    fun setMinZoom(overlay: Overlay, rawMinZoom: Any)

    fun getMaxZoom(overlay: Overlay, success: (maxZoom: Double) -> Unit)

    fun setMaxZoom(overlay: Overlay, rawMaxZoom: Any)

    fun getIsMinZoomInclusive(overlay: Overlay, success: (isMinZoomInclusive: Boolean) -> Unit)

    fun setIsMinZoomInclusive(overlay: Overlay, rawIsMinZoomInclusive: Any)

    fun getIsMaxZoomInclusive(overlay: Overlay, success: (isMaxZoomInclusive: Boolean) -> Unit)

    fun setIsMaxZoomInclusive(overlay: Overlay, rawIsMaxZoomInclusive: Any)

    fun performClick(overlay: Overlay, success: (Any?) -> Unit)

    companion object {
        /* --- Messaging Name Define --- */
        private const val zIndexName = "zIndex"
        private const val globalZIndexName = "globalZIndex"
        private const val tagName = "tag"
        private const val isAddedName = "isAdded"
        private const val isVisibleName = "isVisible"
        private const val minZoomName = "minZoom"
        private const val maxZoomName = "maxZoom"
        private const val isMinZoomInclusiveName = "isMinZoomInclusive"
        private const val isMaxZoomInclusiveName = "isMaxZoomInclusive"
        private const val performClickName = "performClick"
        const val onTapName = "onTap"
        fun getterName(name: String): String = "get${name}"
    }
}
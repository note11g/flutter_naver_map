package dev.note11.flutter_naver_map.flutter_naver_map.model.map.info

import com.naver.maps.map.Pickable
import com.naver.maps.map.Symbol
import com.naver.maps.map.overlay.Overlay
import dev.note11.flutter_naver_map.flutter_naver_map.controller.NaverMapControlHandler

internal interface NPickableInfo {
    fun toMessageable(): Map<String, Any?>

    /** @see [NaverMapControlHandler.pickAll] */
    fun toSignedMessageable(): Map<String, Any?> =
        toMessageable() + mapOf("signature" to if (this is NSymbolInfo) "symbol" else "overlay")

    companion object {
        fun fromPickable(pickable: Pickable): NPickableInfo = when (pickable) {
            is Symbol -> NSymbolInfo(pickable)
            is Overlay -> NOverlayInfo.fromOverlay(pickable)
            else -> throw IllegalArgumentException("Unknown pickable type")
        }
    }
}
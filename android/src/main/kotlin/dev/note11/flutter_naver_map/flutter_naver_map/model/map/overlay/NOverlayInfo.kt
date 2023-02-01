package dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay

import com.naver.maps.map.overlay.Overlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.model.enum.NOverlayType

internal data class NOverlayInfo(
    val type: NOverlayType,
    val id: String,
    val method: String? = null,
) {
    fun getOverlay(overlays: Map<String, Overlay>): Overlay? = overlays[overlayMapKey]

    /* ----- toMessageable ----- */

    val overlayMapKey = listOf(type, id).joinToString(SEPARATE_STRING)

    fun toQueryString(injectMethod: String? = null): String =
        listOf(overlayMapKey, injectMethod ?: method).joinToString(SEPARATE_STRING)

    fun toMap(): Map<String, Any> = mapOf("type" to type.toString(), "id" to id)

    /* ----- fromMessageable ----- */
    companion object {
        fun fromMap(rawMap: Any): NOverlayInfo = rawMap.asMap().let { map ->
            NOverlayInfo(
                type = NOverlayType.fromString(map["type"]!!.toString()),
                id = map["id"]!!.toString(),
            )
        }

        fun fromString(query: String): NOverlayInfo = query.split(SEPARATE_STRING).let {
            NOverlayInfo(
                type = NOverlayType.fromString(it[0]),
                id = it[1],
                method = it.getOrNull(2),
            )
        }

        private const val SEPARATE_STRING = "\""

        val locationOverlayInfo = NOverlayInfo(NOverlayType.LOCATION_OVERLAY, "L")
    }
}

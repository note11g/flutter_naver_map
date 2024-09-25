package dev.note11.flutter_naver_map.flutter_naver_map.model.map.info

import com.naver.maps.map.overlay.Overlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.model.enum.NOverlayType

internal open class NOverlayInfo(open val type: NOverlayType, open val id: String) : NPickableInfo {
    companion object {
        fun fromMessageable(rawMap: Any): NOverlayInfo = rawMap.asMap().let { map ->
            NOverlayInfo(
                type = NOverlayType.fromString(map["type"]!!.toString()),
                id = map["id"]!!.toString(),
            )
        }

        fun fromOverlay(overlay: Overlay): NOverlayInfo = overlay.tag as NOverlayInfo

        val locationOverlayInfo = NOverlayInfo(NOverlayType.LOCATION_OVERLAY, "L")
    }

    override fun toMessageable(): Map<String, Any?> = mapOf("type" to type.toString(), "id" to id)

    fun saveAtOverlay(overlay: Overlay) {
        overlay.tag = this
    }


    // ----- HashCode & Equals -----

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (other !is NOverlayInfo) return false

        if (type != other.type) return false
        if (id != other.id) return false

        return true
    }

    override fun hashCode(): Int {
        var result = type.hashCode()
        result = 31 * result + id.hashCode()
        return result
    }

    override fun toString(): String {
        return "NOverlayInfo(type=$type, id='$id')"
    }
}
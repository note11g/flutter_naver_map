package dev.note11.flutter_naver_map.flutter_naver_map.model.map.info

import com.naver.maps.geometry.LatLng
import com.naver.maps.map.clustering.ClusteringKey
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asStringMap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLatLng
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.toMessageable
import dev.note11.flutter_naver_map.flutter_naver_map.model.enum.NOverlayType

internal class NClusterableMarkerInfo(
    override val id: String,
    val tags: Map<String, String>,
    val point: LatLng, // for prevent jvm signature duplicate. (getPosition method)
) :
    NOverlayInfo(NOverlayType.CLUSTERABLE_MARKER, id), ClusteringKey {

    val messageOverlayInfo get() = NOverlayInfo(NOverlayType.CLUSTERABLE_MARKER, id)

    override fun getPosition(): LatLng = point

    override fun toMessageable(): Map<String, Any?> {
        return super.toMessageable() + mapOf(
            "tags" to tags,
            "position" to point.toMessageable(),
        )
    }

    companion object {
        fun fromMessageable(rawMap: Any): NClusterableMarkerInfo = rawMap.asMap().let { map ->
            NClusterableMarkerInfo(
                id = map["id"]!!.toString(),
                tags = map["tags"]!!.asStringMap(),
                point = map["position"]!!.asLatLng(),
            )
        }
    }

    override fun toString(): String {
        return "NClusterableMarkerInfo(id='$id', tags=$tags, point=$point)"
    }


    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (!super.equals(other)) return false
        if (other !is NOverlayInfo) return false

        return id == other.id
    }

    override fun hashCode(): Int {
        return super.hashCode()
    }
}
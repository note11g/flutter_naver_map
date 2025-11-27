package dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay

import com.naver.maps.geometry.LatLng
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.toMessageable
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.info.NClusterableMarkerInfo

internal data class NClusterableMarker(
    override val info: NClusterableMarkerInfo,
    override val wrappedMarker: NMarker, // 복호화시 필요
) : LazyOverlay<NClusterableMarker, NMarker>, NClusterNode {

    override fun createMapOverlay(): NClusterableMarker = this

    companion object {
        fun fromMessageable(rawMap: Map<String, Any>): NClusterableMarker {
            return NClusterableMarker(
                info = NClusterableMarkerInfo.fromMessageable(rawMap.asMap()[infoName]!!),
                wrappedMarker = AddableOverlay.fromMessageableCorrector(
                    rawMap, NMarker::fromMessageable
                )
            )
        }

        /*
            --- Messaging Name Define ---
        */
        private const val infoName = "info"
    }
}

internal sealed interface NClusterNode {}

internal data class NClusterInfo(
    val children: List<NClusterableMarkerInfo>,
    val clusterSize: Int,
    val position: LatLng,
    val mergedTagKey: String?,
    val mergedTag: String?,
): NClusterNode {
    private val id: String = hashCode().toString()

        val markerInfo: NClusterableMarkerInfo = NClusterableMarkerInfo(
            id = id,
            tags = mapOf(),
            point = position,
        )

    fun toMessageable(): Map<String, Any?> {
        return mapOf(
            "id" to id,
            "children" to children.map { it.toMessageable() },
            "clusterSize" to clusterSize,
            "position" to position.toMessageable(),
            "mergedTagKey" to mergedTagKey,
            "mergedTag" to mergedTag,
        )
    }

    override fun hashCode(): Int {
        var result = children.hashCode()
        result = 31 * result + clusterSize
        result = 31 * result + position.hashCode()
        return result
    }

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as NClusterInfo

        if (children != other.children) return false
        if (clusterSize != other.clusterSize) return false
        if (position != other.position) return false
        if (mergedTagKey != other.mergedTagKey) return false
        if (mergedTag != other.mergedTag) return false

        return true
    }
}
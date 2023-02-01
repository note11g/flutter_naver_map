package dev.note11.flutter_naver_map.flutter_naver_map.model.overlay.overlay

import androidx.annotation.ColorInt
import com.naver.maps.geometry.LatLng
import com.naver.maps.map.overlay.Overlay
import com.naver.maps.map.overlay.PolygonOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.AddableOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asInt
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asList
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLatLng
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.toMap
import dev.note11.flutter_naver_map.flutter_naver_map.model.enum.NOverlayType
import dev.note11.flutter_naver_map.flutter_naver_map.model.overlay.NOverlayInfo
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil

internal data class NPolygonOverlay(
    override val info: NOverlayInfo,
    val coords: List<LatLng>,
    @ColorInt val color: Int,
    val holes: List<List<LatLng>>,
    @ColorInt val outlineColor: Int,
    val outlineWidthDp: Double,
) : AddableOverlay<PolygonOverlay> {

    override fun createMapOverlay(): PolygonOverlay = PolygonOverlay().also { g ->
        g.coords = coords
        g.color = color
        g.holes = holes
        g.outlineColor = outlineColor
        g.outlineWidth = DisplayUtil.dpToPx(outlineWidthDp)
    }

    override fun toMap(): Map<String, Any?> = mapOf(
        infoName to info.toMap(),
        coordsName to coords.map { it.toMap() },
        colorName to color,
        holesName to holes.map { it.map { latLng -> latLng.toMap() } },
        outlineColorName to outlineColor,
        outlineWidthName to outlineWidthDp,
    )

    companion object {
        fun fromMap(rawMap: Any): NPolygonOverlay = rawMap.asMap().let {
            NPolygonOverlay(
                info = NOverlayInfo.fromMap(it[infoName]!!),
                coords = it[coordsName]!!.asList { latLng -> latLng.asLatLng() },
                color = it[colorName]!!.asInt(),
                holes = it[holesName]!!.asList { hole ->
                    hole.asList { latLng -> latLng.asLatLng() }
                },
                outlineColor = it[outlineColorName]!!.asInt(),
                outlineWidthDp = it[outlineWidthName]!!.asDouble(),
            )
        }

        fun fromPolygonOverlay(
            polygonOverlay: Overlay,
            id: String,
        ): NPolygonOverlay = (polygonOverlay as PolygonOverlay).run {
            NPolygonOverlay(
                info = NOverlayInfo(NOverlayType.POLYGON_OVERLAY, id),
                coords = coords,
                color = color,
                holes = holes,
                outlineColor = outlineColor,
                outlineWidthDp = DisplayUtil.pxToDp(outlineWidth),
            )
        }

        /*
            --- Messaging Name Define ---
        */

        private const val infoName = "info"
        const val coordsName = "coords"
        const val colorName = "color"
        const val holesName = "holes"
        const val outlineColorName = "outlineColor"
        const val outlineWidthName = "outlineWidth"
        const val boundsName = "bounds"
    }
}
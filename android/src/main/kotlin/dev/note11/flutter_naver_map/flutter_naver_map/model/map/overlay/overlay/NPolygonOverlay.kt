package dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay

import androidx.annotation.ColorInt
import com.naver.maps.geometry.LatLng
import com.naver.maps.map.overlay.PolygonOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.AddableOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asInt
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asList
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLatLng
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.info.NOverlayInfo
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil

internal data class NPolygonOverlay(
    override val info: NOverlayInfo,
    val coords: List<LatLng>,
    @ColorInt val color: Int,
    val holes: List<List<LatLng>>,
    @ColorInt val outlineColor: Int,
    val outlineWidthDp: Double,
    val outlinePatternDp: List<Double>,
) : AddableOverlay<PolygonOverlay>() {



    override fun createMapOverlay(): PolygonOverlay = applyAtRawOverlay(PolygonOverlay())

    override fun applyAtRawOverlay(overlay: PolygonOverlay) = overlay.also { g ->
        g.coords = coords
        g.color = color
        g.holes = holes
        g.outlineColor = outlineColor
        g.outlineWidth = DisplayUtil.dpToPx(outlineWidthDp)
        g.setOutlinePattern(*outlinePatternDp.map { DisplayUtil.dpToPx(it) }.toIntArray())
    }

    companion object {
        fun fromMessageable(rawMap: Any): NPolygonOverlay = rawMap.asMap().let {
            NPolygonOverlay(
                info = NOverlayInfo.fromMessageable(it[infoName]!!),
                coords = it[coordsName]!!.asList { latLng -> latLng.asLatLng() },
                color = it[colorName]!!.asInt(),
                holes = it[holesName]!!.asList { hole ->
                    hole.asList { latLng -> latLng.asLatLng() }
                },
                outlineColor = it[outlineColorName]!!.asInt(),
                outlineWidthDp = it[outlineWidthName]!!.asDouble(),
                outlinePatternDp = it[outlinePatternName]!!.asList { p -> p.asDouble() },
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
        const val outlinePatternName = "outlinePattern"
        const val boundsName = "bounds"
    }
}
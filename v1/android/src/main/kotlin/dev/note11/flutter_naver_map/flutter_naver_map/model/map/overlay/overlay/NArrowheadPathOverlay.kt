package dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay

import androidx.annotation.ColorInt
import com.naver.maps.geometry.LatLng
import com.naver.maps.map.overlay.ArrowheadPathOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.AddableOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asFloat
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asInt
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asList
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLatLng
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.info.NOverlayInfo
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil

internal data class NArrowheadPathOverlay(
    override val info: NOverlayInfo,
    val coords: List<LatLng>,
    val widthDp: Double,
    @ColorInt val color: Int,
    val outlineWidthDp: Double,
    @ColorInt val outlineColor: Int,
    val elevationDp: Double,
    val headSizeRatio: Float,
) : AddableOverlay<ArrowheadPathOverlay>() {

    override fun createMapOverlay(): ArrowheadPathOverlay = applyAtRawOverlay(ArrowheadPathOverlay())

    override fun applyAtRawOverlay(overlay: ArrowheadPathOverlay)= overlay.also { g ->
        g.coords = coords
        g.width = DisplayUtil.dpToPx(widthDp)
        g.color = color
        g.outlineWidth = DisplayUtil.dpToPx(outlineWidthDp)
        g.outlineColor = outlineColor
        g.elevation = DisplayUtil.dpToPx(elevationDp)
        g.headSizeRatio = headSizeRatio
    }


    companion object {
        fun fromMessageable(rawMap: Any): NArrowheadPathOverlay = rawMap.asMap().let {
            NArrowheadPathOverlay(
                info = NOverlayInfo.fromMessageable(it[infoName]!!),
                coords = it[coordsName]!!.asList { coord -> coord.asLatLng() },
                widthDp = it[widthName]!!.asDouble(),
                color = it[colorName]!!.asInt(),
                outlineWidthDp = it[outlineWidthName]!!.asDouble(),
                outlineColor = it[outlineColorName]!!.asInt(),
                elevationDp = it[elevationName]!!.asDouble(),
                headSizeRatio = it[headSizeRatioName]!!.asFloat(),
            )
        }

        /*
            --- Messaging Name Define ---
        */
        private const val infoName = "info"
        const val coordsName = "coords"
        const val widthName = "width"
        const val colorName = "color"
        const val outlineWidthName = "outlineWidth"
        const val outlineColorName = "outlineColor"
        const val elevationName = "elevation"
        const val headSizeRatioName = "headSizeRatio"
        const val boundsName = "bounds"
    }
}
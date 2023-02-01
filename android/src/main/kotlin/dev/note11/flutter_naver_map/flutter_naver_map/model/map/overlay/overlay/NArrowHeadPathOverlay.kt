package dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay

import androidx.annotation.ColorInt
import com.naver.maps.geometry.LatLng
import com.naver.maps.map.overlay.ArrowheadPathOverlay
import com.naver.maps.map.overlay.Overlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.AddableOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asFloat
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asInt
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asList
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLatLng
import dev.note11.flutter_naver_map.flutter_naver_map.model.enum.NOverlayType
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.NOverlayInfo
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil

internal data class NArrowHeadPathOverlay(
    override val info: NOverlayInfo,
    val coords: List<LatLng>,
    val widthDp: Double,
    @ColorInt val color: Int,
    val outlineWidthDp: Double,
    @ColorInt val outlineColor: Int,
    val elevationDp: Double,
    val headSizeRatio: Float,
) : AddableOverlay<ArrowheadPathOverlay> {

    override fun createMapOverlay(): ArrowheadPathOverlay = ArrowheadPathOverlay().also { g ->
        g.coords = coords
        g.width = DisplayUtil.dpToPx(widthDp)
        g.color = color
        g.outlineWidth = DisplayUtil.dpToPx(outlineWidthDp)
        g.outlineColor = outlineColor
        g.elevation = DisplayUtil.dpToPx(elevationDp)
        g.headSizeRatio = headSizeRatio
    }

    override fun toMap(): Map<String, Any?> = mapOf(
        infoName to info.toMap(),
        coordsName to coords,
        widthName to widthDp,
        colorName to color,
        outlineWidthName to outlineWidthDp,
        outlineColorName to outlineColor,
        elevationName to elevationDp,
        headSizeRatioName to headSizeRatio,
    )

    companion object {
        fun fromMap(rawMap: Any): NArrowHeadPathOverlay = rawMap.asMap().let {
            NArrowHeadPathOverlay(
                info = NOverlayInfo.fromMap(it[infoName]!!),
                coords = it[coordsName]!!.asList { coord -> coord.asLatLng() },
                widthDp = it[widthName]!!.asDouble(),
                color = it[colorName]!!.asInt(),
                outlineWidthDp = it[outlineWidthName]!!.asDouble(),
                outlineColor = it[outlineColorName]!!.asInt(),
                elevationDp = it[elevationName]!!.asDouble(),
                headSizeRatio = it[headSizeRatioName]!!.asFloat(),
            )
        }

        fun fromArrowheadPathOverlay(
            arrowheadPathOverlay: Overlay, id: String,
        ): NArrowHeadPathOverlay = (arrowheadPathOverlay as ArrowheadPathOverlay).run {
            NArrowHeadPathOverlay(
                info = NOverlayInfo(NOverlayType.ARROW_HEAD_PATH_OVERLAY, id),
                coords = coords,
                widthDp = DisplayUtil.pxToDp(width),
                color = color,
                outlineWidthDp = DisplayUtil.pxToDp(outlineWidth),
                outlineColor = outlineColor,
                elevationDp = DisplayUtil.pxToDp(elevation),
                headSizeRatio = headSizeRatio,
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
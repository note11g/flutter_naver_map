package dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay

import androidx.annotation.ColorInt
import com.naver.maps.geometry.LatLng
import com.naver.maps.map.overlay.PolylineOverlay
import com.naver.maps.map.overlay.PolylineOverlay.LineCap
import com.naver.maps.map.overlay.PolylineOverlay.LineJoin
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.AddableOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asInt
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asList
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLatLng
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLineCap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLineJoin
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.info.NOverlayInfo
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil

internal data class NPolylineOverlay(
    override val info: NOverlayInfo,
    val coords: List<LatLng>,
    @ColorInt val color: Int,
    val widthDp: Double,
    val lineCap: LineCap,
    val lineJoin: LineJoin,
    val patternDp: List<Double>,
) : AddableOverlay<PolylineOverlay>() {



    override fun createMapOverlay(): PolylineOverlay = applyAtRawOverlay(PolylineOverlay())

    override fun applyAtRawOverlay(overlay: PolylineOverlay) = overlay.also { g ->
        g.coords = coords
        g.color = color
        g.width = DisplayUtil.dpToPx(widthDp)
        g.capType = lineCap
        g.joinType = lineJoin
        g.setPattern(*patternDp.map { DisplayUtil.dpToPx(it) }.toIntArray())
    }

    companion object {
        fun fromMessageable(rawMap: Any): NPolylineOverlay = rawMap.asMap().let {
            NPolylineOverlay(
                info = NOverlayInfo.fromMessageable(it[infoName]!!),
                coords = it[coordsName]!!.asList { latLng -> latLng.asLatLng() },
                color = it[colorName]!!.asInt(),
                widthDp = it[widthName]!!.asDouble(),
                lineCap = it[lineCapName]!!.asLineCap(),
                lineJoin = it[lineJoinName]!!.asLineJoin(),
                patternDp = it[patternName]!!.asList { p -> p.asDouble() },
            )
        }

        /*
            --- Messaging Name Define ---
        */

        private const val infoName = "info";
        const val coordsName = "coords";
        const val colorName = "color";
        const val widthName = "width";
        const val lineCapName = "lineCap";
        const val lineJoinName = "lineJoin";
        const val patternName = "pattern";
        const val boundsName = "bounds";
    }
}
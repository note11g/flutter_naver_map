package dev.note11.flutter_naver_map.flutter_naver_map.model.overlay.overlay

import androidx.annotation.ColorInt
import com.naver.maps.geometry.LatLng
import com.naver.maps.map.overlay.Overlay
import com.naver.maps.map.overlay.PolylineOverlay
import com.naver.maps.map.overlay.PolylineOverlay.LineCap
import com.naver.maps.map.overlay.PolylineOverlay.LineJoin
import dev.note11.flutter_naver_map.flutter_naver_map.converter.AddableOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asInt
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asList
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLatLng
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLineCap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLineJoin
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.toMap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.toMessageableString
import dev.note11.flutter_naver_map.flutter_naver_map.model.enum.NOverlayType
import dev.note11.flutter_naver_map.flutter_naver_map.model.overlay.NOverlayInfo
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil
import kotlin.math.roundToInt

internal data class NPolylineOverlay(
    override val info: NOverlayInfo,
    val coords: List<LatLng>,
    @ColorInt val color: Int,
    val widthDp: Double,
    val lineCap: LineCap,
    val lineJoin: LineJoin,
    val patternDp: List<Int>,
) : AddableOverlay<PolylineOverlay> {

    override fun createMapOverlay(): PolylineOverlay = PolylineOverlay().also { g ->
        g.coords = coords
        g.color = color
        g.width = DisplayUtil.dpToPx(widthDp)
        g.capType = lineCap
        g.joinType = lineJoin
        g.setPattern(*patternDp.map { DisplayUtil.dpToPx(it.toDouble()) }.toIntArray())
    }

    override fun toMap(): Map<String, Any?> = mapOf(
        infoName to info.toMap(),
        coordsName to coords.map { it.toMap() },
        colorName to color,
        widthName to widthDp,
        lineCapName to lineCap.toMessageableString(),
        lineJoinName to lineJoin.toMessageableString(),
        patternName to patternDp.map { DisplayUtil.pxToDp(it).roundToInt() },
    )

    companion object {
        fun fromMap(rawMap: Any): NPolylineOverlay = rawMap.asMap().let {
            NPolylineOverlay(
                info = NOverlayInfo.fromMap(it[infoName]!!),
                coords = it[coordsName]!!.asList { latLng -> latLng.asLatLng() },
                color = it[colorName]!!.asInt(),
                widthDp = it[widthName]!!.asDouble(),
                lineCap = it[lineCapName]!!.asLineCap(),
                lineJoin = it[lineJoinName]!!.asLineJoin(),
                patternDp = it[patternName]!!.asList { p -> p.asInt() },
            )
        }

        fun fromPolylineOverlay(
            polylineOverlay: Overlay,
            id: String,
        ): NPolylineOverlay = (polylineOverlay as PolylineOverlay).run {
            NPolylineOverlay(
                info = NOverlayInfo(NOverlayType.POLYLINE_OVERLAY, id),
                coords = coords,
                color = color,
                widthDp = DisplayUtil.pxToDp(width),
                lineCap = capType,
                lineJoin = joinType,
                patternDp = pattern.map { DisplayUtil.pxToDp(it).roundToInt() }
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
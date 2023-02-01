package dev.note11.flutter_naver_map.flutter_naver_map.model.overlay.overlay

import androidx.annotation.ColorInt
import com.naver.maps.geometry.LatLng
import com.naver.maps.map.overlay.CircleOverlay
import com.naver.maps.map.overlay.Overlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.AddableOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asInt
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLatLng
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.toMap
import dev.note11.flutter_naver_map.flutter_naver_map.model.enum.NOverlayType
import dev.note11.flutter_naver_map.flutter_naver_map.model.overlay.NOverlayInfo
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil

internal data class NCircleOverlay(
    override val info: NOverlayInfo,
    val center: LatLng,
    val radius: Double, // meter
    @ColorInt val color: Int,
    @ColorInt val outlineColor: Int,
    val outlineWidthDp: Double,
) : AddableOverlay<CircleOverlay> {

    override fun createMapOverlay(): CircleOverlay = CircleOverlay().also { c ->
        c.center = center
        c.radius = radius
        c.color = color
        c.outlineColor = outlineColor
        c.outlineWidth = DisplayUtil.dpToPx(outlineWidthDp)
    }

    override fun toMap(): Map<String, Any?> = mapOf(
        infoName to info.toMap(),
        centerName to center.toMap(),
        radiusName to radius,
        colorName to color,
        outlineColorName to outlineColor,
        outlineWidthName to outlineWidthDp,
    )

    companion object {
        fun fromMap(rawMap: Any): NCircleOverlay = rawMap.asMap().let {
            NCircleOverlay(
                info = NOverlayInfo.fromMap(it[infoName]!!),
                center = it[centerName]!!.asLatLng(),
                radius = it[radiusName]!!.asDouble(),
                color = it[colorName]!!.asInt(),
                outlineColor = it[outlineColorName]!!.asInt(),
                outlineWidthDp = it[outlineWidthName]!!.asDouble(),
            )
        }

        fun fromCircleOverlay(
            circleOverlay: Overlay,
            id: String,
        ): NCircleOverlay = (circleOverlay as CircleOverlay).run {
            NCircleOverlay(
                info = NOverlayInfo(NOverlayType.CIRCLE_OVERLAY, id),
                center = center,
                radius = radius,
                color = color,
                outlineColor = outlineColor,
                outlineWidthDp = DisplayUtil.pxToDp(outlineWidth),
            )
        }


        /*
            --- Messaging Name Define ---
        */

        private const val infoName = "info"
        const val centerName = "center"
        const val radiusName = "radius"
        const val colorName = "color"
        const val outlineColorName = "outlineColor"
        const val outlineWidthName = "outlineWidth"
        const val boundsName = "bounds"
    }
}
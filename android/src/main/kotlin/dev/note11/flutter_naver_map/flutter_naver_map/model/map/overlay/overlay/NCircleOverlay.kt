package dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay

import androidx.annotation.ColorInt
import com.naver.maps.geometry.LatLng
import com.naver.maps.map.overlay.CircleOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.AddableOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asInt
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLatLng
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.info.NOverlayInfo
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil

internal data class NCircleOverlay(
    override val info: NOverlayInfo,
    val center: LatLng,
    val radius: Double, // meter
    @ColorInt val color: Int,
    @ColorInt val outlineColor: Int,
    val outlineWidthDp: Double,
) : AddableOverlay<CircleOverlay>() {

    override fun createMapOverlay(): CircleOverlay = applyAtRawOverlay(CircleOverlay())

    override fun applyAtRawOverlay(overlay: CircleOverlay) = overlay.also { c ->
        c.center = center
        c.radius = radius
        c.color = color
        c.outlineColor = outlineColor
        c.outlineWidth = DisplayUtil.dpToPx(outlineWidthDp)
    }

    companion object {
        fun fromMessageable(rawMap: Any): NCircleOverlay = rawMap.asMap().let {
            NCircleOverlay(
                info = NOverlayInfo.fromMessageable(it[infoName]!!),
                center = it[centerName]!!.asLatLng(),
                radius = it[radiusName]!!.asDouble(),
                color = it[colorName]!!.asInt(),
                outlineColor = it[outlineColorName]!!.asInt(),
                outlineWidthDp = it[outlineWidthName]!!.asDouble(),
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
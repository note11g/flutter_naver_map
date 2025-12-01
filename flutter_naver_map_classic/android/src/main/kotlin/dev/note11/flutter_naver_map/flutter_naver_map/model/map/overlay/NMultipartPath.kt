package dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay

import androidx.annotation.ColorInt
import com.naver.maps.geometry.LatLng
import com.naver.maps.map.overlay.MultipartPathOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asInt
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asList
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLatLng
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.toMessageable

data class NMultipartPath(
    val coords: List<LatLng>,
    @ColorInt val color: Int,
    @ColorInt val outlineColor: Int,
    @ColorInt val passedColor: Int,
    @ColorInt val passedOutlineColor: Int,
) {

    fun toColorPart(): MultipartPathOverlay.ColorPart = MultipartPathOverlay.ColorPart(
        color, outlineColor, passedColor, passedOutlineColor,
    )

    fun toMessageable(): Map<String, Any?> = mapOf(
        "coords" to coords.map { it.toMessageable() },
        "color" to color,
        "outlineColor" to outlineColor,
        "passedColor" to passedColor,
        "passedOutlineColor" to passedOutlineColor,
    )

    companion object {
        fun fromMessageable(rawMap: Any): NMultipartPath = rawMap.asMap().let {
            NMultipartPath(
                coords = it["coords"]!!.asList { l -> l.asLatLng() },
                color = it["color"]!!.asInt(),
                outlineColor = it["outlineColor"]!!.asInt(),
                passedColor = it["passedColor"]!!.asInt(),
                passedOutlineColor = it["passedOutlineColor"]!!.asInt(),
            )
        }

        fun fromCoordsAndColorParts(
            coords: List<LatLng>,
            colorPart: MultipartPathOverlay.ColorPart,
        ): NMultipartPath =
            NMultipartPath(
                coords = coords,
                color = colorPart.color,
                outlineColor = colorPart.outlineColor,
                passedColor = colorPart.passedColor,
                passedOutlineColor = colorPart.passedOutlineColor,
            )
    }
}
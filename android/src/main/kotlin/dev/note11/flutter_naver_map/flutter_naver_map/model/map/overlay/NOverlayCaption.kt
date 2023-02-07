package dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay

import androidx.annotation.ColorInt
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asFloat
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asInt
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil

internal data class NOverlayCaption(
    val text: String,
    val textSize: Float,
    @ColorInt val color: Int,
    @ColorInt val haloColor: Int,
    val minZoom: Double,
    val maxZoom: Double,
    val requestWidth: Double,
) {
    fun useWithFunctions(
        textFunc: (String) -> Unit,
        textSizeFunc: (Float) -> Unit,
        colorFunc: (Int) -> Unit,
        haloColorFunc: (Int) -> Unit,
        minZoomFunc: (Double) -> Unit,
        maxZoomFunc: (Double) -> Unit,
        requestWidthFunc: (Int) -> Unit,
    ) {
        textFunc(text)
        textSizeFunc(textSize)
        colorFunc(color)
        haloColorFunc(haloColor)
        minZoomFunc(minZoom)
        maxZoomFunc(maxZoom)
        requestWidthFunc(DisplayUtil.dpToPx(requestWidth))
    }

    fun toMessageable(): Map<String, Any> = mapOf(
        "text" to text,
        "textSize" to textSize,
        "color" to color,
        "haloColor" to haloColor,
        "minZoom" to minZoom,
        "maxZoom" to maxZoom,
        "requestWidth" to requestWidth,
    )

    companion object {
        fun fromMessageable(rawMap: Any): NOverlayCaption = rawMap.asMap().let {
            NOverlayCaption(
                text = it["text"]!!.toString(),
                textSize = it["textSize"]!!.asFloat(),
                color = it["color"]!!.asInt(),
                haloColor = it["haloColor"]!!.asInt(),
                minZoom = it["minZoom"]!!.asDouble(),
                maxZoom = it["maxZoom"]!!.asDouble(),
                requestWidth = it["requestWidth"]!!.asDouble(),
            )
        }
    }
}
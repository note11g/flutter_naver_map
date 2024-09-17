package dev.note11.flutter_naver_map.flutter_naver_map.model.base

import androidx.annotation.Px
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil.dpToPx
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil.pxToDp

data class NSize(
    val width: Double,
    val height: Double,
) {

    fun useAsPixelSize(widthFunc: (px: Int) -> Unit, heightFunc: (px: Int) -> Unit) {
        widthFunc(dpToPx(width))
        heightFunc(dpToPx(height))
    }

    fun toMessageable(): Map<String, Any> {
        return mapOf(
            "width" to width,
            "height" to height
        )
    }

    companion object {
        fun fromPixelSize(@Px width: Int, @Px height: Int): NSize {
            return NSize(
                width = pxToDp(width),
                height = pxToDp(height)
            )
        }

        fun fromMessageable(rawNSize: Any): NSize = rawNSize.asMap().let {
            return NSize(
                width = it["width"]!!.asDouble(),
                height = it["height"]!!.asDouble()
            )
        }
    }
}
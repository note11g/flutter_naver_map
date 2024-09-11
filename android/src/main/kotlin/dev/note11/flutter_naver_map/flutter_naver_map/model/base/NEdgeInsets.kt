package dev.note11.flutter_naver_map.flutter_naver_map.model.base

import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil

internal data class NEdgeInsets(
    private val left: Double,
    private val top: Double,
    private val right: Double,
    private val bottom: Double,
    val leftPx: Int,
    val topPx: Int,
    val rightPx: Int,
    val bottomPx: Int,
) {

    fun <T> use(func: (left: Int, top: Int, right: Int, bottom: Int) -> T): T =
        func.invoke(leftPx, topPx, rightPx, bottomPx)

    companion object {
        fun fromMessageable(args: Any): NEdgeInsets = args.asMap().let { map ->
            val left = map["left"]!!.asDouble()
            val top = map["top"]!!.asDouble()
            val right = map["right"]!!.asDouble()
            val bottom = map["bottom"]!!.asDouble()
            NEdgeInsets(
                left, top, right, bottom,
                leftPx = DisplayUtil.dpToPx(left),
                topPx = DisplayUtil.dpToPx(top),
                rightPx = DisplayUtil.dpToPx(right),
                bottomPx = DisplayUtil.dpToPx(bottom)
            )
        }
    }
}

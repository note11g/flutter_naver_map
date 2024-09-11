package dev.note11.flutter_naver_map.flutter_naver_map.model.base

import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.util.CalcUtil
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil

internal data class NPoint(
    val x: Double,
    val y: Double,
) {
    companion object {
        fun fromMessageable(args: Any): NPoint = args.asMap().let { map ->
            NPoint(map["x"]!!.asDouble(), map["y"]!!.asDouble())
        }

        fun fromPointF(pointF: android.graphics.PointF): NPoint {
            val x = CalcUtil.float32To64(pointF.x)
            val y = CalcUtil.float32To64(pointF.y)

            return NPoint(x, y)
        }

        fun fromPointFWithPx(pointF: android.graphics.PointF): NPoint {
            val x = DisplayUtil.pxToDp(pointF.x)
            val y = DisplayUtil.pxToDp(pointF.y)

            return NPoint(x, y)
        }
    }

    fun toPointF(): android.graphics.PointF = android.graphics.PointF(x.toFloat(), y.toFloat())

    fun toPointFWithPx(): android.graphics.PointF =
        android.graphics.PointF(DisplayUtil.dpToPxF(x), DisplayUtil.dpToPxF(y))

    fun toMessageable(): Map<String, Double> = mapOf("x" to x, "y" to y)
}


package dev.note11.flutter_naver_map.flutter_naver_map.util

internal object CalcUtil {
    fun float32To64(f32: Float): Double {
        val convertedInt: Int = (f32 * F32_MULTIPLIER_CONSTANT).toInt()
        return convertedInt.toDouble() / F32_MULTIPLIER_CONSTANT
    }

    private const val F32_MULTIPLIER_CONSTANT: Int = 1_000_000
}
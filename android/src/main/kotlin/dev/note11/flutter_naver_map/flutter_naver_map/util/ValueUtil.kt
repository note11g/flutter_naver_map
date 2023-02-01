package dev.note11.flutter_naver_map.flutter_naver_map.util

internal object ValueUtil {
    fun <T : Number> T.orDefault(defaultValue: T, emptyFlag: Int = -1): T {
        return if (toInt() == emptyFlag) defaultValue else this
    }
}
package dev.note11.flutter_naver_map.flutter_naver_map.model.enum

internal enum class NOverlayImageMode(private val str: String) {
    ASSET("asset"),
    FILE("file"),
    TEMP("temp"),
    WIDGET("widget");

    override fun toString(): String = str

    companion object {
        fun fromString(str: String): NOverlayImageMode =
            NOverlayImageMode.values().find { it.str == str }
                ?: throw Exception("this overlay type not defined. $str")
    }
}
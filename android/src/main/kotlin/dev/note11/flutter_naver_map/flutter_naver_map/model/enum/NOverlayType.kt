package dev.note11.flutter_naver_map.flutter_naver_map.model.enum

internal enum class NOverlayType(private val str: String, val isLazy: Boolean = false) {
    MARKER("ma"),
    INFO_WINDOW("in"),
    CIRCLE_OVERLAY("ci"),
    GROUND_OVERLAY("gr"),
    POLYGON_OVERLAY("pg"),
    POLYLINE_OVERLAY("pl"),
    PATH_OVERLAY("pa"),
    MULTIPART_PATH_OVERLAY("mp"),
    ARROWHEAD_PATH_OVERLAY("ah"),
    LOCATION_OVERLAY("lo"),
    CLUSTERABLE_MARKER("cm", isLazy = true);

    override fun toString(): String = str

    companion object {
        fun fromString(str: String): NOverlayType = values().find { it.str == str }
            ?: throw Exception("this overlay type not defined. $str")
    }
}
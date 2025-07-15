package dev.note11.flutter_naver_map.flutter_naver_map.util.location

enum class NDefaultMyLocationTrackerPermissionStatus(val value: String) {
    Granted("granted"),
    Denied("denied"),
    DeniedForever("deniedForever");

    fun toMessageable(): String {
        return value
    }
}
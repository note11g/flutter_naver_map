package dev.note11.flutter_naver_map.flutter_naver_map.model.exception

data class NFlutterException(
    val code: String,
    val message: String?,
) {
    fun toMessageable(): Map<String, Any?> {
        return mapOf(
            "code" to code,
            "message" to message,
        )
    }
}
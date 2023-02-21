package dev.note11.flutter_naver_map.flutter_naver_map.model.map.info

import dev.note11.flutter_naver_map.flutter_naver_map.model.enum.NOverlayType

internal data class NOverlayQuery(val info: NOverlayInfo, val methodName: String) {
    val query: String get() = encode()

    // ----- Encode -----
    private fun encode(): String =
        listOf(info.type.toString(), info.id, methodName).joinToString(SEPARATOR)

    companion object {
        fun fromQuery(query: String): NOverlayQuery = decode(query)

        // ----- Decode -----
        private fun decode(string: String): NOverlayQuery {
            val split = string.split(SEPARATOR)
            val type = split.first()
            val method = split.last()
            val id = split.drop(1).dropLast(1).joinToString(SEPARATOR)

            return NOverlayQuery(
                NOverlayInfo(NOverlayType.fromString(type), id),
                methodName = method
            )
        }

        private const val SEPARATOR = "\""
    }
}
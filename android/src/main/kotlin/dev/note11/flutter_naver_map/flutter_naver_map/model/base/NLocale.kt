package dev.note11.flutter_naver_map.flutter_naver_map.model.base

import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import java.util.*

internal data class NLocale(
    val languageCode: String, val countryCode: String?,
) {

    fun toLocale(): Locale = if (countryCode == null) {
        Locale(languageCode)
    } else {
        Locale(languageCode, countryCode)
    }

    companion object {
        fun fromMessageable(rawMap: Any): NLocale? = rawMap.asMap().let { map ->
            val languageCode = map["languageCode"].toString()
            if (languageCode == "sys") null
            else NLocale(
                languageCode = languageCode,
                countryCode = map["countryCode"]?.toString()
            )
        }
    }
}


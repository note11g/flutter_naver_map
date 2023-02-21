package dev.note11.flutter_naver_map.flutter_naver_map.model.map.info

import com.naver.maps.geometry.LatLng
import com.naver.maps.map.Symbol
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.toMessageable

internal data class NSymbolInfo(val caption: String, val position: LatLng) : NPickableInfo {
    constructor(symbol: Symbol) : this(symbol.caption, symbol.position)

    override fun toMessageable(): Map<String, Any?> = mapOf(
        "caption" to caption,
        "position" to position.toMessageable(),
    )
}
package dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay

import dev.note11.flutter_naver_map.flutter_naver_map.model.enum.NOverlayType
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.info.NOverlayInfo

internal sealed interface LazyOverlay<NO : Any, O : AddableOverlay<*>> : LazyOrAddableOverlay {
    val info: NOverlayInfo
    abstract override fun createMapOverlay(): NO

    val wrappedMarker: O

    companion object {
        fun fromMessageable(
            info: NOverlayInfo,
            args: Map<String, Any>,
        ): LazyOverlay<*, *> {
            require(info.type.isLazy)

            return when (info.type) {
                NOverlayType.CLUSTERABLE_MARKER -> NClusterableMarker.fromMessageable(args)
                else -> throw IllegalArgumentException("${info.type} is not LazyOverlay")
            }
        }
    }
}
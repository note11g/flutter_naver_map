package dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay

import android.content.Context
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.info.NOverlayInfo

internal sealed interface LazyOrAddableOverlay {
    fun createMapOverlay(): Any

    companion object {
        fun fromMessageable(
            info: NOverlayInfo,
            args: Map<String, Any>,
            context: Context,
        ): LazyOrAddableOverlay {
            if (info.type.isLazy) return LazyOverlay.fromMessageable(info, args)
            return AddableOverlay.fromMessageable(info, args, context)
        }
    }
}

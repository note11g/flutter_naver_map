package dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay

import androidx.annotation.ColorInt
import com.naver.maps.geometry.LatLng
import com.naver.maps.map.overlay.PathOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.AddableOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asBoolean
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asInt
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asList
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLatLng
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.info.NOverlayInfo
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.NOverlayImage
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil

internal data class NPathOverlay(
    override val info: NOverlayInfo,
    val coords: List<LatLng>,
    val widthDp: Double,
    @ColorInt val color: Int,
    val outlineWidthDp: Double,
    @ColorInt val outlineColor: Int,
    @ColorInt val passedColor: Int,
    @ColorInt val passedOutlineColor: Int,
    val progress: Double,
    val patternImage: NOverlayImage?,
    val patternIntervalDp: Double,
    val isHideCollidedCaptions: Boolean,
    val isHideCollidedMarkers: Boolean,
    val isHideCollidedSymbols: Boolean,
) : AddableOverlay<PathOverlay>() {


    override fun createMapOverlay(): PathOverlay = applyAtRawOverlay(PathOverlay())

    override fun applyAtRawOverlay(overlay: PathOverlay) = overlay.also { g ->
        g.coords = coords
        g.width = DisplayUtil.dpToPx(widthDp)
        g.color = color
        g.outlineColor = outlineColor
        g.outlineWidth = DisplayUtil.dpToPx(outlineWidthDp)
        g.passedColor = passedColor
        g.passedOutlineColor = passedOutlineColor
        g.progress = progress
        patternImage?.applyToOverlay(g::setPatternImage)
        g.patternInterval = DisplayUtil.dpToPx(patternIntervalDp)
        g.isHideCollidedCaptions = isHideCollidedCaptions
        g.isHideCollidedMarkers = isHideCollidedMarkers
        g.isHideCollidedSymbols = isHideCollidedSymbols
    }

    companion object {
        fun fromMessageable(rawMap: Any): NPathOverlay = rawMap.asMap().let {
            NPathOverlay(
                info = NOverlayInfo.fromMessageable(it[infoName]!!),
                coords = it[coordsName]!!.asList { l -> l.asLatLng() },
                widthDp = it[widthName]!!.asDouble(),
                color = it[colorName]!!.asInt(),
                outlineColor = it[outlineColorName]!!.asInt(),
                outlineWidthDp = it[outlineWidthName]!!.asDouble(),
                passedColor = it[passedColorName]!!.asInt(),
                passedOutlineColor = it[passedOutlineColorName]!!.asInt(),
                progress = it[progressName]!!.asDouble(),
                patternImage = it[patternImageName]?.let(NOverlayImage::fromMessageable),
                patternIntervalDp = it[patternIntervalName]!!.asDouble(),
                isHideCollidedCaptions = it[isHideCollidedCaptionsName]!!.asBoolean(),
                isHideCollidedMarkers = it[isHideCollidedMarkersName]!!.asBoolean(),
                isHideCollidedSymbols = it[isHideCollidedSymbolsName]!!.asBoolean(),
            )
        }

        /*
            --- Messaging Name Define ---
        */
        private const val infoName = "info"
        const val coordsName = "coords"
        const val widthName = "width"
        const val colorName = "color"
        const val outlineWidthName = "outlineWidth"
        const val outlineColorName = "outlineColor"
        const val passedColorName = "passedColor"
        const val passedOutlineColorName = "passedOutlineColor"
        const val progressName = "progress"
        const val patternImageName = "patternImage"
        const val patternIntervalName = "patternInterval"
        const val isHideCollidedCaptionsName = "isHideCollidedCaptions"
        const val isHideCollidedMarkersName = "isHideCollidedMarkers"
        const val isHideCollidedSymbolsName = "isHideCollidedSymbols"
        const val boundsName = "bounds"
    }
}
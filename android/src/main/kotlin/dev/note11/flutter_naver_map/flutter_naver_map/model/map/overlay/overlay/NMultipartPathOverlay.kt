package dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay

import com.naver.maps.geometry.LatLng
import com.naver.maps.map.overlay.MultipartPathOverlay
import com.naver.maps.map.overlay.MultipartPathOverlay.ColorPart
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.AddableOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asBoolean
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asList
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.info.NOverlayInfo
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.NMultipartPath
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.NOverlayImage
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil

internal data class NMultipartPathOverlay(
    override val info: NOverlayInfo,
    val paths: List<NMultipartPath>,
    val widthDp: Double,
    val outlineWidthDp: Double,
    val patternImage: NOverlayImage?,
    val patternIntervalDp: Double,
    val progress: Double,
    val isHideCollidedCaptions: Boolean,
    val isHideCollidedMarkers: Boolean,
    val isHideCollidedSymbols: Boolean,
) : AddableOverlay<MultipartPathOverlay>() {


    override fun createMapOverlay(): MultipartPathOverlay = applyAtRawOverlay(MultipartPathOverlay())

    override fun applyAtRawOverlay(overlay: MultipartPathOverlay) = overlay.also { mo ->
        val coords = mutableListOf<List<LatLng>>()
        val colors = mutableListOf<ColorPart>()
        paths.forEach {
            coords.add(it.coords)
            colors.add(it.toColorPart())
        }
        mo.coordParts = coords
        mo.colorParts = colors
        mo.width = DisplayUtil.dpToPx(widthDp)
        mo.outlineWidth = DisplayUtil.dpToPx(outlineWidthDp)
        patternImage?.applyToOverlay(mo::setPatternImage)
        mo.patternInterval = DisplayUtil.dpToPx(patternIntervalDp)
        mo.progress = progress
        mo.isHideCollidedCaptions = isHideCollidedCaptions
        mo.isHideCollidedMarkers = isHideCollidedMarkers
        mo.isHideCollidedSymbols = isHideCollidedSymbols
    }

    companion object {
        fun fromMessageable(rawMap: Any): NMultipartPathOverlay = rawMap.asMap().let {
            NMultipartPathOverlay(
                info = NOverlayInfo.fromMessageable(it[infoName]!!),
                paths = it[pathsName]!!.asList(NMultipartPath::fromMessageable),
                widthDp = it[widthName]!!.asDouble(),
                outlineWidthDp = it[outlineWidthName]!!.asDouble(),
                patternImage = it[patternImageName]?.let(NOverlayImage::fromMessageable),
                patternIntervalDp = it[patternIntervalName]!!.asDouble(),
                progress = it[progressName]!!.asDouble(),
                isHideCollidedCaptions = it[isHideCollidedCaptionsName]!!.asBoolean(),
                isHideCollidedMarkers = it[isHideCollidedMarkersName]!!.asBoolean(),
                isHideCollidedSymbols = it[isHideCollidedSymbolsName]!!.asBoolean(),
            )
        }

        /*
            --- Messaging Name Define ---
        */
        private const val infoName = "info"
        const val pathsName = "paths"
        const val widthName = "width"
        const val outlineWidthName = "outlineWidth"
        const val patternImageName = "patternImage"
        const val patternIntervalName = "patternInterval"
        const val progressName = "progress"
        const val isHideCollidedCaptionsName = "isHideCollidedCaptions"
        const val isHideCollidedMarkersName = "isHideCollidedMarkers"
        const val isHideCollidedSymbolsName = "isHideCollidedSymbols"
        const val boundsName = "bounds"
    }
}
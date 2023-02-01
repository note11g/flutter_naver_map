package dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay

import com.naver.maps.geometry.LatLng
import com.naver.maps.map.overlay.MultipartPathOverlay
import com.naver.maps.map.overlay.MultipartPathOverlay.ColorPart
import com.naver.maps.map.overlay.Overlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.AddableOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asBoolean
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asList
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.model.enum.NOverlayType
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.NMultipartPath
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.NOverlayImage
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.NOverlayInfo
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
) : AddableOverlay<MultipartPathOverlay> {

    override fun createMapOverlay(): MultipartPathOverlay = MultipartPathOverlay().also { mo ->
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

    override fun toMap(): Map<String, Any?> = mapOf(
        infoName to info.toMap(),
        pathsName to paths.map(NMultipartPath::toMap),
        widthName to widthDp,
        outlineWidthName to outlineWidthDp,
        patternImageName to patternImage?.toMap(),
        patternIntervalName to patternIntervalDp,
        progressName to progress,
        isHideCollidedCaptionsName to isHideCollidedCaptions,
        isHideCollidedMarkersName to isHideCollidedMarkers,
        isHideCollidedSymbolsName to isHideCollidedSymbols,
    )

    companion object {
        fun fromMap(rawMap: Any): NMultipartPathOverlay = rawMap.asMap().let {
            NMultipartPathOverlay(
                info = NOverlayInfo.fromMap(it[infoName]!!),
                paths = it[pathsName]!!.asList(NMultipartPath::fromMap),
                widthDp = it[widthName]!!.asDouble(),
                outlineWidthDp = it[outlineWidthName]!!.asDouble(),
                patternImage = it[patternImageName]?.let(NOverlayImage::fromMap),
                patternIntervalDp = it[patternIntervalName]!!.asDouble(),
                progress = it[progressName]!!.asDouble(),
                isHideCollidedCaptions = it[isHideCollidedCaptionsName]!!.asBoolean(),
                isHideCollidedMarkers = it[isHideCollidedMarkersName]!!.asBoolean(),
                isHideCollidedSymbols = it[isHideCollidedSymbolsName]!!.asBoolean(),
            )
        }

        fun fromMultipartPathOverlay(
            multipartPathOverlay: Overlay,
            id: String,
        ): NMultipartPathOverlay = (multipartPathOverlay as MultipartPathOverlay).run {
            NMultipartPathOverlay(
                info = NOverlayInfo(NOverlayType.MULTI_PART_PATH_OVERLAY, id),
                paths = colorParts.mapIndexed { i, colorPart ->
                    NMultipartPath.fromCoordsAmdColorParts(coordParts[i], colorPart)
                },
                widthDp = DisplayUtil.pxToDp(width),
                outlineWidthDp = DisplayUtil.pxToDp(outlineWidth),
                patternImage = patternImage?.let(NOverlayImage::fromOverlayImage),
                patternIntervalDp = DisplayUtil.pxToDp(patternInterval),
                progress = progress,
                isHideCollidedCaptions = isHideCollidedCaptions,
                isHideCollidedMarkers = isHideCollidedMarkers,
                isHideCollidedSymbols = isHideCollidedSymbols,
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
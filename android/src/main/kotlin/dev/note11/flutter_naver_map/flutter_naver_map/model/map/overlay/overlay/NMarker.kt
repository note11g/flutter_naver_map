package dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay

import com.naver.maps.geometry.LatLng
import com.naver.maps.map.overlay.Align
import com.naver.maps.map.overlay.Marker
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asBoolean
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asFloat
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asInt
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asList
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asAlign
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLatLng
import dev.note11.flutter_naver_map.flutter_naver_map.model.base.NPoint
import dev.note11.flutter_naver_map.flutter_naver_map.model.base.NSize
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.info.NOverlayInfo
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.NOverlayCaption
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.NOverlayImage
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil.dpToPx

internal data class NMarker(
    override val info: NOverlayInfo,
    val position: LatLng,
    val icon: NOverlayImage?,
    val iconTintColor: Int,
    val alpha: Float,
    val angle: Float,
    val anchor: NPoint,
    val size: NSize,
    val caption: NOverlayCaption?,
    val subCaption: NOverlayCaption?,
    val captionAligns: List<Align>,
    val captionDpOffset: Double,
    val isCaptionPerspectiveEnabled: Boolean,
    val isIconPerspectiveEnabled: Boolean,
    val isFlat: Boolean,
    val isForceShowCaption: Boolean,
    val isForceShowIcon: Boolean,
    val isHideCollidedCaptions: Boolean,
    val isHideCollidedMarkers: Boolean,
    val isHideCollidedSymbols: Boolean,
) : AddableOverlay<Marker>() {

    override fun createMapOverlay(): Marker = applyAtRawOverlay(Marker(position))

    override fun applyAtRawOverlay(overlay: Marker): Marker = overlay.also { m ->
        icon?.applyToOverlay(m::setIcon)
        m.iconTintColor = iconTintColor
        m.alpha = alpha
        m.angle = angle
        m.anchor = anchor.toPointF()
        size.useAsPixelSize(m::setWidth, m::setHeight)
        caption?.useWithFunctions(
            textFunc = m::setCaptionText,
            textSizeFunc = m::setCaptionTextSize,
            colorFunc = m::setCaptionColor,
            haloColorFunc = m::setCaptionHaloColor,
            minZoomFunc = m::setCaptionMinZoom,
            maxZoomFunc = m::setCaptionMaxZoom,
            requestWidthFunc = m::setCaptionRequestedWidth,
        )
        subCaption?.useWithFunctions(
            textFunc = m::setSubCaptionText,
            textSizeFunc = m::setSubCaptionTextSize,
            colorFunc = m::setSubCaptionColor,
            haloColorFunc = m::setSubCaptionHaloColor,
            minZoomFunc = m::setSubCaptionMinZoom,
            maxZoomFunc = m::setSubCaptionMaxZoom,
            requestWidthFunc = m::setSubCaptionRequestedWidth,
        )
        m.setCaptionAligns(*captionAligns.toTypedArray())
        m.captionOffset = dpToPx(captionDpOffset)
        m.isCaptionPerspectiveEnabled = isCaptionPerspectiveEnabled
        m.isIconPerspectiveEnabled = isIconPerspectiveEnabled
        m.isFlat = isFlat
        m.isForceShowCaption = isForceShowCaption
        m.isForceShowIcon = isForceShowIcon
        m.isHideCollidedCaptions = isHideCollidedCaptions
        m.isHideCollidedMarkers = isHideCollidedMarkers
        m.isHideCollidedSymbols = isHideCollidedSymbols
    }

    companion object {
        fun fromMessageable(rawMap: Any): NMarker = rawMap.asMap().let {
            NMarker(
                info = NOverlayInfo.fromMessageable(it[infoName]!!),
                position = it[positionName]!!.asLatLng(),
                icon = it[iconName]?.let(NOverlayImage::fromMessageable),
                iconTintColor = it[iconTintColorName]!!.asInt(),
                alpha = it[alphaName]!!.asFloat(),
                angle = it[angleName]!!.asFloat(),
                anchor = NPoint.fromMessageable(it[anchorName]!!),
                size = NSize.fromMessageable(it[sizeName]!!),
                caption = it[captionName]?.let(NOverlayCaption::fromMessageable),
                subCaption = it[subCaptionName]?.let(NOverlayCaption::fromMessageable),
                captionAligns = it[captionAlignsName]!!.asList { raw -> raw.asAlign() },
                captionDpOffset = it[captionOffsetName]!!.asDouble(),
                isCaptionPerspectiveEnabled = it[isCaptionPerspectiveEnabledName]!!.asBoolean(),
                isIconPerspectiveEnabled = it[isIconPerspectiveEnabledName]!!.asBoolean(),
                isFlat = it[isFlatName]!!.asBoolean(),
                isForceShowCaption = it[isForceShowCaptionName]!!.asBoolean(),
                isForceShowIcon = it[isForceShowIconName]!!.asBoolean(),
                isHideCollidedCaptions = it[isHideCollidedCaptionsName]!!.asBoolean(),
                isHideCollidedMarkers = it[isHideCollidedMarkersName]!!.asBoolean(),
                isHideCollidedSymbols = it[isHideCollidedSymbolsName]!!.asBoolean(),
            )
        }

        /*
            --- Messaging Name Define ---
        */

        private const val infoName = "info"
        const val hasOpenInfoWindowName = "hasOpenInfoWindow"
        const val openInfoWindowName = "openInfoWindow"
        const val positionName = "position"
        const val iconName = "icon"
        const val iconTintColorName = "iconTintColor"
        const val alphaName = "alpha"
        const val angleName = "angle"
        const val anchorName = "anchor"
        const val sizeName = "size"
        const val captionName = "caption"
        const val subCaptionName = "subCaption"
        const val captionAlignsName = "captionAligns"
        const val captionOffsetName = "captionOffset"
        const val isCaptionPerspectiveEnabledName = "isCaptionPerspectiveEnabled"
        const val isIconPerspectiveEnabledName = "isIconPerspectiveEnabled"
        const val isFlatName = "isFlat"
        const val isForceShowCaptionName = "isForceShowCaption"
        const val isForceShowIconName = "isForceShowIcon"
        const val isHideCollidedCaptionsName = "isHideCollidedCaptions"
        const val isHideCollidedMarkersName = "isHideCollidedMarkers"
        const val isHideCollidedSymbolsName = "isHideCollidedSymbols"
    }
}
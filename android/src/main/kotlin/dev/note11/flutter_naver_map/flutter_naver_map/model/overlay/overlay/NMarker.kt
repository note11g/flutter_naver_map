package dev.note11.flutter_naver_map.flutter_naver_map.model.overlay.overlay

import com.naver.maps.geometry.LatLng
import com.naver.maps.map.overlay.Align
import com.naver.maps.map.overlay.Marker
import com.naver.maps.map.overlay.Overlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.AddableOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asBoolean
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asFloat
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asInt
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asList
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asAlign
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLatLng
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.toMap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.toMessageableString
import dev.note11.flutter_naver_map.flutter_naver_map.model.NPoint
import dev.note11.flutter_naver_map.flutter_naver_map.model.NSize
import dev.note11.flutter_naver_map.flutter_naver_map.model.enum.NOverlayType
import dev.note11.flutter_naver_map.flutter_naver_map.model.overlay.NOverlayCaption
import dev.note11.flutter_naver_map.flutter_naver_map.model.overlay.NOverlayImage
import dev.note11.flutter_naver_map.flutter_naver_map.model.overlay.NOverlayInfo
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil.dpToPx
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil.pxToDp

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
) : AddableOverlay<Marker> {

    override fun createMapOverlay(): Marker = Marker(position).also { m ->
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

    override fun toMap(): Map<String, Any?> = mapOf(
        infoName to info.toMap(),
        iconName to null,
        positionName to position.toMap(),
        iconTintColorName to iconTintColor,
        alphaName to alpha,
        angleName to angle,
        anchorName to anchor.toMap(),
        sizeName to size.toMap(),
        captionName to caption?.toMap(),
        subCaptionName to subCaption?.toMap(),
        captionAlignsName to captionAligns.map { it.toMessageableString() },
        captionOffsetName to captionDpOffset,
        isCaptionPerspectiveEnabledName to isCaptionPerspectiveEnabled,
        isIconPerspectiveEnabledName to isIconPerspectiveEnabled,
        isFlatName to isFlat,
        isForceShowCaptionName to isForceShowCaption,
        isForceShowIconName to isForceShowIcon,
        isHideCollidedCaptionsName to isHideCollidedCaptions,
        isHideCollidedMarkersName to isHideCollidedMarkers,
        isHideCollidedSymbolsName to isHideCollidedSymbols,
    )

    companion object {
        fun fromMap(rawMap: Any): NMarker = rawMap.asMap().let {
            NMarker(
                info = NOverlayInfo.fromMap(it[infoName]!!),
                position = it[positionName]!!.asLatLng(),
                icon = it[iconName]?.let(NOverlayImage.Companion::fromMap),
                iconTintColor = it[iconTintColorName]!!.asInt(),
                alpha = it[alphaName]!!.asFloat(),
                angle = it[angleName]!!.asFloat(),
                anchor = NPoint.fromMap(it[anchorName]!!),
                size = NSize.fromMap(it[sizeName]!!),
                caption = it[captionName]?.let(NOverlayCaption.Companion::fromMap),
                subCaption = it[subCaptionName]?.let(NOverlayCaption.Companion::fromMap),
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

        fun fromMarker(marker: Overlay, id: String): NMarker = (marker as Marker).run {
            NMarker(
                info = NOverlayInfo(NOverlayType.MARKER, id),
                position = position,
                icon = null,
                iconTintColor = iconTintColor,
                alpha = alpha,
                angle = angle,
                anchor = NPoint.fromPointF(anchor),
                size = NSize.fromPixelSize(width, height),
                caption = NOverlayCaption(
                    text = captionText,
                    textSize = captionTextSize,
                    color = captionColor,
                    haloColor = captionHaloColor,
                    minZoom = captionMinZoom,
                    maxZoom = captionMaxZoom,
                    requestWidth = pxToDp(captionRequestedWidth),
                ),
                subCaption = NOverlayCaption(
                    text = subCaptionText,
                    textSize = subCaptionTextSize,
                    color = subCaptionColor,
                    haloColor = subCaptionHaloColor,
                    minZoom = subCaptionMinZoom,
                    maxZoom = subCaptionMaxZoom,
                    requestWidth = pxToDp(subCaptionRequestedWidth),
                ),
                captionAligns = captionAligns.toList(),
                captionDpOffset = pxToDp(captionOffset),
                isCaptionPerspectiveEnabled = isCaptionPerspectiveEnabled,
                isIconPerspectiveEnabled = isIconPerspectiveEnabled,
                isFlat = isFlat,
                isForceShowCaption = isForceShowCaption,
                isForceShowIcon = isForceShowIcon,
                isHideCollidedCaptions = isHideCollidedCaptions,
                isHideCollidedMarkers = isHideCollidedMarkers,
                isHideCollidedSymbols = isHideCollidedSymbols,
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
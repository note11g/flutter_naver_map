package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.handler

import com.naver.maps.map.overlay.Marker
import com.naver.maps.map.overlay.Overlay
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NMarker
import io.flutter.plugin.common.MethodChannel

internal interface MarkerHandler : OverlayHandler {
    fun handleMarker(
        marker: Overlay, method: String, arg: Any?, result: MethodChannel.Result,
    ) = (marker as Marker).let { m ->
        when (method) {
            NMarker.hasOpenInfoWindowName -> hasOpenInfoWindow(m, result::success)
            NMarker.openInfoWindowName -> arg!!.asMap().let {
                openInfoWindow(m, it["infoWindow"]!!, it["align"]!!, result::success)
            }
            NMarker.positionName -> setPosition(m, arg!!)
            NMarker.iconName -> setIcon(m, arg)
            NMarker.iconTintColorName -> setIconTintColor(m, arg!!)
            NMarker.alphaName -> setAlpha(m, arg!!)
            NMarker.angleName -> setAngle(m, arg!!)
            NMarker.anchorName -> setAnchor(m, arg!!)
            NMarker.sizeName -> setSize(m, arg!!)
            NMarker.captionName -> setCaption(m, arg!!)
            NMarker.subCaptionName -> setSubCaption(m, arg!!)
            NMarker.captionAlignsName -> setCaptionAligns(m, arg!!)
            NMarker.captionOffsetName -> setCaptionOffset(m, arg!!)
            NMarker.isCaptionPerspectiveEnabledName -> setIsCaptionPerspectiveEnabled(m, arg!!)
            NMarker.isIconPerspectiveEnabledName -> setIsIconPerspectiveEnabled(m, arg!!)
            NMarker.isFlatName -> setIsFlat(m, arg!!)
            NMarker.isForceShowCaptionName -> setIsForceShowCaption(m, arg!!)
            NMarker.isForceShowIconName -> setIsForceShowIcon(m, arg!!)
            NMarker.isHideCollidedCaptionsName -> setIsHideCollidedCaptions(m, arg!!)
            NMarker.isHideCollidedMarkersName -> setIsHideCollidedMarkers(m, arg!!)
            NMarker.isHideCollidedSymbolsName -> setIsHideCollidedSymbols(m, arg!!)
            else -> result.notImplemented()
        }
    }

    fun hasOpenInfoWindow(marker: Marker, success: (hasOpenInfoWindow: Boolean) -> Unit)

    fun openInfoWindow(marker: Marker, rawInfoWindow: Any, rawAlign: Any, success: (Any?) -> Unit)

    fun setPosition(marker: Marker, rawPosition: Any)

    fun setIcon(marker: Marker, rawIcon: Any?)

    fun setIconTintColor(marker: Marker, rawIconTintColor: Any)

    fun setAlpha(marker: Marker, rawAlpha: Any)

    fun setAngle(marker: Marker, rawAngle: Any)

    fun setAnchor(marker: Marker, rawNPoint: Any)

    fun setSize(marker: Marker, rawNPoint: Any)

    fun setCaption(marker: Marker, rawCaption: Any)

    fun setSubCaption(marker: Marker, rawSubCaption: Any)

    fun setCaptionAligns(marker: Marker, rawCaptionAligns: Any)

    fun setCaptionOffset(marker: Marker, rawDpOffset: Any)

    fun setIsCaptionPerspectiveEnabled(marker: Marker, rawCaptionPerspectiveEnabled: Any)

    fun setIsIconPerspectiveEnabled(marker: Marker, rawIconPerspectiveEnabled: Any)

    fun setIsFlat(marker: Marker, rawFlat: Any)

    fun setIsForceShowCaption(marker: Marker, rawForceShowCaption: Any)

    fun setIsForceShowIcon(marker: Marker, rawForceShowIcon: Any)

    fun setIsHideCollidedCaptions(marker: Marker, rawHideCollidedCaptions: Any)

    fun setIsHideCollidedMarkers(marker: Marker, rawHideCollidedMarkers: Any)

    fun setIsHideCollidedSymbols(marker: Marker, rawHideCollidedSymbols: Any)
}
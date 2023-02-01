package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.handler

import com.naver.maps.map.overlay.Marker
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.model.overlay.overlay.NMarker
import io.flutter.plugin.common.MethodChannel

internal interface MarkerHandler : OverlayHandler {
    fun handleMarker(
        marker: Marker, method: String, arg: Any?, result: MethodChannel.Result,
    ) = when (method) {
        NMarker.hasOpenInfoWindowName -> hasOpenInfoWindow(marker, result::success)
        NMarker.openInfoWindowName -> arg!!.asMap().let {
            openInfoWindow(marker, it["infoWindow"]!!, it["align"]!!, result::success)
        }
        NMarker.positionName -> setPosition(marker, arg!!)
        NMarker.iconName -> setIcon(marker, arg!!)
        NMarker.iconTintColorName -> setIconTintColor(marker, arg!!)
        NMarker.alphaName -> setAlpha(marker, arg!!)
        NMarker.angleName -> setAngle(marker, arg!!)
        NMarker.anchorName -> setAnchor(marker, arg!!)
        NMarker.sizeName -> setSize(marker, arg!!)
        NMarker.captionName -> setCaption(marker, arg!!)
        NMarker.subCaptionName -> setSubCaption(marker, arg!!)
        NMarker.captionAlignsName -> setCaptionAligns(marker, arg!!)
        NMarker.captionOffsetName -> setCaptionOffset(marker, arg!!)
        NMarker.isCaptionPerspectiveEnabledName -> setIsCaptionPerspectiveEnabled(marker, arg!!)
        NMarker.isIconPerspectiveEnabledName -> setIsIconPerspectiveEnabled(marker, arg!!)
        NMarker.isFlatName -> setIsFlat(marker, arg!!)
        NMarker.isForceShowCaptionName -> setIsForceShowCaption(marker, arg!!)
        NMarker.isForceShowIconName -> setIsForceShowIcon(marker, arg!!)
        NMarker.isHideCollidedCaptionsName -> setIsHideCollidedCaptions(marker, arg!!)
        NMarker.isHideCollidedMarkersName -> setIsHideCollidedMarkers(marker, arg!!)
        NMarker.isHideCollidedSymbolsName -> setIsHideCollidedSymbols(marker, arg!!)
        else -> result.notImplemented()
    }

    fun hasOpenInfoWindow(marker: Marker, success: (hasOpenInfoWindow: Boolean) -> Unit)

    fun openInfoWindow(marker: Marker, rawInfoWindow: Any, rawAlign: Any, success: (Any?) -> Unit)

    fun setPosition(marker: Marker, rawPosition: Any)

    fun setIcon(marker: Marker, rawIcon: Any)

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
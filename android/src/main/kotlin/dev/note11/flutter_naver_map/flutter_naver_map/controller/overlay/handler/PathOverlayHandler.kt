package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.handler

import com.naver.maps.map.overlay.PathOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler.Companion.getterName
import dev.note11.flutter_naver_map.flutter_naver_map.model.overlay.overlay.NPathOverlay
import io.flutter.plugin.common.MethodChannel

internal interface PathOverlayHandler : OverlayHandler {
    fun handlePathOverlay(
        pathOverlay: PathOverlay, method: String, arg: Any?, result: MethodChannel.Result,
    ) = when (method) {
        NPathOverlay.coordsName -> setCoords(pathOverlay, arg!!)
        NPathOverlay.widthName -> setWidth(pathOverlay, arg!!)
        NPathOverlay.colorName -> setColor(pathOverlay, arg!!)
        NPathOverlay.outlineWidthName -> setOutlineWidth(pathOverlay, arg!!)
        NPathOverlay.outlineColorName -> setOutlineColor(pathOverlay, arg!!)
        NPathOverlay.passedColorName -> setPassedColor(pathOverlay, arg!!)
        NPathOverlay.passedOutlineColorName -> setPassedOutlineColor(pathOverlay, arg!!)
        NPathOverlay.progressName -> setProgress(pathOverlay, arg!!)
        NPathOverlay.patternImageName -> setPatternImage(pathOverlay, arg!!)
        NPathOverlay.patternIntervalName -> setPatternInterval(pathOverlay, arg!!)
        NPathOverlay.isHideCollidedCaptionsName -> setIsHideCollidedCaptions(pathOverlay, arg!!)
        NPathOverlay.isHideCollidedMarkersName -> setIsHideCollidedMarkers(pathOverlay, arg!!)
        NPathOverlay.isHideCollidedSymbolsName -> setIsHideCollidedSymbols(pathOverlay, arg!!)
        getterName(NPathOverlay.boundsName) -> getBounds(pathOverlay, result::success)
        else -> result.notImplemented()
    }

    fun setCoords(pathOverlay: PathOverlay, rawCoords: Any)

    fun setWidth(pathOverlay: PathOverlay, rawWidthDp: Any)

    fun setColor(pathOverlay: PathOverlay, rawColor: Any)

    fun setOutlineWidth(pathOverlay: PathOverlay, rawWidthDp: Any)

    fun setOutlineColor(pathOverlay: PathOverlay, rawColor: Any)

    fun setPassedColor(pathOverlay: PathOverlay, rawColor: Any)

    fun setPassedOutlineColor(pathOverlay: PathOverlay, rawColor: Any)

    fun setProgress(pathOverlay: PathOverlay, rawProgress: Any)

    fun setPatternImage(pathOverlay: PathOverlay, rawNOverlayImage: Any)

    fun setPatternInterval(pathOverlay: PathOverlay, rawInterval: Any)

    fun setIsHideCollidedCaptions(pathOverlay: PathOverlay, rawFlag: Any)

    fun setIsHideCollidedMarkers(pathOverlay: PathOverlay, rawFlag: Any)

    fun setIsHideCollidedSymbols(pathOverlay: PathOverlay, rawFlag: Any)

    fun getBounds(pathOverlay: PathOverlay, success: (bounds: Map<String, Any>) -> Unit)
}
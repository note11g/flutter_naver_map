package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.handler

import com.naver.maps.map.overlay.Overlay
import com.naver.maps.map.overlay.PathOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler.Companion.getterName
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NPathOverlay
import io.flutter.plugin.common.MethodChannel

internal interface PathOverlayHandler : OverlayHandler {
    fun handlePathOverlay(
        pathOverlay: Overlay, method: String, arg: Any?, result: MethodChannel.Result,
    ) = (pathOverlay as PathOverlay).let { p ->
        when (method) {
            NPathOverlay.coordsName -> setCoords(p, arg!!)
            NPathOverlay.widthName -> setWidth(p, arg!!)
            NPathOverlay.colorName -> setColor(p, arg!!)
            NPathOverlay.outlineWidthName -> setOutlineWidth(p, arg!!)
            NPathOverlay.outlineColorName -> setOutlineColor(p, arg!!)
            NPathOverlay.passedColorName -> setPassedColor(p, arg!!)
            NPathOverlay.passedOutlineColorName -> setPassedOutlineColor(p, arg!!)
            NPathOverlay.progressName -> setProgress(p, arg!!)
            NPathOverlay.patternImageName -> setPatternImage(p, arg!!)
            NPathOverlay.patternIntervalName -> setPatternInterval(p, arg!!)
            NPathOverlay.isHideCollidedCaptionsName -> setIsHideCollidedCaptions(p, arg!!)
            NPathOverlay.isHideCollidedMarkersName -> setIsHideCollidedMarkers(p, arg!!)
            NPathOverlay.isHideCollidedSymbolsName -> setIsHideCollidedSymbols(p, arg!!)
            getterName(NPathOverlay.boundsName) -> getBounds(p, result::success)
            else -> result.notImplemented()
        }
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
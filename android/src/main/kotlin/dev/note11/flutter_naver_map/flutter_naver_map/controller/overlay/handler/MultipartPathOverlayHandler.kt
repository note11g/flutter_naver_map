package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.handler

import com.naver.maps.map.overlay.MultipartPathOverlay
import com.naver.maps.map.overlay.Overlay
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler.Companion.getterName
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NMultipartPathOverlay
import io.flutter.plugin.common.MethodChannel

internal interface MultipartPathOverlayHandler : OverlayHandler {
    fun handleMultipartPathOverlay(
        multipartPathOverlay: Overlay,
        method: String,
        arg: Any?,
        result: MethodChannel.Result,
    ) = (multipartPathOverlay as MultipartPathOverlay).let { m ->
        when (method) {
            NMultipartPathOverlay.pathsName -> setPaths(m, arg!!)
            NMultipartPathOverlay.widthName -> setWidth(m, arg!!)
            NMultipartPathOverlay.outlineWidthName -> setOutlineWidth(m, arg!!)
            NMultipartPathOverlay.patternImageName -> setPatternImage(m, arg!!)
            NMultipartPathOverlay.patternIntervalName -> setPatternInterval(m, arg!!)
            NMultipartPathOverlay.progressName -> setProgress(m, arg!!)
            NMultipartPathOverlay.isHideCollidedCaptionsName -> setIsHideCollidedCaptions(m, arg!!)
            NMultipartPathOverlay.isHideCollidedMarkersName -> setIsHideCollidedMarkers(m, arg!!)
            NMultipartPathOverlay.isHideCollidedSymbolsName -> setIsHideCollidedSymbols(m, arg!!)
            getterName(NMultipartPathOverlay.boundsName) -> getBounds(m, result::success)
            else -> result.notImplemented()
        }
    }

    fun setPaths(multipartPathOverlay: MultipartPathOverlay, rawPaths: Any)

    fun setWidth(multipartPathOverlay: MultipartPathOverlay, rawWidthDp: Any)

    fun setOutlineWidth(multipartPathOverlay: MultipartPathOverlay, rawWidthDp: Any)

    fun setPatternImage(multipartPathOverlay: MultipartPathOverlay, rawNOverlayImage: Any)

    fun setPatternInterval(multipartPathOverlay: MultipartPathOverlay, rawInterval: Any)

    fun setProgress(multipartPathOverlay: MultipartPathOverlay, rawProgress: Any)

    fun setIsHideCollidedCaptions(multipartPathOverlay: MultipartPathOverlay, rawFlag: Any)

    fun setIsHideCollidedMarkers(multipartPathOverlay: MultipartPathOverlay, rawFlag: Any)

    fun setIsHideCollidedSymbols(multipartPathOverlay: MultipartPathOverlay, rawFlag: Any)

    fun getBounds(
        multipartPathOverlay: MultipartPathOverlay,
        success: (bounds: Map<String, Any>) -> Unit,
    )
}
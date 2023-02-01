package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.handler

import com.naver.maps.map.overlay.MultipartPathOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler.Companion.getterName
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NMultipartPathOverlay
import io.flutter.plugin.common.MethodChannel

internal interface MultipartPathOverlayHandler : OverlayHandler {
    fun handleMultipartPathOverlay(
        multipartPathOverlay: MultipartPathOverlay,
        method: String,
        arg: Any?,
        result: MethodChannel.Result,
    ) = when (method) {
        NMultipartPathOverlay.pathsName -> setPaths(multipartPathOverlay, arg!!)
        NMultipartPathOverlay.widthName -> setWidth(multipartPathOverlay, arg!!)
        NMultipartPathOverlay.outlineWidthName -> setOutlineWidth(multipartPathOverlay, arg!!)
        NMultipartPathOverlay.patternImageName -> setPatternImage(multipartPathOverlay, arg!!)
        NMultipartPathOverlay.patternIntervalName -> setPatternInterval(multipartPathOverlay, arg!!)
        NMultipartPathOverlay.progressName -> setProgress(multipartPathOverlay, arg!!)
        NMultipartPathOverlay.isHideCollidedCaptionsName -> setIsHideCollidedCaptions(
            multipartPathOverlay,
            arg!!
        )
        NMultipartPathOverlay.isHideCollidedMarkersName -> setIsHideCollidedMarkers(
            multipartPathOverlay,
            arg!!
        )
        NMultipartPathOverlay.isHideCollidedSymbolsName -> setIsHideCollidedSymbols(
            multipartPathOverlay,
            arg!!
        )
        getterName(NMultipartPathOverlay.boundsName) -> getBounds(
            multipartPathOverlay,
            result::success
        )
        else -> result.notImplemented()
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
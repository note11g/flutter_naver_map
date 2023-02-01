package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.handler

import com.naver.maps.map.overlay.GroundOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NGroundOverlay
import io.flutter.plugin.common.MethodChannel

internal interface GroundOverlayHandler : OverlayHandler {
    fun handleGroundOverlay(
        groundOverlay: GroundOverlay, method: String, arg: Any?, result: MethodChannel.Result,
    ) = when (method) {
        NGroundOverlay.boundsName -> setBounds(groundOverlay, arg!!)
        NGroundOverlay.imageName -> setImage(groundOverlay, arg!!)
        NGroundOverlay.alphaName -> setAlpha(groundOverlay, arg!!)
        else -> result.notImplemented()
    }

    fun setBounds(groundOverlay: GroundOverlay, rawBounds: Any)

    fun setImage(groundOverlay: GroundOverlay, rawNOverlayImage: Any)

    fun setAlpha(groundOverlay: GroundOverlay, rawAlpha: Any)
}
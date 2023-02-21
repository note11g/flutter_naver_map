package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.handler

import com.naver.maps.map.overlay.GroundOverlay
import com.naver.maps.map.overlay.Overlay
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NGroundOverlay
import io.flutter.plugin.common.MethodChannel

internal interface GroundOverlayHandler : OverlayHandler {
    fun handleGroundOverlay(
        groundOverlay: Overlay, method: String, arg: Any?, result: MethodChannel.Result,
    ) = (groundOverlay as GroundOverlay).let { g ->
        when (method) {
            NGroundOverlay.boundsName -> setBounds(g, arg!!)
            NGroundOverlay.imageName -> setImage(g, arg!!)
            NGroundOverlay.alphaName -> setAlpha(g, arg!!)
            else -> result.notImplemented()
        }
    }

    fun setBounds(groundOverlay: GroundOverlay, rawBounds: Any)

    fun setImage(groundOverlay: GroundOverlay, rawNOverlayImage: Any)

    fun setAlpha(groundOverlay: GroundOverlay, rawAlpha: Any)
}
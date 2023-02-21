package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.handler

import com.naver.maps.map.overlay.InfoWindow
import com.naver.maps.map.overlay.Overlay
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NInfoWindow
import io.flutter.plugin.common.MethodChannel

internal interface InfoWindowHandler : OverlayHandler {
    fun handleInfoWindow(
        infoWindow: Overlay, method: String, arg: Any?, result: MethodChannel.Result,
    ) = (infoWindow as InfoWindow).let { i ->
        when (method) {
            NInfoWindow.textName -> setText(i, arg!!)
            NInfoWindow.anchorName -> setAnchor(i, arg!!)
            NInfoWindow.alphaName -> setAlpha(i, arg!!)
            NInfoWindow.positionName -> setPosition(i, arg!!)
            NInfoWindow.offsetXName -> setOffsetX(i, arg!!)
            NInfoWindow.offsetYName -> setOffsetY(i, arg!!)
            NInfoWindow.closeName -> close(i)
            else -> result.notImplemented()
        }
    }

    fun setText(infoWindow: InfoWindow, rawText: Any)

    fun setAnchor(infoWindow: InfoWindow, rawNPoint: Any)

    fun setAlpha(infoWindow: InfoWindow, rawAlpha: Any)

    fun setPosition(infoWindow: InfoWindow, rawPosition: Any)

    fun setOffsetX(infoWindow: InfoWindow, rawOffsetXDp: Any)

    fun setOffsetY(infoWindow: InfoWindow, rawOffsetYDp: Any)

    fun close(infoWindow: InfoWindow)
}
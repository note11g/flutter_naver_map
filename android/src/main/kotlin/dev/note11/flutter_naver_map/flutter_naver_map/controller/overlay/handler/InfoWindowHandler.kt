package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.handler

import com.naver.maps.map.overlay.InfoWindow
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler
import dev.note11.flutter_naver_map.flutter_naver_map.model.overlay.overlay.NInfoWindow
import io.flutter.plugin.common.MethodChannel

internal interface InfoWindowHandler : OverlayHandler {
    fun handleInfoWindow(
        infoWindow: InfoWindow, method: String, arg: Any?, result: MethodChannel.Result,
    ) = when (method) {
        NInfoWindow.textName -> setText(infoWindow, arg!!)
        NInfoWindow.anchorName -> setAnchor(infoWindow, arg!!)
        NInfoWindow.alphaName -> setAlpha(infoWindow, arg!!)
        NInfoWindow.positionName -> setPosition(infoWindow, arg!!)
        NInfoWindow.offsetXName -> setOffsetX(infoWindow, arg!!)
        NInfoWindow.offsetYName -> setOffsetY(infoWindow, arg!!)
        NInfoWindow.closeName -> close(infoWindow)
        else -> result.notImplemented()
    }

    fun setText(infoWindow: InfoWindow, rawText: Any)

    fun setAnchor(infoWindow: InfoWindow, rawNPoint: Any)

    fun setAlpha(infoWindow: InfoWindow, rawAlpha: Any)

    fun setPosition(infoWindow: InfoWindow, rawPosition: Any)

    fun setOffsetX(infoWindow: InfoWindow, rawOffsetXDp: Any)

    fun setOffsetY(infoWindow: InfoWindow, rawOffsetYDp: Any)

    fun close(infoWindow: InfoWindow)
}
package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay

import dev.note11.flutter_naver_map.flutter_naver_map.model.map.info.NOverlayInfo

internal interface OverlaySender {
    fun onOverlayTapped(info: NOverlayInfo)
}
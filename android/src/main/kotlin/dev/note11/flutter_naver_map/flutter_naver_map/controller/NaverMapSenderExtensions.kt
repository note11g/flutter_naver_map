package dev.note11.flutter_naver_map.flutter_naver_map.controller

import com.naver.maps.map.NaverMap.OnCustomStyleLoadCallback

internal fun NaverMapControlSender.getCustomStyleCallback(): OnCustomStyleLoadCallback =
    object : OnCustomStyleLoadCallback {
        override fun onCustomStyleLoaded() = this@getCustomStyleCallback.onCustomStyleLoaded()

        override fun onCustomStyleLoadFailed(exception: Exception) =
            this@getCustomStyleCallback.onCustomStyleLoadFailed(exception)
    }
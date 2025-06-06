package dev.note11.flutter_naver_map.flutter_naver_map.util.location

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class NDefaultMyLocationTracker(messenger: BinaryMessenger) : NDefaultMyLocationTrackerHandler {
    private val methodChannel = MethodChannel(messenger, "NDefaultMyLocationTracker")
    private val locationEventChannel =
        EventChannel(messenger, "NDefaultMyLocationTracker.locationStream")
    private val headingEventChannel =
        EventChannel(messenger, "NDefaultMyLocationTracker.headingStream")
    private val locationStreamHandler = NDefaultMyLocationTrackerLocationStreamHandler()
    private val headingStreamHandler = NDefaultMyLocationTrackerHeadingStreamHandler()

    init {
        methodChannel.setMethodCallHandler(::handle)
        locationEventChannel.setStreamHandler(locationStreamHandler)
        headingEventChannel.setStreamHandler(headingStreamHandler)
    }

    fun dispose() {
        methodChannel.setMethodCallHandler(null)
        locationEventChannel.setStreamHandler(null)
        headingEventChannel.setStreamHandler(null)
    }

    override fun requestLocationPermission(result: MethodChannel.Result) {
        TODO("Not yet implemented")
    }

    override fun getCurrentPositionOnce(result: MethodChannel.Result) {
        TODO("Not yet implemented")
    }
}


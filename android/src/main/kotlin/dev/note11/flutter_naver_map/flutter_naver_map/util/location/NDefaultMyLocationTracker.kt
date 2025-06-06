package dev.note11.flutter_naver_map.flutter_naver_map.util.location

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.naver.maps.geometry.LatLng
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.toMessageable
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class NDefaultMyLocationTracker(messenger: BinaryMessenger, val activity: Activity) :
    NDefaultMyLocationTrackerHandler {
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


package dev.note11.flutter_naver_map.flutter_naver_map.util.location

import android.Manifest
import android.location.Location
import android.os.Looper
import androidx.annotation.RequiresPermission
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationListener
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.Priority
import com.naver.maps.geometry.LatLng
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.toMessageable
import io.flutter.plugin.common.EventChannel

class NDefaultMyLocationTrackerLocationStreamHandler(
    private val fusedLocationProviderClientFactory: () -> FusedLocationProviderClient,
) : EventChannel.StreamHandler, LocationListener {
    private val fusedLocationProviderClient: FusedLocationProviderClient get() = fusedLocationProviderClientFactory()
    private var events: EventChannel.EventSink? = null

    @RequiresPermission(allOf = [Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION])
    override fun onListen(
        arguments: Any?, events: EventChannel.EventSink?
    ) {
        val locationRequest = LocationRequest.Builder(1000).apply {
            setPriority(Priority.PRIORITY_HIGH_ACCURACY)
        }.build()
        if (events == null) {
            onCancel(null)
            return
        }

        events.let { this.events = it }

        fusedLocationProviderClient.requestLocationUpdates(
            locationRequest, this, Looper.getMainLooper()
        )
    }

    override fun onLocationChanged(location: Location) {
        val latLng = LatLng(location.latitude, location.longitude)
        events?.success(latLng.toMessageable())
    }

    override fun onCancel(arguments: Any?) {
        fusedLocationProviderClient.removeLocationUpdates(this)
        fusedLocationProviderClient.flushLocations()
        events?.endOfStream()
        events = null
    }
}
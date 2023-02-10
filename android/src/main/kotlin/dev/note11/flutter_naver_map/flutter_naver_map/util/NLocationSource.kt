package dev.note11.flutter_naver_map.flutter_naver_map.util

import android.Manifest.permission.ACCESS_COARSE_LOCATION
import android.Manifest.permission.ACCESS_FINE_LOCATION
import android.annotation.SuppressLint
import android.app.Activity
import android.content.pm.PackageManager
import android.os.Looper
import androidx.core.content.ContextCompat
import com.google.android.gms.location.*
import com.naver.maps.map.LocationSource
import com.naver.maps.map.LocationSource.OnLocationChangedListener

class NLocationSource(private val activity: Activity) : LocationSource {
    private val fusedLocationClient: FusedLocationProviderClient =
        LocationServices.getFusedLocationProviderClient(activity)
    private val requiredPermissions = listOf(ACCESS_FINE_LOCATION, ACCESS_COARSE_LOCATION)
    private var locationListener: LocationListener? = null

    override fun activate(listener: OnLocationChangedListener) {
        checkLocationPermission(onGranted = { startLocationUpdates(listener) })
    }

    override fun deactivate() {
        stopLocationUpdates()
    }

    private fun checkLocationPermission(onGranted: () -> Unit) {
        if (hasLocationPermission()) onGranted()
    }

    @SuppressLint("MissingPermission")
    private fun startLocationUpdates(listener: OnLocationChangedListener) {
        val locationRequest = LocationRequest.Builder(1000).apply {
            setPriority(Priority.PRIORITY_HIGH_ACCURACY)
        }.build()

        locationListener = LocationListener(listener::onLocationChanged)

        fusedLocationClient.requestLocationUpdates(
            locationRequest, locationListener!!, Looper.getMainLooper()
        )
    }

    private fun stopLocationUpdates() {
        if (locationListener != null) {
            fusedLocationClient.removeLocationUpdates(locationListener!!)
            locationListener = null
        }
    }

    private fun hasLocationPermission(): Boolean {
        val grantedPermissions = requiredPermissions.map { permission ->
            ContextCompat.checkSelfPermission(activity, permission)
        }.filter {
            it == PackageManager.PERMISSION_GRANTED
        }
        return grantedPermissions.size == requiredPermissions.size
    }
}
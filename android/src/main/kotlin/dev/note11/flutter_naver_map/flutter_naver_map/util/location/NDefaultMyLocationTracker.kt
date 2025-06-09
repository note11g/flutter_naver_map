package dev.note11.flutter_naver_map.flutter_naver_map.util.location

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.hardware.SensorManager
import androidx.annotation.RequiresPermission
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority
import com.google.android.gms.tasks.CancellationTokenSource
import com.naver.maps.geometry.LatLng
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.toMessageable
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class NDefaultMyLocationTracker(messenger: BinaryMessenger, val activity: Activity) :
    NDefaultMyLocationTrackerHandler, PluginRegistry.RequestPermissionsResultListener {
    private val methodChannel = MethodChannel(messenger, "NDefaultMyLocationTracker")
    private val locationEventChannel =
        EventChannel(messenger, "NDefaultMyLocationTracker.locationStream")
    private val headingEventChannel =
        EventChannel(messenger, "NDefaultMyLocationTracker.headingStream")

    private val locationStreamHandler =
        NDefaultMyLocationTrackerLocationStreamHandler(
            fusedLocationProviderClientFactory = { fusedLocationProviderClient },
            onLocationChangedCallback = { headingStreamHandler.onLocationChanged(it) },
        )
    private val headingStreamHandler =
        NDefaultMyLocationTrackerHeadingStreamHandler(sensorManagerFactory = {
            activity.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        })

    private val fusedLocationProviderClient: FusedLocationProviderClient by lazy {
        LocationServices.getFusedLocationProviderClient(activity)
    }
    private var cancellationTokenSources: MutableMap<Int, CancellationTokenSource> = mutableMapOf()
    private var permissionHandlerCallback: ((result: NDefaultMyLocationTrackerPermissionStatus) -> Unit)? =
        null

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
        val hasPermission =
            ContextCompat.checkSelfPermission(
                activity,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED

        if (hasPermission) {
            result.success(NDefaultMyLocationTrackerPermissionStatus.Granted.toMessageable())
            return
        }

        permissionHandlerCallback = { permissionResult ->
            result.success(permissionResult.toMessageable())
        }

        ActivityCompat.requestPermissions(
            activity,
            arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
            LOCATION_PERMISSION_REQUEST_CODE
        )
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String?>,
        grantResults: IntArray
    ): Boolean {
        if (requestCode == LOCATION_PERMISSION_REQUEST_CODE) {
            val callback = permissionHandlerCallback ?: return false
            val status: NDefaultMyLocationTrackerPermissionStatus =
                when (grantResults.firstOrNull()) {
                    PackageManager.PERMISSION_GRANTED -> NDefaultMyLocationTrackerPermissionStatus.Granted
                    PackageManager.PERMISSION_DENIED -> {
                        if (ActivityCompat.shouldShowRequestPermissionRationale(
                                activity,
                                Manifest.permission.ACCESS_FINE_LOCATION
                            )
                        ) {
                            NDefaultMyLocationTrackerPermissionStatus.Denied
                        } else {
                            NDefaultMyLocationTrackerPermissionStatus.DeniedForever
                        }
                    }

                    else -> NDefaultMyLocationTrackerPermissionStatus.Denied
                }
            callback.invoke(status)
            return true
        }
        return false
    }

    @RequiresPermission(allOf = [Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION])
    override fun getCurrentPositionOnce(result: MethodChannel.Result) {
        val cancellationTokenSource = CancellationTokenSource()
        val tokenHash = cancellationTokenSource.token.hashCode()
        cancellationTokenSources[tokenHash] = cancellationTokenSource

        fusedLocationProviderClient.getCurrentLocation(
            Priority.PRIORITY_HIGH_ACCURACY, cancellationTokenSource.token
        )
            .addOnSuccessListener { location ->
                if (location != null) {
                    location.run { result.success(LatLng(latitude, longitude).toMessageable()) }
                } else {
                    result.error("LocationError", "Location is null", null)
                }
                cancellationTokenSources.remove(tokenHash)
            }.addOnFailureListener {
                result.error("LocationError", it.message, null)
                cancellationTokenSources.remove(tokenHash)
            }.addOnCanceledListener {
                cancellationTokenSources.remove(tokenHash)
            }
    }

    override fun cancelAllWaitingGetCurrentPositionOnceTask() {
        cancellationTokenSources.forEach {
            it.value.cancel()
        }
    }


    companion object {
        const val LOCATION_PERMISSION_REQUEST_CODE = 706
    }
}


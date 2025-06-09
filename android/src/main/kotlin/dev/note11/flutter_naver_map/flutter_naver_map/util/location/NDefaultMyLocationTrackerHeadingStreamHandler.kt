package dev.note11.flutter_naver_map.flutter_naver_map.util.location

import android.hardware.GeomagneticField
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.location.Location
import android.util.Log
import com.google.android.gms.location.LocationListener
import io.flutter.plugin.common.EventChannel

class NDefaultMyLocationTrackerHeadingStreamHandler(
    sensorManagerFactory: () -> SensorManager,
) : EventChannel.StreamHandler, SensorEventListener, LocationListener {
    private val sensorManager: SensorManager by lazy(sensorManagerFactory)
    private var events: EventChannel.EventSink? = null

    private val rotationVector: Sensor? by lazy {
        sensorManager.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR)
    }
    private val rotationM = FloatArray(9)
    private val orientation = FloatArray(3)

    private var geomagneticField: GeomagneticField? = null

    override fun onListen(
        arguments: Any?, events: EventChannel.EventSink?
    ) {
        if (events == null) {
            onCancel(null)
            return
        }

        this.events = events

        if (rotationVector != null) {
            sensorManager.registerListener(this, rotationVector, SensorManager.SENSOR_DELAY_UI)
        } else {
            Log.e(
                "NDefaultMyLocationTrackerHeadingStreamHandler",
                "[SENSOR_UNAVAILABLE] Rotation vector sensor not available."
            )
        }
    }

    override fun onCancel(arguments: Any?) {
        if (rotationVector != null && events != null) {
            sensorManager.unregisterListener(this, rotationVector)
        }
        events?.endOfStream()
        events = null
    }

    override fun onSensorChanged(event: SensorEvent?) {
        if (event?.sensor?.type != Sensor.TYPE_ROTATION_VECTOR || events == null) return

        SensorManager.getRotationMatrixFromVector(rotationM, event.values)
        SensorManager.getOrientation(rotationM, orientation)

        var magneticHeading = Math.toDegrees(orientation[0].toDouble()).toFloat()
        if (magneticHeading < 0) magneticHeading += 360f

        val declination = geomagneticField?.declination ?: 0f
        val trueHeading = (magneticHeading + declination + 360f) % 360f

        events?.success(trueHeading.toDouble())
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) = Unit

    override fun onLocationChanged(location: Location) {
        geomagneticField = GeomagneticField(
            location.latitude.toFloat(),
            location.longitude.toFloat(),
            location.altitude.toFloat(),
            System.currentTimeMillis()
        )
        if (rotationVector == null) { // sensor unavailable case
            events?.success(location.bearing.toDouble())
        }
    }
}
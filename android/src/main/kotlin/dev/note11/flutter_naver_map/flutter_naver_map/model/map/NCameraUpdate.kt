package dev.note11.flutter_naver_map.flutter_naver_map.model.map

import com.naver.maps.geometry.LatLng
import com.naver.maps.geometry.LatLngBounds
import com.naver.maps.map.CameraAnimation
import com.naver.maps.map.CameraUpdate
import com.naver.maps.map.CameraUpdateParams
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asInt
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asLong
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asCameraAnimation
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLatLng
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLatLngBounds
import dev.note11.flutter_naver_map.flutter_naver_map.model.base.NEdgeInsets
import dev.note11.flutter_naver_map.flutter_naver_map.model.base.NPoint

internal data class NCameraUpdate(
    val signature: String,
    val target: LatLng? = null,
    val zoom: Double? = null,
    val zoomBy: Double? = null,
    val tilt: Double? = null,
    val tiltBy: Double? = null,
    val bearing: Double? = null,
    val bearingBy: Double? = null,
    val bounds: LatLngBounds? = null,
    val boundsPadding: NEdgeInsets? = null,
    val pivot: NPoint? = null, // change to NPoint
    val animation: CameraAnimation,
    val duration: Long,
    val reason: Int? = null,
) {

    fun toCameraUpdate(): CameraUpdate {
        val cameraUpdate = when (signature) {
            "withParams" -> CameraUpdate.withParams(CameraUpdateParams().apply {
                if (target != null) scrollTo(target)
                if (zoom != null) zoomTo(zoom)
                if (zoomBy != null) zoomBy(zoomBy)
                if (tilt != null) tiltTo(tilt)
                if (tiltBy != null) tiltBy(tiltBy)
                if (bearing != null) rotateTo(bearing)
                if (bearingBy != null) rotateBy(bearingBy)
            })
            "fitBounds" -> boundsPadding?.run {
                CameraUpdate.fitBounds(bounds!!, leftPx, topPx, rightPx, bottomPx)
            } ?: CameraUpdate.fitBounds(bounds!!)
            else -> throw IllegalArgumentException("Unknown signature: $signature")
        }

        return cameraUpdate.animate(animation, duration)
            .run { pivot?.let { pivot(it.toPointF()) } ?: this }
            .run { reason?.let { reason(it) } ?: this }
    }

    companion object {
        fun fromMessageable(args: Any): NCameraUpdate = args.asMap().let { map ->
            return NCameraUpdate(
                signature = map["sign"].toString(),
                target = map["target"]?.asLatLng(),
                zoom = map["zoom"]?.asDouble(),
                zoomBy = map["zoomBy"]?.asDouble(),
                tilt = map["tilt"]?.asDouble(),
                tiltBy = map["tiltBy"]?.asDouble(),
                bearing = map["bearing"]?.asDouble(),
                bearingBy = map["bearingBy"]?.asDouble(),
                bounds = map["bounds"]?.asLatLngBounds(),
                boundsPadding = map["boundsPadding"]?.let(NEdgeInsets::fromMessageable),
                pivot = map["pivot"]?.let(NPoint::fromMessageable),
                animation = map["animation"]!!.asCameraAnimation(),
                duration = map["duration"]!!.asLong(),
                reason = map["reason"]?.asInt()
            )
        }
    }
}

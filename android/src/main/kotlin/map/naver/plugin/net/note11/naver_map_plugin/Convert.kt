package map.naver.plugin.net.note11.naver_map_plugin

import com.naver.maps.geometry.LatLng
import android.graphics.PointF
import com.naver.maps.geometry.LatLngBounds
import android.graphics.Color
import com.naver.maps.map.CameraPosition
import com.naver.maps.map.CameraUpdate
import com.naver.maps.map.overlay.OverlayImage
import io.flutter.view.FlutterMain
import java.util.*
import kotlin.math.roundToInt

object Convert {
    fun carveMapOptions(sink: NaverMapOptionSink, options: Map<String, Any>) {
        if (options.containsKey("mapType")) sink.setMapType((options["mapType"] as Int))
        if (options.containsKey("liteModeEnable")) sink.setLiteModeEnable((options["liteModeEnable"] as Boolean))
        if (options.containsKey("nightModeEnable")) sink.setNightModeEnable((options["nightModeEnable"] as Boolean))
        if (options.containsKey("indoorEnable")) sink.setIndoorEnable((options["indoorEnable"] as Boolean))
        if (options.containsKey("buildingHeight")) sink.setBuildingHeight((options["buildingHeight"] as Double))
        if (options.containsKey("symbolScale")) sink.setSymbolScale((options["symbolScale"] as Double))
        if (options.containsKey("symbolPerspectiveRatio")) sink.setSymbolPerspectiveRatio((options["symbolPerspectiveRatio"] as Double))
        if (options.containsKey("activeLayers")) sink.setActiveLayers(options["activeLayers"] as List<Any?>)
        if (options.containsKey("locationButtonEnable")) sink.setLocationButtonEnable((options["locationButtonEnable"] as Boolean))
        if (options.containsKey("scrollGestureEnable")) sink.setScrollGestureEnable((options["scrollGestureEnable"] as Boolean))
        if (options.containsKey("zoomGestureEnable")) sink.setZoomGestureEnable((options["zoomGestureEnable"] as Boolean))
        if (options.containsKey("rotationGestureEnable")) sink.setRotationGestureEnable((options["rotationGestureEnable"] as Boolean))
        if (options.containsKey("tiltGestureEnable")) sink.setTiltGestureEnable((options["tiltGestureEnable"] as Boolean))
        if (options.containsKey("locationButtonEnable")) sink.setLocationButtonEnable((options["locationButtonEnable"] as Boolean))
        if (options.containsKey("locationTrackingMode")) sink.setLocationTrackingMode((options["locationTrackingMode"] as Int))
        if (options.containsKey("contentPadding")) sink.setContentPadding(options["contentPadding"]?.toDoubleList())
        if (options.containsKey("maxZoom")) sink.setMaxZoom((options["maxZoom"] as Double))
        if (options.containsKey("minZoom")) sink.setMinZoom((options["minZoom"] as Double))
    }

    private fun Any.toDoubleList(): List<Double> {
        val list = this as List<Any?>
        val doubleList = list.filterIsInstance<Double>()
        return doubleList.ifEmpty {
            val floatList = list.filterIsInstance<Float>().map { it.toDouble() }
            require(floatList.isNotEmpty())
            floatList
        }
    }

    fun Any.toLatLng(): LatLng {
        val data = toDoubleList()
        return LatLng(data[0], data[1])
    }

    fun Any.toPoint(): PointF {
        val data = toDoubleList()
        return PointF(data[0].toFloat(), data[1].toFloat())
    }

    private fun Any.toLatLngBounds(): LatLngBounds {
        require(this is List<Any?>)
        val data: List<Any> = this.requireNoNulls()
        return LatLngBounds(data[0].toLatLng(), data[1].toLatLng())
    }

    fun Map<String, Any?>.toCameraPosition(): CameraPosition {
        val bearing: Double = this["bearing"] as Double
        val tilt: Double = this["tilt"] as Double
        val zoom: Double = this["zoom"] as Double
        val target = this["target"] as List<Any?>
        assert(target.size == 2) // target size 가 2가 아니면, 선언 실패(assert) 에러
        val lat = target[0] as Double
        val lng = target[1] as Double
        return CameraPosition(LatLng(lat, lng), zoom, tilt, bearing)
    }

    fun Map<String, Any>.toCameraUpdate(density: Float): CameraUpdate {
        require(this.isNotEmpty()) { "Cannot interpret $this as CameraUpdate" } // map 이 비어있다면 error

        // position
        if (this["newCameraPosition"] != null) {
            val position = this["newCameraPosition"] as Map<String, Any?>
            return CameraUpdate.toCameraPosition(position.toCameraPosition())
        }

        // scroll
        if (this["scrollTo"] != null) {
            val latLng: LatLng = this["scrollTo"]!!.toLatLng()
            val zoomTo = this["zoomTo"] as Double
            return if (zoomTo == 0.0) CameraUpdate.scrollTo(latLng)
            else CameraUpdate.scrollAndZoomTo(latLng, zoomTo)
        }

        /* zoom start */
        if (this.containsKey("zoomIn")) return CameraUpdate.zoomIn()
        if (this.containsKey("zoomOut")) return CameraUpdate.zoomOut()

        val zoomBy = this["zoomBy"] as Double?
        if (zoomBy != null && zoomBy != 0.0) return CameraUpdate.zoomBy(zoomBy)
        /* zoom end */

        val fitBounds = this["fitBounds"] as List<Any?>
        val dp = fitBounds[1] as Int
        val px = (dp * density).roundToInt()
        return CameraUpdate.fitBounds(fitBounds[0]!!.toLatLngBounds(), px)
    }

    fun List<Any?>.toCoords(): List<LatLng> {
        val filteredData = this.filterIsInstance<List<Double>>().ifEmpty {
            this.filterIsInstance<List<Float>>().map { it.toDoubleList() }
        }
        return mutableListOf<LatLng>().apply {
            for (point in filteredData) add(LatLng(point[0], point[1]))
        }
    }

    fun cameraPositionToJson(position: CameraPosition?): Any? {
        if (position == null) return null

        val data: MutableMap<String, Any> = HashMap()
        data["bearing"] = position.bearing
        data["target"] = latLngToJson(position.target)
        data["tilt"] = position.tilt
        data["zoom"] = position.zoom
        return data
    }

    fun latLngBoundsToJson(latLngBounds: LatLngBounds): Any = mapOf(
        "southwest" to latLngToJson(latLngBounds.southWest),
        "northeast" to latLngToJson(latLngBounds.northEast)
    )

    fun latLngToJson(latLng: LatLng): Any = listOf(latLng.latitude, latLng.longitude)

    fun toHoles(data: List<Any?>): List<List<LatLng>> {
        val holes = mutableListOf<List<LatLng>>()
        for (ob in data) holes.add((ob as List<Any?>).toCoords())
        return holes
    }

    fun toColorInt(value: Any?): Int =
        if (value is Long || value is Int) Color.parseColor(String.format("#%08x", value)) else 0

    fun toOverlayImage(o: Any?): OverlayImage { // todo : bitmap support
        val assetName = o as String
        val key = FlutterMain.getLookupKeyForAsset(assetName)
        return OverlayImage.fromAsset(key)
    }
}
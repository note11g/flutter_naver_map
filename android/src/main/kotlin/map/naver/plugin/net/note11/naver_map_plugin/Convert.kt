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
    fun carveMapOptions(sink: NaverMapOptionSink, options: Map<String, Any>) = sink.run {
        val keyFunList: Map<String, (Any) -> Unit> = mapOf(
            /* Boolean */
            "liteModeEnable" to { setLiteModeEnable(it as Boolean) },
            "nightModeEnable" to { setNightModeEnable(it as Boolean) },
            "indoorEnable" to { setIndoorEnable(it as Boolean) },
            "locationButtonEnable" to { setLocationButtonEnable(it as Boolean) },
            "scrollGestureEnable" to { setScrollGestureEnable(it as Boolean) },
            "zoomGestureEnable" to { setZoomGestureEnable(it as Boolean) },
            "rotationGestureEnable" to { setRotationGestureEnable(it as Boolean) },
            "tiltGestureEnable" to { setTiltGestureEnable(it as Boolean) },
            "locationButtonEnable" to { setLocationButtonEnable(it as Boolean) },
            /* Int */
            "mapType" to { setMapType(it as Int) },
            "locationTrackingMode" to { setLocationTrackingMode(it as Int) },
            /* Double */
            "buildingHeight" to { setBuildingHeight(it as Double) },
            "symbolScale" to { setSymbolScale(it as Double) },
            "symbolPerspectiveRatio" to { setSymbolPerspectiveRatio(it as Double) },
            "maxZoom" to { setMaxZoom(it as Double) },
            "minZoom" to { setMinZoom(it as Double) },
            /* List */
            "activeLayers" to { setActiveLayers(it.toIntList()) },
            "contentPadding" to { setContentPadding(it.toDoubleList()) }
        )

        keyFunList.forEach { (k, f) -> if (options.containsKey(k)) f.invoke(options[k]!!) }
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

    private fun Any.toIntList(): List<Int> {
        val list = this as List<Any?>
        val intList = list.filterIsInstance<Int>()
        return intList.ifEmpty {
            val longList = list.filterIsInstance<Long>().map { it.toInt() }
            require(longList.isNotEmpty())
            longList
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
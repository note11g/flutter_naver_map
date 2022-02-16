package map.naver.plugin.net.note11.naver_map_plugin

import android.os.Handler
import map.naver.plugin.net.note11.naver_map_plugin.Convert.toLatLng
import map.naver.plugin.net.note11.naver_map_plugin.Convert.toColorInt
import com.naver.maps.map.NaverMap
import com.naver.maps.map.overlay.Overlay
import android.os.Looper
import com.naver.maps.map.overlay.CircleOverlay
import java.util.HashMap
import java.util.concurrent.Executors
import kotlin.math.roundToInt

class NaverCircleController(
    private val naverMap: NaverMap,
    private val listener: Overlay.OnClickListener,
    private val density: Float
) {
    private val idToController = HashMap<String?, CircleController?>()
    private val handler = Handler(Looper.getMainLooper())
    fun add(jsonArray: List<Any?>?) {
        if (jsonArray == null || jsonArray.isEmpty()) return
        val service = Executors.newCachedThreadPool()
        service.execute {
            for (json in jsonArray) {
                val data = json as HashMap<String, Any>
                val circle = CircleController(data)
                circle.setOnClickListener(listener)
                idToController[circle.id] = circle
            }
            handler.post {
                val circles: List<CircleController?> = idToController.values.toList()
                for (circle in circles) {
                    circle?.setMap(naverMap)
                }
            }
        }
        service.shutdown()
    }

    fun modify(jsonArray: List<Any?>?) {
        if (jsonArray == null || jsonArray.isEmpty()) return
        for (json in jsonArray) {
            val data = json as HashMap<String, Any>
            val id = data["overlayId"] as String?
            idToController[id]!!.interpret(data)
        }
    }

    fun remove(jsonArray: List<Any?>?) {
        if (jsonArray == null || jsonArray.isEmpty()) return
        for (json in jsonArray) {
            val id = json as String?
            val marker = idToController[id]
            marker?.setOnClickListener(null)
            marker?.setMap(null)
            idToController.remove(id)
        }
    }

    inner class CircleController(json: HashMap<String, Any>) {
        val id: String = json["overlayId"] as String
        private val circle: CircleOverlay = CircleOverlay()

        init {
            circle.tag = this
            interpret(json)
        }

        fun interpret(json: HashMap<String, Any>) {
            if (json.containsKey("center")) circle.center = json["center"]!!.toLatLng()
            if (json.containsKey("radius")) circle.radius = json["radius"] as Double
            if (json.containsKey("color")) circle.color =
                toColorInt(json["color"])
            if (json.containsKey("outlineColor")) circle.outlineColor =
                toColorInt(json["outlineColor"])
            if (json.containsKey("outlineWidth")) circle.outlineWidth =
                (json["outlineWidth"] as Int * density).roundToInt()
            if (json.containsKey("zIndex")) circle.zIndex = json["zIndex"] as Int
            if (json.containsKey("globalZIndex")) circle.globalZIndex =
                json["globalZIndex"] as Int + 1
            if (json.containsKey("minZoom")) circle.minZoom = (json["minZoom"] as Int).toDouble()
            if (json.containsKey("maxZoom")) circle.maxZoom = (json["maxZoom"] as Int).toDouble()
        }

        fun setMap(naverMap: NaverMap?) {
            circle.map = naverMap
        }

        fun setOnClickListener(onClickListener: Overlay.OnClickListener?) {
            circle.onClickListener = onClickListener
        }
    }
}
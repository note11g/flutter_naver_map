package map.naver.plugin.net.note11.naver_map_plugin

import android.os.Handler
import map.naver.plugin.net.note11.naver_map_plugin.Convert.toCoords
import map.naver.plugin.net.note11.naver_map_plugin.Convert.toColorInt
import map.naver.plugin.net.note11.naver_map_plugin.Convert.toHoles
import com.naver.maps.map.NaverMap
import com.naver.maps.map.overlay.Overlay
import android.os.Looper
import com.naver.maps.map.overlay.PolygonOverlay
import java.util.HashMap
import java.util.concurrent.Executors
import kotlin.math.roundToInt

class NaverPolygonController(
    private val naverMap: NaverMap,
    private val onClickListener: Overlay.OnClickListener,
    private val density: Float
) {
    private val handler = Handler(Looper.getMainLooper())
    private val idToController = HashMap<String?, PolygonController?>()
    fun add(jsonArray: List<*>?) {
        if (jsonArray == null || jsonArray.isEmpty()) return
        val service = Executors.newCachedThreadPool()
        service.execute {
            for (json in jsonArray) {
                val data = json as HashMap<String, Any>
                val polygonController = PolygonController(data)
                polygonController.setOnClickListener(onClickListener)
                idToController[polygonController.id] = polygonController
            }
            handler.post {
                val polygons: List<PolygonController?> = idToController.values.toList()
                for (polygon in polygons) {
                    polygon!!.setMap(naverMap)
                }
            }
        }
        service.shutdown()
    }

    fun modify(jsonArray: List<*>?) {
        if (jsonArray == null || jsonArray.isEmpty()) return
        for (json in jsonArray) {
            val data = json as HashMap<String, Any>
            val id = data["polygonOverlayId"] as String?
            idToController[id]!!.interpret(data)
        }
    }

    fun remove(polygonIds: List<*>?) {
        if (polygonIds == null || polygonIds.isEmpty()) return
        for (o in polygonIds) {
            val id = o as String?
            val polygonToRemove = idToController[id]
            polygonToRemove!!.setMap(null)
            polygonToRemove.setOnClickListener(null)
            idToController.remove(id)
        }
    }

    inner class PolygonController(option: HashMap<String, Any>) {
        val id: String = (option["polygonOverlayId"] as String?)!!
        private val polygon: PolygonOverlay = PolygonOverlay()
        fun interpret(option: HashMap<String, Any>) {
            val latLngData = option["coords"] as List<*>?
            if (latLngData != null && latLngData.size >= 3) polygon.coords = latLngData.toCoords()
            val color = option["color"]
            if (color != null) polygon.color = toColorInt(color)
            val outlineColor = option["outlineColor"]
            if (outlineColor != null) polygon.outlineColor =
                toColorInt(outlineColor)
            val width = option["outlineWidth"]
            if (width != null) polygon.outlineWidth = (width as Int * density).roundToInt()
            val globalZIndex = option["globalZIndex"]
            if (globalZIndex != null) polygon.globalZIndex = globalZIndex as Int
            val holes = option["holes"] as List<Any?>?
            if (holes != null) polygon.holes = toHoles(holes)
        }

        fun setMap(naverMap: NaverMap?) {
            polygon.map = naverMap
        }

        fun setOnClickListener(listener: Overlay.OnClickListener?) {
            polygon.onClickListener = listener
        }

        init {
            interpret(option)
            polygon.tag = this
        }
    }
}
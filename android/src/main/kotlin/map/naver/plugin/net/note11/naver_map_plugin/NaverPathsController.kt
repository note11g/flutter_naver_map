package map.naver.plugin.net.note11.naver_map_plugin

import map.naver.plugin.net.note11.naver_map_plugin.Convert.toCoords
import map.naver.plugin.net.note11.naver_map_plugin.Convert.toColorInt
import map.naver.plugin.net.note11.naver_map_plugin.Convert.toOverlayImage
import com.naver.maps.map.NaverMap
import com.naver.maps.map.overlay.Overlay
import com.naver.maps.map.overlay.PathOverlay
import java.util.HashMap
import kotlin.math.roundToInt

class NaverPathsController(
    private val naverMap: NaverMap,
    private val onClickListener: Overlay.OnClickListener,
    private val density: Float
) {
    private val idToController = HashMap<String?, PathController>()
    fun set(pathData: List<*>?) {
        if (pathData == null || pathData.isEmpty()) return
        for (json in pathData) {
            val data = json as HashMap<String, Any>
            val id = data["pathOverlayId"] as String?
            if (idToController.containsKey(id)) {
                idToController[id]!!.interpret(data)
            } else {
                val controller = PathController(data)
                controller.setOnClickListener(onClickListener)
                idToController[controller.id] = controller
                controller.setMap(naverMap)
            }
        }
    }

    fun remove(pathIds: List<*>?) {
        if (pathIds == null || pathIds.isEmpty()) return
        for (json in pathIds) {
            val idToRemove = json as String?
            val pathToRemove = idToController[idToRemove]
            pathToRemove!!.setMap(null)
            pathToRemove.setOnClickListener(null)
            idToController.remove(idToRemove)
        }
    }

    inner class PathController(option: HashMap<String, Any>) {
        val id: String = (option["pathOverlayId"] as String?)!!
        private val path: PathOverlay = PathOverlay()
        fun interpret(option: HashMap<String, Any>) {
            val latLngData = option["coords"] as List<*>?
            if (latLngData != null && latLngData.size >= 2) path.coords = latLngData.toCoords()
            val globalZIndex = option["globalZIndex"]
            if (globalZIndex != null) path.globalZIndex = globalZIndex as Int
            val hideCollidedCaptions = option["hideCollidedCaptions"]
            if (hideCollidedCaptions != null) path.isHideCollidedCaptions =
                hideCollidedCaptions as Boolean
            val hideCollidedMarkers = option["hideCollidedMarkers"]
            if (hideCollidedMarkers != null) path.isHideCollidedMarkers =
                hideCollidedMarkers as Boolean
            val hideCollidedSymbols = option["hideCollidedSymbols"]
            if (hideCollidedSymbols != null) path.isHideCollidedSymbols =
                hideCollidedSymbols as Boolean
            val color = option["color"]
            if (color != null) path.color = toColorInt(color)
            val outlineColor = option["outlineColor"]
            if (outlineColor != null) path.outlineColor =
                toColorInt(outlineColor)
            val passedColor = option["passedColor"]
            if (passedColor != null) path.passedColor = toColorInt(passedColor)
            val passedOutlineColor = option["passedOutlineColor"]
            if (passedOutlineColor != null) path.passedOutlineColor =
                toColorInt(passedOutlineColor)
            val patternImage = option["patternImage"]
            if (patternImage != null) path.patternImage =
                toOverlayImage(patternImage)
            val patternInterval = option["patternInterval"]
            if (patternInterval != null) path.patternInterval =
                (patternInterval as Int * density).roundToInt()
            val progress = option["progress"]
            if (progress != null) path.progress = progress as Double
            val width = option["width"]
            if (width != null) path.width = (width as Int * density).roundToInt()
            val outlineWidth = option["outlineWidth"]
            if (outlineWidth != null) path.outlineWidth =
                (outlineWidth as Int * density).roundToInt()
        }

        fun setMap(naverMap: NaverMap?) {
            path.map = naverMap
        }

        fun setOnClickListener(listener: Overlay.OnClickListener?) {
            path.onClickListener = listener
        }

        init {
            path.tag = this
            interpret(option)
        }
    }
}
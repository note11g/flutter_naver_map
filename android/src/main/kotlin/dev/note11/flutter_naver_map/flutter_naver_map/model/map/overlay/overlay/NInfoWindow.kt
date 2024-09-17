package dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay

import android.content.Context
import com.naver.maps.geometry.LatLng
import com.naver.maps.map.overlay.InfoWindow
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLatLng
import dev.note11.flutter_naver_map.flutter_naver_map.model.base.NPoint
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.info.NOverlayInfo
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil.dpToPx

internal data class NInfoWindow(
    override val info: NOverlayInfo,
    val text: String,
    val anchor: NPoint,
    val alpha: Double,
    val position: LatLng?,
    val offsetXDp: Double,
    val offsetYDp: Double,
    private val context: Context?,
) : AddableOverlay<InfoWindow>() {


    override fun createMapOverlay(): InfoWindow = applyAtRawOverlay(InfoWindow())

    override fun applyAtRawOverlay(overlay: InfoWindow) = overlay.also { m ->
        m.adapter = createTextAdapter(text, context!!)
        m.anchor = anchor.toPointF()
        m.alpha = alpha.toFloat()
        if (position != null) m.position = position
        m.offsetX = dpToPx(offsetXDp)
        m.offsetY = dpToPx(offsetYDp)
    }

    companion object {
        fun fromMessageable(rawMap: Any, context: Context): NInfoWindow = rawMap.asMap().let {
            NInfoWindow(
                info = NOverlayInfo.fromMessageable(it[infoName]!!),
                text = it[textName]!!.toString(),
                anchor = NPoint.fromMessageable(it[anchorName]!!),
                alpha = it[alphaName]!!.asDouble(),
                position = it[positionName]?.asLatLng(),
                offsetXDp = it[offsetXName]!!.asDouble(),
                offsetYDp = it[offsetYName]!!.asDouble(),
                context = context,
            )
        }

        fun createTextAdapter(text: String, context: Context): InfoWindow.Adapter =
            object : InfoWindow.DefaultTextAdapter(context) {
                override fun getText(infoWindow: InfoWindow): CharSequence = text
            }

        /*
            --- Messaging Name Define ---
        */

        private const val infoName = "info"
        const val textName = "text"
        const val anchorName = "anchor"
        const val alphaName = "alpha"
        const val positionName = "position"
        const val offsetXName = "offsetX"
        const val offsetYName = "offsetY"
        const val closeName = "close"
    }
}
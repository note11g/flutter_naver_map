package dev.note11.flutter_naver_map.flutter_naver_map.model.overlay.overlay

import android.content.Context
import com.naver.maps.geometry.LatLng
import com.naver.maps.map.overlay.InfoWindow
import com.naver.maps.map.overlay.Overlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.AddableOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLatLng
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.toMap
import dev.note11.flutter_naver_map.flutter_naver_map.model.NPoint
import dev.note11.flutter_naver_map.flutter_naver_map.model.enum.NOverlayType
import dev.note11.flutter_naver_map.flutter_naver_map.model.overlay.NOverlayInfo
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil.dpToPx
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil.pxToDp

internal data class NInfoWindow(
    override val info: NOverlayInfo,
    val text: String,
    val anchor: NPoint,
    val alpha: Double,
    val position: LatLng?,
    val offsetXDp: Double,
    val offsetYDp: Double,
    private val context: Context?,
) : AddableOverlay<InfoWindow> {

    override fun createMapOverlay(): InfoWindow = InfoWindow().also { m ->
        m.adapter = createTextAdapter(text, context!!)
        m.anchor = anchor.toPointF()
        m.alpha = alpha.toFloat()
        if (position != null) m.position = position
        m.offsetX = dpToPx(offsetXDp)
        m.offsetY = dpToPx(offsetYDp)
    }

    override fun toMap(): Map<String, Any?> = mapOf(
        infoName to info.toMap(),
        textName to text,
        anchorName to anchor.toMap(),
        alphaName to alpha,
        positionName to position?.toMap(),
        offsetXName to offsetXDp,
        offsetYName to offsetYDp,
    )

    companion object {
        fun fromMap(rawMap: Any, context: Context): NInfoWindow = rawMap.asMap().let {
            NInfoWindow(
                info = NOverlayInfo.fromMap(it[infoName]!!),
                text = it[textName]!!.toString(),
                anchor = NPoint.fromMap(it[anchorName]!!),
                alpha = it[alphaName]!!.asDouble(),
                position = it[positionName]?.asLatLng(),
                offsetXDp = it[offsetXName]!!.asDouble(),
                offsetYDp = it[offsetYName]!!.asDouble(),
                context = context,
            )
        }

        fun fromInfoWindow(
            infoWindow: Overlay,
            id: String,
        ): NInfoWindow = (infoWindow as InfoWindow).run {
            NInfoWindow(
                info = NOverlayInfo(NOverlayType.INFO_WINDOW, id),
                text = "",
                anchor = NPoint.fromPointF(anchor),
                alpha = alpha.toDouble(),
                position = position,
                offsetXDp = pxToDp(offsetX),
                offsetYDp = pxToDp(offsetY),
                context = null,
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
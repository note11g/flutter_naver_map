package dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay

import com.naver.maps.geometry.LatLngBounds
import com.naver.maps.map.overlay.GroundOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.AddableOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLatLngBounds
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.info.NOverlayInfo
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.NOverlayImage

internal data class NGroundOverlay(
    override val info: NOverlayInfo,
    val bounds: LatLngBounds,
    val image: NOverlayImage,
    val alpha: Double,
) : AddableOverlay<GroundOverlay>() {

    override fun createMapOverlay(): GroundOverlay = applyAtRawOverlay(GroundOverlay())

    override fun applyAtRawOverlay(overlay: GroundOverlay) = overlay.also { g ->
        g.bounds = bounds
        g.alpha = alpha.toFloat()
        image.applyToOverlay(g::setImage)
    }

    companion object {
        fun fromMessageable(rawMap: Any): NGroundOverlay = rawMap.asMap().let {
            NGroundOverlay(
                info = NOverlayInfo.fromMessageable(it[infoName]!!),
                bounds = it[boundsName]!!.asLatLngBounds(),
                image = NOverlayImage.fromMessageable(it[imageName]!!),
                alpha = it[alphaName]!!.asDouble(),
            )
        }

        /*
            --- Messaging Name Define ---
        */

        private const val infoName = "info"
        const val boundsName = "bounds"
        const val imageName = "image"
        const val alphaName = "alpha"
    }
}
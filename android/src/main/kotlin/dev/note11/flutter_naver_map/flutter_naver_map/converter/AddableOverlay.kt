package dev.note11.flutter_naver_map.flutter_naver_map.converter

import android.content.Context
import com.naver.maps.map.overlay.LocationOverlay
import com.naver.maps.map.overlay.Overlay
import dev.note11.flutter_naver_map.flutter_naver_map.controller.NaverMapControlHandler
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.OverlayHandler
import dev.note11.flutter_naver_map.flutter_naver_map.model.enum.NOverlayType
import dev.note11.flutter_naver_map.flutter_naver_map.model.flutter_default_custom.NPoint
import dev.note11.flutter_naver_map.flutter_naver_map.model.flutter_default_custom.NSize
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.info.NOverlayInfo
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NArrowheadPathOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NCircleOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NGroundOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NInfoWindow
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NMarker
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NMultipartPathOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NPathOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NPolygonOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NPolylineOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil

internal abstract class AddableOverlay<T : Overlay> {
    abstract val info: NOverlayInfo
    abstract fun createMapOverlay(): T

    private lateinit var commonProperties: Map<String, Any>

    fun setCommonProperties(rawArgs: Map<String, Any>) {
        commonProperties = rawArgs.filter { OverlayHandler.allPropertyNames.contains(it.key) }
    }

    fun applyCommonProperties(applyProperty: (name: String, arg: Any) -> Unit) {
        commonProperties.forEach { applyProperty(it.key, it.value) }
    }

    companion object {
        /** Used on @see [NaverMapControlHandler.addOverlayAll] */
        fun fromMessageable(
            info: NOverlayInfo,
            args: Map<String, Any>,
            context: Context,
        ): AddableOverlay<out Overlay> {
            val creator = when (info.type) {
                NOverlayType.MARKER -> NMarker::fromMessageable
                NOverlayType.INFO_WINDOW -> { rawMap ->
                    NInfoWindow.fromMessageable(rawMap, context = context)
                }
                NOverlayType.CIRCLE_OVERLAY -> NCircleOverlay::fromMessageable
                NOverlayType.GROUND_OVERLAY -> NGroundOverlay::fromMessageable
                NOverlayType.POLYGON_OVERLAY -> NPolygonOverlay::fromMessageable
                NOverlayType.POLYLINE_OVERLAY -> NPolylineOverlay::fromMessageable
                NOverlayType.PATH_OVERLAY -> NPathOverlay::fromMessageable
                NOverlayType.MULTIPART_PATH_OVERLAY -> NMultipartPathOverlay::fromMessageable
                NOverlayType.ARROWHEAD_PATH_OVERLAY -> NArrowheadPathOverlay::fromMessageable
                NOverlayType.LOCATION_OVERLAY -> throw IllegalArgumentException("LocationOverlay can not be created from json")
            }

            return creator.invoke(args).apply { setCommonProperties(args) }
        }

        fun LocationOverlay.toMessageable(): Map<String, Any?> = mapOf(
            "info" to NOverlayInfo.locationOverlayInfo.toMessageable(),
            anchorName to NPoint.fromPointF(anchor).toMessageable(),
            circleColorName to circleColor,
            circleOutlineColorName to circleOutlineColor,
            circleOutlineWidthName to DisplayUtil.pxToDp(circleOutlineWidth),
            circleRadiusName to DisplayUtil.pxToDp(circleRadius),
            iconSizeName to NSize.fromPixelSize(iconWidth, iconHeight).toMessageable(),
            subAnchorName to NPoint.fromPointF(subAnchor).toMessageable(),
            subIconSizeName to NSize.fromPixelSize(subIconWidth, subIconHeight)
                .toMessageable(),
        ) + overlayToMessageable(this)

        private const val anchorName = "anchor"
        private const val circleColorName = "circleColor"
        private const val circleOutlineColorName = "circleOutlineColor"
        private const val circleOutlineWidthName = "circleOutlineWidth"
        private const val circleRadiusName = "circleRadius"
        private const val iconSizeName = "iconSize"
        private const val subAnchorName = "subAnchor"
        private const val subIconSizeName = "subIconSize"
    }
}

private fun overlayToMessageable(overlay: Overlay): Map<String, Any?> = overlay.run {
    mapOf(
        OverlayHandler.zIndexName to zIndex,
        OverlayHandler.globalZIndexName to globalZIndex,
        OverlayHandler.isVisibleName to isVisible,
        OverlayHandler.minZoomName to minZoom,
        OverlayHandler.maxZoomName to maxZoom,
        OverlayHandler.isMinZoomInclusiveName to isMinZoomInclusive,
        OverlayHandler.isMaxZoomInclusiveName to isMaxZoomInclusive,
    )
}
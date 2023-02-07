package dev.note11.flutter_naver_map.flutter_naver_map.converter

import android.content.Context
import com.naver.maps.map.overlay.LocationOverlay
import com.naver.maps.map.overlay.Overlay
import dev.note11.flutter_naver_map.flutter_naver_map.controller.NaverMapControlHandler
import dev.note11.flutter_naver_map.flutter_naver_map.model.enum.NOverlayType
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.NOverlayInfo
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NArrowheadPathOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NCircleOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NGroundOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NInfoWindow
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NMarker
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NMultipartPathOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NPathOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NPolygonOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NPolylineOverlay

internal interface AddableOverlay<T : Overlay> {
    val info: NOverlayInfo
    fun createMapOverlay(): T

    fun toMessageable(): Map<String, Any?>

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
            return creator.invoke(args)
        }


        /** Used on @see [NaverMapControlHandler.pickAll] */
        fun fromOverlay(
            overlay: Overlay,
            info: NOverlayInfo,
        ): AddableOverlay<out Overlay> {
            val creator = when (info.type) {
                NOverlayType.MARKER -> NMarker::fromMarker
                NOverlayType.INFO_WINDOW -> NInfoWindow::fromInfoWindow
                NOverlayType.CIRCLE_OVERLAY -> NCircleOverlay::fromCircleOverlay
                NOverlayType.GROUND_OVERLAY -> NGroundOverlay::fromGroundOverlay
                NOverlayType.POLYGON_OVERLAY -> NPolygonOverlay::fromPolygonOverlay
                NOverlayType.POLYLINE_OVERLAY -> NPolylineOverlay::fromPolylineOverlay
                NOverlayType.PATH_OVERLAY -> NPathOverlay::fromPathOverlay
                NOverlayType.MULTIPART_PATH_OVERLAY -> NMultipartPathOverlay::fromMultipartPathOverlay
                NOverlayType.ARROWHEAD_PATH_OVERLAY -> NArrowheadPathOverlay::fromArrowheadPathOverlay
                NOverlayType.LOCATION_OVERLAY -> ::makeLocationOverlayCreator
            }
            return creator.invoke(overlay, info.id)
        }

        private fun makeLocationOverlayCreator(
            overlay: Overlay,
            id: String,
        ): AddableOverlay<out Overlay> = object : AddableOverlay<LocationOverlay> {
            override val info: NOverlayInfo = NOverlayInfo(NOverlayType.LOCATION_OVERLAY, id)
            override fun toMessageable(): Map<String, Any?> = mapOf("info" to info.toMessageable())
            override fun createMapOverlay(): LocationOverlay = overlay as LocationOverlay
        }
    }
}
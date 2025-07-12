package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay

import android.content.Context
import com.naver.maps.geometry.LatLng
import com.naver.maps.map.overlay.*
import com.naver.maps.map.util.MarkerIcons
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.handler.*
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.AddableOverlay
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asBoolean
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asFloat
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asInt
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asList
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asAlign
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLatLng
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLatLngBounds
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLineCap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLineJoin
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.toMessageable
import dev.note11.flutter_naver_map.flutter_naver_map.model.enum.NOverlayType
import dev.note11.flutter_naver_map.flutter_naver_map.model.base.NPoint
import dev.note11.flutter_naver_map.flutter_naver_map.model.base.NSize
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.info.NOverlayInfo
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.info.NOverlayQuery
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.NMultipartPath
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.NOverlayCaption
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.NOverlayImage
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NInfoWindow
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.overlay.overlay.NMarker
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil.dpToPx
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

internal class OverlayController(
    private val channel: MethodChannel,
    private val context: Context,
) : OverlaySender, LocationOverlayHandler, MarkerHandler, InfoWindowHandler, CircleOverlayHandler,
    GroundOverlayHandler, PolygonOverlayHandler, PolylineOverlayHandler, PathOverlayHandler,
    MultipartPathOverlayHandler, ArrowheadPathOverlayHandler, ClusterMarkerHandler, ClusterableMarkerHandler {
    /* ----- channel ----- */
    init {
        channel.setMethodCallHandler(::handler)
    }

    override fun initializeLocationOverlay(overlay: LocationOverlay) {
        saveOverlay(overlay, NOverlayInfo.locationOverlayInfo)
    }

    /* ----- sender ----- */
    override fun onOverlayTapped(info: NOverlayInfo) {
        val query = NOverlayQuery(info, methodName = OverlayHandler.onTapName).query
        channel.invokeMethod(query, null)
    }

    /* ----- overlay storage ----- */

    private val overlays: MutableMap<NOverlayInfo, Overlay> = mutableMapOf()

    override fun saveOverlay(overlay: Overlay, info: NOverlayInfo) {
        info.saveAtOverlay(overlay)
        detachOverlay(info)
        overlays[info] = overlay
    }

    override fun hasOverlay(info: NOverlayInfo): Boolean = overlays.containsKey(info)

    private fun getOverlay(info: NOverlayInfo): Overlay? = overlays[info]

    override fun deleteOverlay(info: NOverlayInfo) {
        detachOverlay(info)
        overlays.remove(info)
    }

    private fun deleteOverlay(mapEntry: Map.Entry<NOverlayInfo, Overlay>) {
        detachOverlay(mapEntry.value)
        overlays.remove(mapEntry.key)
    }

    private fun detachOverlay(info: NOverlayInfo) {
        if (info.type == NOverlayType.LOCATION_OVERLAY) return
        val overlay = getOverlay(info)
        overlay?.let(::detachOverlay)
    }

    private fun detachOverlay(overlay: Overlay) {
        if (overlay is InfoWindow) overlay.close()
        else overlay.map = null
    }

    override fun clearOverlays() {
        filteredOverlays { it.type != NOverlayType.LOCATION_OVERLAY }.forEach(::deleteOverlay)
    }

    override fun clearOverlays(type: NOverlayType) {
        filteredOverlays { it.type == type }.forEach(::deleteOverlay)
    }

    private fun filteredOverlays(predicate: (info: NOverlayInfo) -> Boolean)
            : Map<NOverlayInfo, Overlay> = overlays.filter { predicate.invoke(it.key) }


    /* ----- handler ----- */

    private fun handler(call: MethodCall, result: MethodChannel.Result) {
        val query = NOverlayQuery.fromQuery(call.method)
        val overlay = getOverlay(query.info)

        requireNotNull(overlay) { "overlay can't found because it's null" }

        val isInvokedOnCommonOverlay =
            handleOverlay(overlay, query.methodName, call.arguments, result)

        if (!isInvokedOnCommonOverlay) {
            val overlayHandleFunc = when (query.info.type) {
                NOverlayType.MARKER -> this::handleMarker
                NOverlayType.INFO_WINDOW -> this::handleInfoWindow
                NOverlayType.CIRCLE_OVERLAY -> this::handleCircleOverlay
                NOverlayType.GROUND_OVERLAY -> this::handleGroundOverlay
                NOverlayType.POLYGON_OVERLAY -> this::handlePolygonOverlay
                NOverlayType.POLYLINE_OVERLAY -> this::handlePolylineOverlay
                NOverlayType.PATH_OVERLAY -> this::handlePathOverlay
                NOverlayType.MULTIPART_PATH_OVERLAY -> this::handleMultipartPathOverlay
                NOverlayType.ARROWHEAD_PATH_OVERLAY -> this::handleArrowheadPathOverlay
                NOverlayType.LOCATION_OVERLAY -> this::handleLocationOverlay
                NOverlayType.CLUSTERABLE_MARKER -> this::handleClusterableMarker
            }
            overlayHandleFunc(overlay, query.methodName, call.arguments, result)
        }
    }

    /* ----- All Overlay handler ----- */

    override fun setZIndex(overlay: Overlay, rawZIndex: Any) {
        overlay.zIndex = rawZIndex.asInt()
    }

    override fun setGlobalZIndex(overlay: Overlay, rawGlobalZIndex: Any) {
        overlay.globalZIndex = rawGlobalZIndex.asInt()
    }

    override fun setIsVisible(overlay: Overlay, rawIsVisible: Any) {
        overlay.isVisible = rawIsVisible.asBoolean()
    }

    override fun setMinZoom(overlay: Overlay, rawMinZoom: Any) {
        overlay.minZoom = rawMinZoom.asDouble()
    }

    override fun setMaxZoom(overlay: Overlay, rawMaxZoom: Any) {
        overlay.maxZoom = rawMaxZoom.asDouble()
    }

    override fun setIsMinZoomInclusive(overlay: Overlay, rawIsMinZoomInclusive: Any) {
        overlay.isMinZoomInclusive = rawIsMinZoomInclusive.asBoolean()
    }

    override fun setIsMaxZoomInclusive(overlay: Overlay, rawIsMaxZoomInclusive: Any) {
        overlay.isMaxZoomInclusive = rawIsMaxZoomInclusive.asBoolean()
    }

    override fun performClick(overlay: Overlay, success: (Any?) -> Unit) {
        overlay.performClick()
        success(null)
    }

    override fun setHasOnTapListener(overlay: Overlay, rawHasOnTapListener: Any) {
        val hasOnTapListener = rawHasOnTapListener.asBoolean()
        if (hasOnTapListener) {
            overlay.setOnClickListener {
                onOverlayTapped(info = NOverlayInfo.fromOverlay(it))
                return@setOnClickListener true
            }
        } else {
            overlay.onClickListener = null
        }
    }

    /* ----- LocationOverlay handler ----- */


    override fun setAnchor(overlay: LocationOverlay, rawNPoint: Any) {
        val nPoint = NPoint.fromMessageable(rawNPoint)
        overlay.anchor = nPoint.toPointF()
    }

    override fun getBearing(overlay: LocationOverlay, success: (bearing: Float) -> Unit) {
        success(overlay.bearing)
    }

    override fun setBearing(overlay: LocationOverlay, rawBearing: Any) {
        overlay.bearing = rawBearing.asFloat()
    }

    override fun setCircleColor(overlay: LocationOverlay, rawColor: Any) {
        overlay.circleColor = rawColor.asInt()
    }

    override fun setCircleOutlineColor(overlay: LocationOverlay, rawColor: Any) {
        overlay.circleOutlineColor = rawColor.asInt()
    }

    override fun setCircleOutlineWidth(overlay: LocationOverlay, rawWidth: Any) {
        overlay.circleOutlineWidth = dpToPx(rawWidth.asDouble())
    }

    override fun setCircleRadius(overlay: LocationOverlay, rawRadius: Any) {
        overlay.circleRadius = dpToPx(rawRadius.asDouble())
    }

    override fun setIcon(overlay: LocationOverlay, rawNOverlayImage: Any) {
        val nOverlayImage = NOverlayImage.fromMessageable(rawNOverlayImage.asMap())
        nOverlayImage.applyToOverlay(overlay::setIcon)
    }

    override fun setIconSize(overlay: LocationOverlay, rawSize: Any) {
        NSize.fromMessageable(rawSize)
            .run { useAsPixelSize(overlay::setIconWidth, overlay::setIconHeight) }
    }

    override fun setIconAlpha(overlay: LocationOverlay, rawAlpha: Any) {
        overlay.iconAlpha = rawAlpha.asFloat()
    }

    override fun getPosition(
        overlay: LocationOverlay,
        success: (latLng: Map<String, Any>) -> Unit,
    ) {
        success(overlay.position.toMessageable())
    }

    override fun setPosition(overlay: LocationOverlay, rawLatLng: Any) {
        overlay.position = rawLatLng.asLatLng()
    }

    override fun setSubAnchor(overlay: LocationOverlay, rawNPoint: Any) {
        val nPoint = NPoint.fromMessageable(rawNPoint)
        overlay.subAnchor = nPoint.toPointF()
    }

    override fun setSubIcon(overlay: LocationOverlay, rawNOverlayImage: Any?) {
        val nOverlayImage = rawNOverlayImage?.asMap()?.let(NOverlayImage::fromMessageable)
        if (nOverlayImage != null) nOverlayImage.applyToOverlay(overlay::setSubIcon)
        else {
            overlay.subIcon = null
            println("subIcon cleared!")
        }
    }

    override fun setSubIconSize(overlay: LocationOverlay, rawSize: Any) {
        NSize.fromMessageable(rawSize).run {
            useAsPixelSize(overlay::setSubIconWidth, overlay::setSubIconHeight)
        }
    }

    override fun setSubIconAlpha(overlay: LocationOverlay, rawAlpha: Any) {
        overlay.subIconAlpha = rawAlpha.asFloat()
    }

    /* ----- Marker handler ----- */

    override fun hasOpenInfoWindow(marker: Marker, success: (hasOpenInfoWindow: Boolean) -> Unit) {
        success(marker.hasInfoWindow())
    }

    override fun openInfoWindow(
        marker: Marker,
        rawInfoWindow: Any,
        rawAlign: Any,
        success: (Any?) -> Unit,
    ) {
        val nInfoWindow = AddableOverlay.fromMessageableCorrector(rawInfoWindow.asMap()) {
            NInfoWindow.fromMessageable(it, context = context)
        }

        val infoWindow = saveOverlayWithAddable(creator = nInfoWindow)

        val align = rawAlign.asAlign()
        infoWindow.open(marker, align)
        success(null)
    }

    override fun setPosition(marker: Marker, rawPosition: Any) {
        marker.position = rawPosition.asLatLng()
    }

    override fun setIcon(marker: Marker, rawIcon: Any?) {
        val nOverlayImage = rawIcon?.asMap()?.let(NOverlayImage::fromMessageable)

        if (nOverlayImage != null) nOverlayImage.applyToOverlay(marker::setIcon)
        else marker.icon = MarkerIcons.GREEN
    }

    override fun setIconTintColor(marker: Marker, rawIconTintColor: Any) {
        marker.iconTintColor = rawIconTintColor.asInt()
    }

    override fun setAlpha(marker: Marker, rawAlpha: Any) {
        marker.alpha = rawAlpha.asFloat()
    }

    override fun setAngle(marker: Marker, rawAngle: Any) {
        marker.angle = rawAngle.asFloat()
    }

    override fun setAnchor(marker: Marker, rawNPoint: Any) {
        val nPoint = NPoint.fromMessageable(rawNPoint)
        marker.anchor = nPoint.toPointF()
    }

    override fun setSize(marker: Marker, rawNPoint: Any) {
        val nSize = NSize.fromMessageable(rawNPoint)
        nSize.useAsPixelSize(marker::setWidth, marker::setHeight)
    }

    override fun setCaption(marker: Marker, rawCaption: Any) {
        NOverlayCaption.fromMessageable(rawCaption).run {
            useWithFunctions(
                textFunc = marker::setCaptionText,
                textSizeFunc = marker::setCaptionTextSize,
                colorFunc = marker::setCaptionColor,
                haloColorFunc = marker::setCaptionHaloColor,
                minZoomFunc = marker::setCaptionMinZoom,
                maxZoomFunc = marker::setCaptionMaxZoom,
                requestWidthFunc = marker::setCaptionRequestedWidth,
            )
        }
    }

    override fun setSubCaption(marker: Marker, rawSubCaption: Any) {
        NOverlayCaption.fromMessageable(rawSubCaption).run {
            useWithFunctions(
                textFunc = marker::setSubCaptionText,
                textSizeFunc = marker::setSubCaptionTextSize,
                colorFunc = marker::setSubCaptionColor,
                haloColorFunc = marker::setSubCaptionHaloColor,
                minZoomFunc = marker::setSubCaptionMinZoom,
                maxZoomFunc = marker::setSubCaptionMaxZoom,
                requestWidthFunc = marker::setSubCaptionRequestedWidth,
            )
        }
    }

    override fun setCaptionAligns(marker: Marker, rawCaptionAligns: Any) {
        val captionAligns = rawCaptionAligns.asList { it.asAlign() }
        marker.setCaptionAligns(*captionAligns.toTypedArray())
    }

    override fun setCaptionOffset(marker: Marker, rawDpOffset: Any) {
        marker.captionOffset = dpToPx(rawDpOffset.asDouble())
    }

    override fun setIsCaptionPerspectiveEnabled(marker: Marker, rawCaptionPerspectiveEnabled: Any) {
        marker.isCaptionPerspectiveEnabled = rawCaptionPerspectiveEnabled.asBoolean()
    }

    override fun setIsIconPerspectiveEnabled(marker: Marker, rawIconPerspectiveEnabled: Any) {
        marker.isIconPerspectiveEnabled = rawIconPerspectiveEnabled.asBoolean()
    }

    override fun setIsFlat(marker: Marker, rawFlat: Any) {
        marker.isFlat = rawFlat.asBoolean()
    }

    override fun setIsForceShowCaption(marker: Marker, rawForceShowCaption: Any) {
        marker.isForceShowCaption = rawForceShowCaption.asBoolean()
    }

    override fun setIsForceShowIcon(marker: Marker, rawForceShowIcon: Any) {
        marker.isForceShowIcon = rawForceShowIcon.asBoolean()
    }

    override fun setIsHideCollidedCaptions(marker: Marker, rawHideCollidedCaptions: Any) {
        marker.isHideCollidedCaptions = rawHideCollidedCaptions.asBoolean()
    }

    override fun setIsHideCollidedMarkers(marker: Marker, rawHideCollidedMarkers: Any) {
        marker.isHideCollidedMarkers = rawHideCollidedMarkers.asBoolean()
    }

    override fun setIsHideCollidedSymbols(marker: Marker, rawHideCollidedSymbols: Any) {
        marker.isHideCollidedSymbols = rawHideCollidedSymbols.asBoolean()
    }

    /* ----- InfoWindow handler ----- */
    override fun setText(infoWindow: InfoWindow, rawText: Any) {
        infoWindow.adapter = NInfoWindow.createTextAdapter(rawText.toString(), context)
    }

    override fun setAnchor(infoWindow: InfoWindow, rawNPoint: Any) {
        val nPoint = NPoint.fromMessageable(rawNPoint)
        infoWindow.anchor = nPoint.toPointF()
    }

    override fun setAlpha(infoWindow: InfoWindow, rawAlpha: Any) {
        infoWindow.alpha = rawAlpha.asFloat()
    }

    override fun setPosition(infoWindow: InfoWindow, rawPosition: Any) {
        infoWindow.position = rawPosition.asLatLng()
    }

    override fun setOffsetX(infoWindow: InfoWindow, rawOffsetXDp: Any) {
        infoWindow.offsetY = dpToPx(rawOffsetXDp.asDouble())
    }

    override fun setOffsetY(infoWindow: InfoWindow, rawOffsetYDp: Any) {
        infoWindow.offsetY = dpToPx(rawOffsetYDp.asDouble())
    }

    override fun close(infoWindow: InfoWindow) {
        infoWindow.close()
    }

    /* ----- Circle Overlay handler ----- */

    override fun setCenter(circleOverlay: CircleOverlay, rawCenter: Any) {
        circleOverlay.center = rawCenter.asLatLng()
    }

    override fun setRadius(circleOverlay: CircleOverlay, rawRadius: Any) {
        circleOverlay.radius = rawRadius.asDouble()
    }

    override fun setColor(circleOverlay: CircleOverlay, rawColor: Any) {
        circleOverlay.color = rawColor.asInt()
    }

    override fun setOutlineColor(circleOverlay: CircleOverlay, rawOutlineColor: Any) {
        circleOverlay.outlineColor = rawOutlineColor.asInt()
    }

    override fun setOutlineWidth(circleOverlay: CircleOverlay, rawOutlineWidth: Any) {
        circleOverlay.outlineWidth = dpToPx(rawOutlineWidth.asDouble())
    }

    override fun getBounds(
        circleOverlay: CircleOverlay,
        result: (bounds: Map<String, Any>) -> Unit,
    ) {
        result(circleOverlay.bounds.toMessageable())
    }

    /* ----- Ground Overlay handler ----- */

    override fun setBounds(groundOverlay: GroundOverlay, rawBounds: Any) {
        groundOverlay.bounds = rawBounds.asLatLngBounds()
    }

    override fun setImage(groundOverlay: GroundOverlay, rawNOverlayImage: Any) {
        val nOverlayImage = NOverlayImage.fromMessageable(rawNOverlayImage)
        nOverlayImage.applyToOverlay(groundOverlay::setImage)
    }

    override fun setAlpha(groundOverlay: GroundOverlay, rawAlpha: Any) {
        groundOverlay.alpha = rawAlpha.asFloat()
    }

    /* ----- Polygon Overlay handler ----- */

    override fun setCoords(polygonOverlay: PolygonOverlay, rawCoords: Any) {
        polygonOverlay.coords = rawCoords.asList { it.asLatLng() }
    }

    override fun setColor(polygonOverlay: PolygonOverlay, rawColor: Any) {
        polygonOverlay.color = rawColor.asInt()
    }

    override fun setHoles(polygonOverlay: PolygonOverlay, rawHoles: Any) {
        polygonOverlay.holes = rawHoles.asList { it.asList { h -> h.asLatLng() } }
    }

    override fun setOutlineColor(polygonOverlay: PolygonOverlay, rawColor: Any) {
        polygonOverlay.outlineColor = rawColor.asInt()
    }

    override fun setOutlineWidth(polygonOverlay: PolygonOverlay, rawWidthDp: Any) {
        polygonOverlay.outlineWidth = dpToPx(rawWidthDp.asDouble())
    }

    override fun setOutlinePattern(polygonOverlay: PolygonOverlay, rawPatternDpList: Any) {
        val patternList = rawPatternDpList.asList { dpToPx(it.asDouble()) }
        polygonOverlay.setOutlinePattern(*patternList.toIntArray())
    }

    override fun getBounds(
        polygonOverlay: PolygonOverlay,
        success: (bounds: Map<String, Any>) -> Unit,
    ) {
        success(polygonOverlay.bounds.toMessageable())
    }

    /* ----- Polyline Overlay handler ----- */

    override fun setCoords(polylineOverlay: PolylineOverlay, rawCoords: Any) {
        polylineOverlay.coords = rawCoords.asList { it.asLatLng() }
    }

    override fun setColor(polylineOverlay: PolylineOverlay, rawColor: Any) {
        polylineOverlay.color = rawColor.asInt()
    }

    override fun setWidth(polylineOverlay: PolylineOverlay, rawWidthDp: Any) {
        polylineOverlay.width = dpToPx(rawWidthDp.asDouble())
    }

    override fun setLineCap(polylineOverlay: PolylineOverlay, rawLineCap: Any) {
        polylineOverlay.capType = rawLineCap.asLineCap()
    }

    override fun setLineJoin(polylineOverlay: PolylineOverlay, rawLineJoin: Any) {
        polylineOverlay.joinType = rawLineJoin.asLineJoin()
    }

    override fun setPattern(polylineOverlay: PolylineOverlay, patternDpList: Any) {
        val patternList = patternDpList.asList { dpToPx(it.asDouble()) }
        polylineOverlay.setPattern(*patternList.toIntArray())
    }

    override fun getBounds(
        polylineOverlay: PolylineOverlay,
        success: (bounds: Map<String, Any>) -> Unit,
    ) {
        success(polylineOverlay.bounds.toMessageable())
    }

    /* ----- Path Overlay handler ----- */

    override fun setCoords(pathOverlay: PathOverlay, rawCoords: Any) {
        pathOverlay.coords = rawCoords.asList { it.asLatLng() }
    }

    override fun setWidth(pathOverlay: PathOverlay, rawWidthDp: Any) {
        pathOverlay.width = dpToPx(rawWidthDp.asDouble())
    }

    override fun setColor(pathOverlay: PathOverlay, rawColor: Any) {
        pathOverlay.color = rawColor.asInt()
    }

    override fun setOutlineWidth(pathOverlay: PathOverlay, rawWidthDp: Any) {
        pathOverlay.outlineWidth = dpToPx(rawWidthDp.asDouble())
    }

    override fun setOutlineColor(pathOverlay: PathOverlay, rawColor: Any) {
        pathOverlay.outlineColor = rawColor.asInt()
    }

    override fun setPassedColor(pathOverlay: PathOverlay, rawColor: Any) {
        pathOverlay.passedColor = rawColor.asInt()
    }

    override fun setPassedOutlineColor(pathOverlay: PathOverlay, rawColor: Any) {
        pathOverlay.passedOutlineColor = rawColor.asInt()
    }

    override fun setProgress(pathOverlay: PathOverlay, rawProgress: Any) {
        pathOverlay.progress = rawProgress.asDouble()
    }

    override fun setPatternImage(pathOverlay: PathOverlay, rawNOverlayImage: Any) {
        val nOverlayImage = NOverlayImage.fromMessageable(rawNOverlayImage)
        nOverlayImage.applyToOverlay(pathOverlay::setPatternImage)
    }

    override fun setPatternInterval(pathOverlay: PathOverlay, rawInterval: Any) {
        pathOverlay.patternInterval = dpToPx(rawInterval.asDouble())
    }

    override fun setIsHideCollidedCaptions(pathOverlay: PathOverlay, rawFlag: Any) {
        pathOverlay.isHideCollidedCaptions = rawFlag.asBoolean()
    }

    override fun setIsHideCollidedMarkers(pathOverlay: PathOverlay, rawFlag: Any) {
        pathOverlay.isHideCollidedMarkers = rawFlag.asBoolean()
    }

    override fun setIsHideCollidedSymbols(pathOverlay: PathOverlay, rawFlag: Any) {
        pathOverlay.isHideCollidedSymbols = rawFlag.asBoolean()
    }

    override fun getBounds(pathOverlay: PathOverlay, success: (bounds: Map<String, Any>) -> Unit) {
        success(pathOverlay.bounds.toMessageable())
    }

    /* ----- Multipart Path Overlay handler ----- */

    override fun setPaths(multipartPathOverlay: MultipartPathOverlay, rawPaths: Any) {
        val paths = rawPaths.asList(NMultipartPath::fromMessageable)
        val coords = mutableListOf<List<LatLng>>()
        val colors = mutableListOf<MultipartPathOverlay.ColorPart>()
        paths.forEach {
            coords.add(it.coords)
            colors.add(it.toColorPart())
        }
        multipartPathOverlay.coordParts = coords
        multipartPathOverlay.colorParts = colors
    }

    override fun setWidth(multipartPathOverlay: MultipartPathOverlay, rawWidthDp: Any) {
        multipartPathOverlay.width = dpToPx(rawWidthDp.asDouble())
    }

    override fun setOutlineWidth(multipartPathOverlay: MultipartPathOverlay, rawWidthDp: Any) {
        multipartPathOverlay.outlineWidth = dpToPx(rawWidthDp.asDouble())
    }

    override fun setPatternImage(
        multipartPathOverlay: MultipartPathOverlay,
        rawNOverlayImage: Any,
    ) {
        val nOverlayImage = NOverlayImage.fromMessageable(rawNOverlayImage)
        nOverlayImage.applyToOverlay(multipartPathOverlay::setPatternImage)
    }

    override fun setPatternInterval(multipartPathOverlay: MultipartPathOverlay, rawInterval: Any) {
        multipartPathOverlay.patternInterval = dpToPx(rawInterval.asDouble())
    }

    override fun setProgress(multipartPathOverlay: MultipartPathOverlay, rawProgress: Any) {
        multipartPathOverlay.progress = rawProgress.asDouble()
    }

    override fun setIsHideCollidedCaptions(
        multipartPathOverlay: MultipartPathOverlay,
        rawFlag: Any,
    ) {
        multipartPathOverlay.isHideCollidedCaptions = rawFlag.asBoolean()
    }

    override fun setIsHideCollidedMarkers(
        multipartPathOverlay: MultipartPathOverlay,
        rawFlag: Any,
    ) {
        multipartPathOverlay.isHideCollidedMarkers = rawFlag.asBoolean()
    }

    override fun setIsHideCollidedSymbols(
        multipartPathOverlay: MultipartPathOverlay,
        rawFlag: Any,
    ) {
        multipartPathOverlay.isHideCollidedSymbols = rawFlag.asBoolean()
    }

    override fun getBounds(
        multipartPathOverlay: MultipartPathOverlay,
        success: (bounds: Map<String, Any>) -> Unit,
    ) {
        success(multipartPathOverlay.bounds.toMessageable())
    }

    /* ----- ArrowHeadPath Overlay handler ----- */

    override fun setCoords(arrowheadPathOverlay: ArrowheadPathOverlay, rawCoords: Any) {
        arrowheadPathOverlay.coords = rawCoords.asList { it.asLatLng() }
    }

    override fun setWidth(arrowheadPathOverlay: ArrowheadPathOverlay, rawWidthDp: Any) {
        arrowheadPathOverlay.width = dpToPx(rawWidthDp.asDouble())
    }

    override fun setColor(arrowheadPathOverlay: ArrowheadPathOverlay, rawColor: Any) {
        arrowheadPathOverlay.color = rawColor.asInt()
    }

    override fun setOutlineWidth(arrowheadPathOverlay: ArrowheadPathOverlay, rawWidthDp: Any) {
        arrowheadPathOverlay.outlineWidth = dpToPx(rawWidthDp.asDouble())
    }

    override fun setOutlineColor(arrowheadPathOverlay: ArrowheadPathOverlay, rawColor: Any) {
        arrowheadPathOverlay.outlineColor = rawColor.asInt()
    }

    override fun setElevation(arrowheadPathOverlay: ArrowheadPathOverlay, rawElevationDp: Any) {
        arrowheadPathOverlay.elevation = dpToPx(rawElevationDp.asDouble())
    }

    override fun setHeadSizeRatio(arrowheadPathOverlay: ArrowheadPathOverlay, rawRatio: Any) {
        arrowheadPathOverlay.headSizeRatio = rawRatio.asFloat()
    }

    override fun getBounds(
        arrowheadPathOverlay: ArrowheadPathOverlay,
        success: (bounds: Map<String, Any>) -> Unit,
    ) {
        success(arrowheadPathOverlay.bounds.toMessageable())
    }

    /* ----- Cluster Marker handler ----- */
    override fun syncClusterMarker(marker: Marker, rawClusterMarker: Any, success: (Any?) -> Unit) {
        val mapData = rawClusterMarker.asMap()
        val clusterMarker = AddableOverlay.fromMessageableCorrector(mapData, NMarker::fromMessageable)
        clusterMarker.applyAtRawOverlay(marker)
        val hasCustomOnTapListener = mapData[OverlayHandler.hasOnTapListenerName]?.asBoolean() == true
        if (hasCustomOnTapListener) {
            marker.onClickListener = Overlay.OnClickListener {
                onOverlayTapped(info = NOverlayInfo.fromOverlay(it))
                true
            }
        }
        marker.isVisible = true
        success(null)
    }

    /*
      --- remove ---
    */

    override fun remove() {
        channel.setMethodCallHandler(null)
    }
}

package dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay

import android.content.Context
import android.util.Log
import com.naver.maps.geometry.LatLng
import com.naver.maps.map.overlay.*
import dev.note11.flutter_naver_map.flutter_naver_map.controller.overlay.handler.*
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
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.toMap
import dev.note11.flutter_naver_map.flutter_naver_map.model.NPoint
import dev.note11.flutter_naver_map.flutter_naver_map.model.NSize
import dev.note11.flutter_naver_map.flutter_naver_map.model.enum.NOverlayType
import dev.note11.flutter_naver_map.flutter_naver_map.model.overlay.NMultipartPath
import dev.note11.flutter_naver_map.flutter_naver_map.model.overlay.NOverlayCaption
import dev.note11.flutter_naver_map.flutter_naver_map.model.overlay.NOverlayImage
import dev.note11.flutter_naver_map.flutter_naver_map.model.overlay.NOverlayInfo
import dev.note11.flutter_naver_map.flutter_naver_map.model.overlay.overlay.NInfoWindow
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil.dpToPx
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil.pxToDp
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

internal class OverlayController(
    private val channel: MethodChannel,
    private val context: Context,
) : LocationOverlayHandler, MarkerHandler, InfoWindowHandler, CircleOverlayHandler,
    GroundOverlayHandler, PolygonOverlayHandler, PolylineOverlayHandler, PathOverlayHandler,
    MultipartPathOverlayHandler, ArrowheadPathOverlayHandler {
    /* ----- channel ----- */
    init {
        channel.setMethodCallHandler(::handler)
    }

    /* ----- overlay storage ----- */

    private val overlays: MutableMap<String, Overlay> = mutableMapOf()

    override fun hasOverlay(info: NOverlayInfo): Boolean = overlays.containsKey(info.overlayMapKey)

    override fun saveOverlay(overlay: Overlay, info: NOverlayInfo) {
        detachOverlay(info)
        overlays[info.overlayMapKey] = overlay.apply {
            setOnClickListener {
                channel.invokeMethod(info.toQueryString(OverlayHandler.onTapName), null)
                true
            }
        }
    }

    private fun getOverlay(info: NOverlayInfo): Overlay? = overlays[info.overlayMapKey]

    override fun deleteOverlay(info: NOverlayInfo) {
        detachOverlay(info)
        overlays.remove(info.overlayMapKey)
    }

    private fun deleteOverlay(mapEntry: Map.Entry<String, Overlay>) {
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

    private fun filteredOverlays(predicate: (info: NOverlayInfo) -> Boolean): Map<String, Overlay> =
        overlays.filter {
            val info = NOverlayInfo.fromString(it.key)
            predicate.invoke(info)
        }

    override fun getSavedOverlayKey(overlay: Overlay): String? {
        overlays.forEach { (key, value) ->
            if (value == overlay) return@getSavedOverlayKey key
        }
        return null
    }

    /* ----- handler ----- */

    private fun handler(call: MethodCall, result: MethodChannel.Result) {
        val queryInfo = NOverlayInfo.fromString(call.method)
        val overlay = queryInfo.getOverlay(overlays)

        requireNotNull(overlay) { "overlay can't found because it's null" }

        val isInvokedOnCommonOverlay =
            handleOverlay(overlay, queryInfo.method!!, call.arguments, result)

        if (!isInvokedOnCommonOverlay) when (queryInfo.type) {
            NOverlayType.MARKER -> handleMarker(
                overlay as Marker, queryInfo.method, call.arguments, result
            )
            NOverlayType.INFO_WINDOW -> handleInfoWindow(
                overlay as InfoWindow, queryInfo.method, call.arguments, result
            )
            NOverlayType.CIRCLE_OVERLAY -> handleCircleOverlay(
                overlay as CircleOverlay, queryInfo.method, call.arguments, result
            )
            NOverlayType.GROUND_OVERLAY -> handleGroundOverlay(
                overlay as GroundOverlay, queryInfo.method, call.arguments, result
            )
            NOverlayType.POLYGON_OVERLAY -> handlePolygonOverlay(
                overlay as PolygonOverlay, queryInfo.method, call.arguments, result
            )
            NOverlayType.POLYLINE_OVERLAY -> handlePolylineOverlay(
                overlay as PolylineOverlay, queryInfo.method, call.arguments, result
            )
            NOverlayType.PATH_OVERLAY -> handlePathOverlay(
                overlay as PathOverlay, queryInfo.method, call.arguments, result
            )
            NOverlayType.MULTI_PART_PATH_OVERLAY -> handleMultipartPathOverlay(
                overlay as MultipartPathOverlay, queryInfo.method, call.arguments, result
            )
            NOverlayType.ARROW_HEAD_PATH_OVERLAY -> handleArrowheadPathOverlay(
                overlay as ArrowheadPathOverlay, queryInfo.method, call.arguments, result
            )
            NOverlayType.LOCATION_OVERLAY -> handleLocationOverlay(
                overlay as LocationOverlay, queryInfo.method, call.arguments, result
            )
        }
    }

    /* ----- All Overlay handler ----- */

    override fun getZIndex(overlay: Overlay, success: (zIndex: Int) -> Unit) {
        success(overlay.zIndex)
    }

    override fun setZIndex(overlay: Overlay, rawZIndex: Any) {
        overlay.zIndex = rawZIndex.asInt()
    }

    override fun getGlobalZIndex(overlay: Overlay, success: (globalZIndex: Int) -> Unit) {
        success(overlay.globalZIndex)
    }

    override fun setGlobalZIndex(overlay: Overlay, rawGlobalZIndex: Any) {
        overlay.globalZIndex = rawGlobalZIndex.asInt()
    }

    override fun getTag(overlay: Overlay, success: (tag: String?) -> Unit) {
        success(overlay.tag?.toString())
    }

    override fun setTag(overlay: Overlay, rawTag: String) {
        overlay.tag = rawTag
    }

    override fun getIsAdded(overlay: Overlay, success: (isAdded: Boolean) -> Unit) {
        success(overlay.isAdded)
    }

    override fun getIsVisible(overlay: Overlay, success: (isVisible: Boolean) -> Unit) {
        success(overlay.isVisible)
    }

    override fun setIsVisible(overlay: Overlay, rawIsVisible: Any) {
        overlay.isVisible = rawIsVisible.asBoolean()
    }

    override fun getMinZoom(overlay: Overlay, success: (minZoom: Double) -> Unit) {
        success(overlay.minZoom)
    }

    override fun setMinZoom(overlay: Overlay, rawMinZoom: Any) {
        overlay.minZoom = rawMinZoom.asDouble()
    }

    override fun getMaxZoom(overlay: Overlay, success: (maxZoom: Double) -> Unit) {
        success(overlay.maxZoom)
    }

    override fun setMaxZoom(overlay: Overlay, rawMaxZoom: Any) {
        overlay.maxZoom = rawMaxZoom.asDouble()
    }

    override fun getIsMinZoomInclusive(
        overlay: Overlay,
        success: (isMinZoomInclusive: Boolean) -> Unit,
    ) {
        success(overlay.isMinZoomInclusive)
    }

    override fun setIsMinZoomInclusive(overlay: Overlay, rawIsMinZoomInclusive: Any) {
        overlay.isMinZoomInclusive = rawIsMinZoomInclusive.asBoolean()
    }

    override fun getIsMaxZoomInclusive(
        overlay: Overlay,
        success: (isMaxZoomInclusive: Boolean) -> Unit,
    ) {
        success(overlay.isMaxZoomInclusive)
    }

    override fun setIsMaxZoomInclusive(overlay: Overlay, rawIsMaxZoomInclusive: Any) {
        overlay.isMaxZoomInclusive = rawIsMaxZoomInclusive.asBoolean()
    }

    override fun performClick(overlay: Overlay, success: (Any?) -> Unit) {
        overlay.performClick()
        success(null)
    }

    /* ----- LocationOverlay handler ----- */

    override fun getAnchor(overlay: LocationOverlay, success: (nPoint: Map<String, Any>) -> Unit) {
        val anchor = overlay.anchor
        success(NPoint.fromPointF(anchor).toMap())
    }

    override fun setAnchor(overlay: LocationOverlay, rawNPoint: Any) {
        val nPoint = NPoint.fromMap(rawNPoint)
        overlay.anchor = nPoint.toPointF()
    }

    override fun getBearing(overlay: LocationOverlay, success: (bearing: Float) -> Unit) {
        success(overlay.bearing)
    }

    override fun setBearing(overlay: LocationOverlay, rawBearing: Any) {
        overlay.bearing = rawBearing.asFloat()
    }

    override fun getCircleColor(overlay: LocationOverlay, success: (color: Int) -> Unit) {
        success(overlay.circleColor)
    }

    override fun setCircleColor(overlay: LocationOverlay, rawColor: Any) {
        overlay.circleColor = rawColor.asInt()
    }

    override fun getCircleOutlineColor(overlay: LocationOverlay, success: (color: Int) -> Unit) {
        overlay.circleOutlineColor.let(success)
    }

    override fun setCircleOutlineColor(overlay: LocationOverlay, rawColor: Any) {
        overlay.circleOutlineColor = rawColor.asInt()
    }

    override fun getCircleOutlineWidth(overlay: LocationOverlay, success: (width: Double) -> Unit) {
        pxToDp(overlay.circleOutlineWidth).let(success)
    }

    override fun setCircleOutlineWidth(overlay: LocationOverlay, rawWidth: Any) {
        overlay.circleOutlineWidth = dpToPx(rawWidth.asDouble())
    }

    override fun getCircleRadius(overlay: LocationOverlay, success: (width: Double) -> Unit) {
        pxToDp(overlay.circleRadius).let(success)
    }

    override fun setCircleRadius(overlay: LocationOverlay, rawRadius: Any) {
        overlay.circleRadius = dpToPx(rawRadius.asDouble())
    }

    override fun setIcon(overlay: LocationOverlay, rawNOverlayImage: Any) {
        val nOverlayImage = NOverlayImage.fromMap(rawNOverlayImage.asMap())
        nOverlayImage.applyToOverlay(overlay::setIcon)
    }

    override fun getIconSize(overlay: LocationOverlay, success: (size: Map<String, Any>) -> Unit) {
        overlay.run { success(NSize.fromPixelSize(iconWidth, iconHeight).toMap()) }
    }

    override fun setIconSize(overlay: LocationOverlay, rawSize: Any) {
        NSize.fromMap(rawSize).run { useAsPixelSize(overlay::setIconWidth, overlay::setIconHeight) }
    }

    override fun getPosition(
        overlay: LocationOverlay,
        success: (latLng: Map<String, Any>) -> Unit,
    ) {
        success(overlay.position.toMap())
    }

    override fun setPosition(overlay: LocationOverlay, rawLatLng: Any) {
        overlay.position = rawLatLng.asLatLng()
    }

    override fun getSubAnchor(
        overlay: LocationOverlay,
        success: (nPoint: Map<String, Any>) -> Unit,
    ) {
        val subAnchor = overlay.subAnchor
        success(NPoint.fromPointF(subAnchor).toMap())
    }

    override fun setSubAnchor(overlay: LocationOverlay, rawNPoint: Any) {
        val nPoint = NPoint.fromMap(rawNPoint)
        overlay.subAnchor = nPoint.toPointF()
    }

    override fun setSubIcon(overlay: LocationOverlay, rawNOverlayImage: Any) {
        val nOverlayImage = NOverlayImage.fromMap(rawNOverlayImage.asMap())
        nOverlayImage.applyToOverlay(overlay::setSubIcon)
    }

    override fun getSubIconSize(
        overlay: LocationOverlay,
        success: (size: Map<String, Any>) -> Unit,
    ) {
        overlay.run { success(NSize.fromPixelSize(subIconWidth, subIconHeight).toMap()) }
    }

    override fun setSubIconSize(overlay: LocationOverlay, rawSize: Any) {
        NSize.fromMap(rawSize).run {
            useAsPixelSize(overlay::setSubIconWidth, overlay::setSubIconHeight)
        }
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
        val nInfoWindow = NInfoWindow.fromMap(rawInfoWindow, context = context)
        val infoWindow = saveOverlayWithAddable(creator = nInfoWindow)

        val align = rawAlign.asAlign()
        infoWindow.open(marker, align)
        success(null)
    }

    override fun setPosition(marker: Marker, rawPosition: Any) {
        marker.position = rawPosition.asLatLng()
    }

    override fun setIcon(marker: Marker, rawIcon: Any) {
        val nOverlayImage = NOverlayImage.fromMap(rawIcon.asMap())
        nOverlayImage.applyToOverlay(marker::setIcon)
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
        val nPoint = NPoint.fromMap(rawNPoint)
        marker.anchor = nPoint.toPointF()
    }

    override fun setSize(marker: Marker, rawNPoint: Any) {
        val nSize = NSize.fromMap(rawNPoint)
        nSize.useAsPixelSize(marker::setWidth, marker::setHeight)
    }

    override fun setCaption(marker: Marker, rawCaption: Any) {
        NOverlayCaption.fromMap(rawCaption).run {
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
        NOverlayCaption.fromMap(rawSubCaption).run {
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
        val nPoint = NPoint.fromMap(rawNPoint)
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
        result(circleOverlay.bounds.toMap())
    }

    /* ----- Ground Overlay handler ----- */

    override fun setBounds(groundOverlay: GroundOverlay, rawBounds: Any) {
        groundOverlay.bounds = rawBounds.asLatLngBounds()
    }

    override fun setImage(groundOverlay: GroundOverlay, rawNOverlayImage: Any) {
        val nOverlayImage = NOverlayImage.fromMap(rawNOverlayImage)
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

    override fun getBounds(
        polygonOverlay: PolygonOverlay,
        success: (bounds: Map<String, Any>) -> Unit,
    ) {
        success(polygonOverlay.bounds.toMap())
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
        success(polylineOverlay.bounds.toMap())
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
        val nOverlayImage = NOverlayImage.fromMap(rawNOverlayImage)
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
        success(pathOverlay.bounds.toMap())
    }

    /* ----- Multipart Path Overlay handler ----- */

    override fun setPaths(multipartPathOverlay: MultipartPathOverlay, rawPaths: Any) {
        val paths = rawPaths.asList(NMultipartPath::fromMap)
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
        val nOverlayImage = NOverlayImage.fromMap(rawNOverlayImage)
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
        success(multipartPathOverlay.bounds.toMap())
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
        success(arrowheadPathOverlay.bounds.toMap())
    }
}

import NMapsMap
import Flutter

internal class OverlayController: OverlaySender, OverlayHandler, ArrowheadPathOverlayHandler, CircleOverlayHandler, GroundOverlayHandler, InfoWindowHandler, LocationOverlayHandler, MarkerHandler, MultipartPathOverlayHandler, PathOverlayHandler, PolygonOverlayHandler, PolylineOverlayHandler, ClusterMarkerHandler, ClusterableMarkerHandler {

    private let channel: FlutterMethodChannel

    init(channel: FlutterMethodChannel) {
        self.channel = channel
        channel.setMethodCallHandler(handler)
    }
    
    func initializeLocationOverlay(overlay: NMFLocationOverlay) {
        saveOverlay(overlay: overlay, info: NOverlayInfo.locationOverlayInfo)
    }

    /* ----- sender ----- */
    func onOverlayTapped(info: NOverlayInfo) {
        let query = NOverlayQuery(info: info, methodName: onTapName).query
        channel.invokeMethod(query, arguments: nil)
    }

    /* ----- overlay storage ----- */

    private var overlays: Dictionary<NOverlayInfo, NMFOverlay> = [:]

    func saveOverlay(overlay: NMFOverlay, info: NOverlayInfo) {
        info.saveAtOverlay(overlay)
        detachOverlay(info: info)
        overlays[info] = overlay
    }

    func hasOverlay(info: NOverlayInfo) -> Bool {
        overlays.contains { (key, _) in
            key == info
        }
    }

    private func getOverlay(info: NOverlayInfo) -> NMFOverlay? {
        overlays[info]
    }

    func deleteOverlay(info: NOverlayInfo) {
        detachOverlay(info: info)
        overlays.removeValue(forKey: info)
    }

    func deleteOverlay(_ key: NOverlayInfo, _ value: NMFOverlay) {
        detachOverlay(value)
        overlays.removeValue(forKey: key)
    }

    private func detachOverlay(info: NOverlayInfo) {
        if info.type == .locationOverlay {
            return
        }
        let overlay = getOverlay(info: info)
        if let overlay = overlay {
            detachOverlay(overlay)
        }
    }

    private func detachOverlay(_ overlay: NMFOverlay) {
        if let infoWindow = overlay as? NMFInfoWindow {
            infoWindow.close()
        } else {
            overlay.mapView = nil
        }
    }

    func clearOverlays() {
        filteredOverlays({ $0.type != .locationOverlay }).forEach(deleteOverlay)
    }

    func clearOverlays(type: NOverlayType) {
        filteredOverlays({ $0.type == type }).forEach(deleteOverlay)
    }

    private func filteredOverlays(_ predicate: (_ info: NOverlayInfo) -> Bool) -> Dictionary<NOverlayInfo, NMFOverlay> {
        overlays.filter { key, value in
            predicate(key)
        }
    }

    /* ----- handler ----- */

    private func handler(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let query = NOverlayQuery.fromQuery(call.method)
        let overlay = getOverlay(info: query.info)

        guard let overlay else {
            if (query.info.type == .clusterableMarker) { return }
            result(FlutterError(code: "overlay_not_found", message: call.method, details: nil))
            return
        }

        let isInvokedOnCommonOverlay =
                handleOverlay(overlay: overlay, method: query.methodName, arg: call.arguments, result: result)

        if !isInvokedOnCommonOverlay {
            var overlayHandleFunc: (NMFOverlay, String, Any?, @escaping FlutterResult) -> ()
            switch query.info.type {
            case .marker: overlayHandleFunc = handleMarker
            case .infoWindow: overlayHandleFunc = handleInfoWindow
            case .circleOverlay: overlayHandleFunc = handleCircleOverlay
            case .groundOverlay: overlayHandleFunc = handleGroundOverlay
            case .polygonOverlay:overlayHandleFunc = handlePolygonOverlay
            case .polylineOverlay: overlayHandleFunc = handlePolylineOverlay
            case .pathOverlay: overlayHandleFunc = handlePathOverlay
            case .multipartPathOverlay: overlayHandleFunc = handleMultipartPathOverlay
            case .arrowheadPathOverlay:overlayHandleFunc = handleArrowheadPathOverlay
            case .locationOverlay: overlayHandleFunc = handleLocationOverlay
            case .clusterableMarker: overlayHandleFunc = handleClusterableMarker
            }
            overlayHandleFunc(overlay, query.methodName, call.arguments, result)
        }
    }

    /* ----- All Overlay handler ----- */
    func getZIndex(_ overlay: NMFOverlay, success: (Int) -> ()) {
        success(overlay.zIndex)
    }

    func setZIndex(_ overlay: NMFOverlay, rawZIndex: Any) {
        overlay.zIndex = asInt(rawZIndex)
    }

    func setGlobalZIndex(_ overlay: NMFOverlay, rawGlobalZIndex: Any) {
        overlay.globalZIndex = asInt(rawGlobalZIndex)
    }

    func setIsVisible(_ overlay: NMFOverlay, rawIsVisible: Any) {
        overlay.hidden = !asBool(rawIsVisible)
    }

    func setMinZoom(_ overlay: NMFOverlay, rawMinZoom: Any) {
        overlay.minZoom = asDouble(rawMinZoom)
    }

    func setMaxZoom(_ overlay: NMFOverlay, rawMaxZoom: Any) {
        overlay.maxZoom = asDouble(rawMaxZoom)
    }

    func setIsMinZoomInclusive(_ overlay: NMFOverlay, rawIsMinZoomInclusive: Any) {
        overlay.isMinZoomInclusive = asBool(rawIsMinZoomInclusive)
    }

    func setIsMaxZoomInclusive(_ overlay: NMFOverlay, rawIsMaxZoomInclusive: Any) {
        overlay.isMaxZoomInclusive = asBool(rawIsMaxZoomInclusive)
    }

    func performClick(_ overlay: NMFOverlay, success: (Any?) -> ()) {
        if let touchHandler = overlay.touchHandler {
            _ = touchHandler(overlay)
            success(nil)
        }
    }
    
    func setHasOnTapListener(_ overlay: NMFOverlay, rawHasOnTapListener: Any) {
        let hasOnTapListener = asBool(rawHasOnTapListener)
        if hasOnTapListener {
            overlay.touchHandler = { [weak self] overlay in
                self?.onOverlayTapped(info: NOverlayInfo.fromOverlay(overlay))
                return true
            }
        } else {
            overlay.touchHandler = nil
        }
    }

    /* ----- LocationOverlay handler ----- */

    func setAnchor(_ overlay: NMFLocationOverlay, rawNPoint: Any) {
        overlay.anchor = NPoint.fromMessageable(rawNPoint).cgPoint
    }

    func getBearing(_ overlay: NMFLocationOverlay, success: (Double) -> ()) {
        success(overlay.heading)
    }

    func setBearing(_ overlay: NMFLocationOverlay, rawBearing: Any) {
        overlay.heading = asCGFloat(rawBearing)
    }

    func setCircleColor(_ overlay: NMFLocationOverlay, rawColor: Any) {
        overlay.circleColor = asUIColor(rawColor)
    }

    func setCircleOutlineColor(_ overlay: NMFLocationOverlay, rawColor: Any) {
        overlay.circleOutlineColor = asUIColor(rawColor)
    }

    func setCircleOutlineWidth(_ overlay: NMFLocationOverlay, rawWidth: Any) {
        overlay.circleOutlineWidth = asCGFloat(rawWidth)
    }

    func setCircleRadius(_ overlay: NMFLocationOverlay, rawRadius: Any) {
        overlay.circleRadius = asCGFloat(rawRadius)
    }

    func setIcon(_ overlay: NMFLocationOverlay, rawNOverlayImage: Any) {
        overlay.icon = NOverlayImage.fromMessageable(rawNOverlayImage).overlayImage
    }

    func setIconSize(_ overlay: NMFLocationOverlay, rawSize: Any) {
        let size = NSize.fromMessageable(rawSize)
        overlay.iconWidth = size.width
        overlay.iconHeight = size.height
    }
    
    func setIconAlpha(_ overlay: NMFLocationOverlay, rawAlpha: Any) {
        overlay.iconAlpha = asCGFloat(rawAlpha)
    }

    func getPosition(_ overlay: NMFLocationOverlay, success: (Dictionary<String, Any>) -> ()) {
        success(overlay.location.toMessageable())
    }

    func setPosition(_ overlay: NMFLocationOverlay, rawLatLng: Any) {
        overlay.location = asLatLng(rawLatLng)
    }

    func setSubAnchor(_ overlay: NMFLocationOverlay, rawNPoint: Any) {
        overlay.subAnchor = NPoint.fromMessageable(rawNPoint).cgPoint
    }

    func setSubIcon(_ overlay: NMFLocationOverlay, rawNOverlayImage: Any?) {
        overlay.subIcon = castOrNull(rawNOverlayImage, caster: NOverlayImage.fromMessageable)?.overlayImage
    }

    func setSubIconSize(_ overlay: NMFLocationOverlay, rawSize: Any) {
        let size = NSize.fromMessageable(rawSize)
        overlay.subIconWidth = size.width
        overlay.subIconHeight = size.height
    }
    
    func setSubIconAlpha(_ overlay: NMFLocationOverlay, rawAlpha: Any) {
        overlay.subIconAlpha = asCGFloat(rawAlpha)
    }

    /* ----- Marker handler ----- */
    func hasOpenInfoWindow(_ marker: NMFMarker, success: (Bool) -> ()) {
        success(marker.infoWindow != nil)
    }

    func openInfoWindow(_ marker: NMFMarker, rawInfoWindow: Any, rawAlign: Any, success: (Any?) -> ()) {
        var nInfoWindow = NInfoWindow.fromMessageable(rawInfoWindow)
        nInfoWindow.setCommonProperties(rawArgs: asDict(rawInfoWindow))
        let infoWindow = saveOverlayWithAddable(creator: nInfoWindow) as! NMFInfoWindow

        let align = try! asAlign(rawAlign)
        infoWindow.open(with: marker, alignType: align)
        success(nil)
    }

    func setPosition(_ marker: NMFMarker, rawPosition: Any) {
        marker.position = asLatLng(rawPosition)
    }

    func setIcon(_ marker: NMFMarker, rawIcon: Any?) {
        marker.iconImage = castOrNull(rawIcon, caster: NOverlayImage.fromMessageable)?.overlayImage ?? NMF_MARKER_IMAGE_GREEN
    }

    func setIconTintColor(_ marker: NMFMarker, rawIconTintColor: Any) {
        marker.iconTintColor = asUIColor(rawIconTintColor)
    }

    func setAlpha(_ marker: NMFMarker, rawAlpha: Any) {
        marker.alpha = asCGFloat(rawAlpha)
    }

    func setAngle(_ marker: NMFMarker, rawAngle: Any) {
        marker.angle = asCGFloat(rawAngle)
    }

    func setAnchor(_ marker: NMFMarker, rawNPoint: Any) {
        marker.anchor = NPoint.fromMessageable(rawNPoint).cgPoint
    }

    func setSize(_ marker: NMFMarker, rawSize: Any) {
        let size = NSize.fromMessageable(rawSize)
        marker.width = size.width
        marker.height = size.height
    }

    func setCaption(_ marker: NMFMarker, rawCaption: Any) {
        let caption = NOverlayCaption.fromMessageable(rawCaption)
        marker.captionText = caption.text
        marker.captionTextSize = caption.textSize
        marker.captionColor = caption.color
        marker.captionHaloColor = caption.haloColor
        marker.captionMinZoom = caption.minZoom
        marker.captionMaxZoom = caption.maxZoom
        marker.captionRequestedWidth = caption.requestWidth
    }

    func setSubCaption(_ marker: NMFMarker, rawSubCaption: Any) {
        let caption = NOverlayCaption.fromMessageable(rawSubCaption)
        marker.subCaptionText = caption.text
        marker.subCaptionTextSize = caption.textSize
        marker.subCaptionColor = caption.color
        marker.subCaptionHaloColor = caption.haloColor
        marker.subCaptionMinZoom = caption.minZoom
        marker.subCaptionMaxZoom = caption.maxZoom
        marker.subCaptionRequestedWidth = caption.requestWidth
    }

    func setCaptionAligns(_ marker: NMFMarker, rawCaptionAligns: Any) {
        marker.captionAligns = asArr(rawCaptionAligns, elementCaster: asAlign)
    }

    func setCaptionOffset(_ marker: NMFMarker, rawDpOffset: Any) {
        marker.captionOffset = asCGFloat(rawDpOffset)
    }

    func setIsCaptionPerspectiveEnabled(_ marker: NMFMarker, rawCaptionPerspectiveEnabled: Any) {
        marker.captionPerspectiveEnabled = asBool(rawCaptionPerspectiveEnabled)
    }

    func setIsIconPerspectiveEnabled(_ marker: NMFMarker, rawIconPerspectiveEnabled: Any) {
        marker.iconPerspectiveEnabled = asBool(rawIconPerspectiveEnabled)
    }

    func setIsFlat(_ marker: NMFMarker, rawFlat: Any) {
        marker.isFlat = asBool(rawFlat)
    }

    func setIsForceShowCaption(_ marker: NMFMarker, rawForceShowCaption: Any) {
        marker.isForceShowCaption = asBool(rawForceShowCaption)
    }

    func setIsForceShowIcon(_ marker: NMFMarker, rawForceShowIcon: Any) {
        marker.isForceShowIcon = asBool(rawForceShowIcon)
    }

    func setIsHideCollidedCaptions(_ marker: NMFMarker, rawHideCollidedCaptions: Any) {
        marker.isHideCollidedCaptions = asBool(rawHideCollidedCaptions)
    }

    func setIsHideCollidedMarkers(_ marker: NMFMarker, rawHideCollidedMarkers: Any) {
        marker.isHideCollidedMarkers = asBool(rawHideCollidedMarkers)
    }

    func setIsHideCollidedSymbols(_ marker: NMFMarker, rawHideCollidedSymbols: Any) {
        marker.isHideCollidedSymbols = asBool(rawHideCollidedSymbols)
    }

    /* ----- InfoWindow handler ----- */
    func setText(_ infoWindow: NMFInfoWindow, rawText: Any) {
        infoWindow.dataSource = NInfoWindow.createTextSource(asString(rawText))
    }

    func setAnchor(_ infoWindow: NMFInfoWindow, rawNPoint: Any) {
        infoWindow.anchor = NPoint.fromMessageable(rawNPoint).cgPoint
    }

    func setAlpha(_ infoWindow: NMFInfoWindow, rawAlpha: Any) {
        infoWindow.alpha = asCGFloat(rawAlpha)
    }

    func setPosition(_ infoWindow: NMFInfoWindow, rawPosition: Any) {
        infoWindow.position = asLatLng(rawPosition)
    }

    func setOffsetX(_ infoWindow: NMFInfoWindow, rawOffsetX: Any) {
        infoWindow.offsetX = asRoundInt(rawFloat: rawOffsetX)
    }

    func setOffsetY(_ infoWindow: NMFInfoWindow, rawOffsetY: Any) {
        infoWindow.offsetY = asRoundInt(rawFloat: rawOffsetY)
    }

    func close(_ infoWindow: NMFInfoWindow) {
        infoWindow.close()
    }

    /* ----- Circle Overlay handler ----- */
    func setCenter(_ circleOverlay: NMFCircleOverlay, rawCenter: Any) {
        circleOverlay.center = asLatLng(rawCenter)
    }

    func setRadius(_ circleOverlay: NMFCircleOverlay, rawRadius: Any) {
        circleOverlay.radius = asDouble(rawRadius)
    }

    func setColor(_ circleOverlay: NMFCircleOverlay, rawColor: Any) {
        circleOverlay.fillColor = asUIColor(rawColor)
    }

    func setOutlineColor(_ circleOverlay: NMFCircleOverlay, rawOutlineColor: Any) {
        circleOverlay.outlineColor = asUIColor(rawOutlineColor)
    }

    func setOutlineWidth(_ circleOverlay: NMFCircleOverlay, rawOutlineWidth: Any) {
        circleOverlay.outlineWidth = asDouble(rawOutlineWidth)
    }

    func getBounds(_ circleOverlay: NMFCircleOverlay, result: (Dictionary<String, Any>) -> ()) {
        result(circleOverlay.bounds.toMessageable())
    }

    /* ----- Ground Overlay handler ----- */
    func setBounds(_ groundOverlay: NMFGroundOverlay, rawBounds: Any) {
        groundOverlay.bounds = asLatLngBounds(rawBounds)
    }

    func setImage(_ groundOverlay: NMFGroundOverlay, rawNOverlayImage: Any) {
        groundOverlay.overlayImage = NOverlayImage.fromMessageable(rawNOverlayImage).overlayImage
    }

    func setAlpha(_ groundOverlay: NMFGroundOverlay, rawAlpha: Any) {
        groundOverlay.alpha = asCGFloat(rawAlpha)
    }

    /* ----- Polygon Overlay handler ----- */
    func setCoords(_ polygonOverlay: NMFPolygonOverlay, rawCoords: Any) {
        polygonOverlay.polygon.exteriorRing = asNMGLineString(rawArr: rawCoords)
    }

    func setColor(_ polygonOverlay: NMFPolygonOverlay, rawColor: Any) {
        polygonOverlay.fillColor = asUIColor(rawColor)
    }

    func setHoles(_ polygonOverlay: NMFPolygonOverlay, rawHoles: Any) {
        let exteriorRing = polygonOverlay.polygon.exteriorRing
        let willInteriorRing = asArr(rawHoles, elementCaster: asNMGLineString)
        polygonOverlay.polygon = NMGPolygon(ring: exteriorRing, interiorRings: willInteriorRing)
    }

    func setOutlineColor(_ polygonOverlay: NMFPolygonOverlay, rawColor: Any) {
        polygonOverlay.outlineColor = asUIColor(rawColor)
    }

    func setOutlineWidth(_ polygonOverlay: NMFPolygonOverlay, rawWidthDp: Any) {
        polygonOverlay.outlineWidth = UInt(asRoundInt(rawFloat: rawWidthDp))
    }
    
    func setOutlinePattern(_ polygonOverlay: NMFPolygonOverlay, patternList: Any) {
        polygonOverlay.outlinePattern = asArr(patternList) { pattern in
            NSNumber(value: DisplayUtil.dpToPx(dp: asDouble(pattern)))
        }
    }

    func getBounds(_ polygonOverlay: NMFPolygonOverlay, success: (Dictionary<String, Any>) -> ()) {
        let ring = polygonOverlay.polygon.exteriorRing
        let bounds = NMGLatLngBounds(latLngs: ring.latLngPoints)
        success(bounds.toMessageable())
    }

    /* ----- Polyline Overlay handler ----- */
    func setCoords(_ polylineOverlay: NMFPolylineOverlay, rawCoords: Any) {
        polylineOverlay.line = asNMGLineString(rawArr: rawCoords)
    }

    func setColor(_ polylineOverlay: NMFPolylineOverlay, rawColor: Any) {
        polylineOverlay.color = asUIColor(rawColor)
    }

    func setWidth(_ polylineOverlay: NMFPolylineOverlay, rawWidth: Any) {
        polylineOverlay.width = asCGFloat(rawWidth)
    }

    func setLineCap(_ polylineOverlay: NMFPolylineOverlay, rawLineCap: Any) {
        polylineOverlay.capType = asLineCap(rawLineCap)
    }

    func setLineJoin(_ polylineOverlay: NMFPolylineOverlay, rawLineJoin: Any) {
        polylineOverlay.joinType = asLineJoin(rawLineJoin)
    }

    func setPattern(_ polylineOverlay: NMFPolylineOverlay, patternList: Any) {
        polylineOverlay.pattern = asArr(patternList) { pattern in
            NSNumber(value: asDouble(pattern))
        }
    }

    func getBounds(_ polylineOverlay: NMFPolylineOverlay, success: (Dictionary<String, Any>) -> ()) {
        let bounds = NMGLatLngBounds(latLngs: polylineOverlay.line.latLngPoints)
        success(bounds.toMessageable())
    }

    /* ----- Path Overlay handler ----- */
    func setCoords(_ pathOverlay: NMFPath, rawCoords: Any) {
        pathOverlay.path = asNMGLineString(rawArr: rawCoords)
    }

    func setWidth(_ pathOverlay: NMFPath, rawWidthDp: Any) {
        pathOverlay.width = asCGFloat(rawWidthDp)
    }

    func setColor(_ pathOverlay: NMFPath, rawColor: Any) {
        pathOverlay.color = asUIColor(rawColor)
    }

    func setOutlineWidth(_ pathOverlay: NMFPath, rawWidthDp: Any) {
        pathOverlay.outlineWidth = asCGFloat(rawWidthDp)
    }

    func setOutlineColor(_ pathOverlay: NMFPath, rawColor: Any) {
        pathOverlay.outlineColor = asUIColor(rawColor)
    }

    func setPassedColor(_ pathOverlay: NMFPath, rawColor: Any) {
        pathOverlay.passedColor = asUIColor(rawColor)
    }

    func setPassedOutlineColor(_ pathOverlay: NMFPath, rawColor: Any) {
        pathOverlay.passedOutlineColor = asUIColor(rawColor)
    }

    func setProgress(_ pathOverlay: NMFPath, rawProgress: Any) {
        pathOverlay.progress = asDouble(rawProgress)
    }

    func setPatternImage(_ pathOverlay: NMFPath, rawNOverlayImage: Any) {
        pathOverlay.patternIcon = NOverlayImage.fromMessageable(rawNOverlayImage).overlayImage
    }

    func setPatternInterval(_ pathOverlay: NMFPath, rawInterval: Any) {
        pathOverlay.patternInterval = UInt(asRoundInt(rawFloat: rawInterval))
    }

    func setIsHideCollidedCaptions(_ pathOverlay: NMFPath, rawFlag: Any) {
        pathOverlay.isHideCollidedCaptions = asBool(rawFlag)
    }

    func setIsHideCollidedMarkers(_ pathOverlay: NMFPath, rawFlag: Any) {
        pathOverlay.isHideCollidedMarkers = asBool(rawFlag)
    }

    func setIsHideCollidedSymbols(_ pathOverlay: NMFPath, rawFlag: Any) {
        pathOverlay.isHideCollidedSymbols = asBool(rawFlag)
    }

    func getBounds(_ pathOverlay: NMFPath, success: (Dictionary<String, Any>) -> ()) {
        let bounds = NMGLatLngBounds(latLngs: pathOverlay.path.latLngPoints)
        success(bounds.toMessageable())
    }

    /* ----- Multipart Path Overlay handler ----- */

    func setPaths(_ multipartPathOverlay: NMFMultipartPath, rawPaths: Any) {
        let nMultipartPaths = asArr(rawPaths, elementCaster: NMultipartPath.fromMessageable)
        nMultipartPaths.applyLineAndColor(
                linePartsFun: { multipartPathOverlay.lineParts = $0 },
                colorPartsFun: { multipartPathOverlay.colorParts = $0 }
        )
    }

    func setWidth(_ multipartPathOverlay: NMFMultipartPath, rawWidthDp: Any) {
        multipartPathOverlay.width = asCGFloat(rawWidthDp)
    }

    func setOutlineWidth(_ multipartPathOverlay: NMFMultipartPath, rawWidth: Any) {
        multipartPathOverlay.outlineWidth = asCGFloat(rawWidth)
    }

    func setPatternImage(_ multipartPathOverlay: NMFMultipartPath, rawNOverlayImage: Any) {
        multipartPathOverlay.patternIcon = NOverlayImage.fromMessageable(rawNOverlayImage).overlayImage
    }

    func setPatternInterval(_ multipartPathOverlay: NMFMultipartPath, rawInterval: Any) {
        multipartPathOverlay.patternInterval = UInt(asRoundInt(rawFloat: rawInterval))
    }

    func setProgress(_ multipartPathOverlay: NMFMultipartPath, rawProgress: Any) {
        multipartPathOverlay.progress = asDouble(rawProgress)
    }

    func setIsHideCollidedCaptions(_ multipartPathOverlay: NMFMultipartPath, rawFlag: Any) {
        multipartPathOverlay.isHideCollidedCaptions = asBool(rawFlag)
    }

    func setIsHideCollidedMarkers(_ multipartPathOverlay: NMFMultipartPath, rawFlag: Any) {
        multipartPathOverlay.isHideCollidedMarkers = asBool(rawFlag)
    }

    func setIsHideCollidedSymbols(_ multipartPathOverlay: NMFMultipartPath, rawFlag: Any) {
        multipartPathOverlay.isHideCollidedSymbols = asBool(rawFlag)
    }

    func getBounds(_ multipartPathOverlay: NMFMultipartPath, success: (Dictionary<String, Any>) -> ()) {
        let bounds = NMGLatLngBounds(latLngs: multipartPathOverlay.lineParts.flatMap {
            $0.latLngPoints
        })
        success(bounds.toMessageable())
    }

    /* ----- ArrowHeadPath Overlay handler ----- */
    func setCoords(_ arrowheadPathOverlay: NMFArrowheadPath, rawCoords: Any) {
        arrowheadPathOverlay.points = asArr(rawCoords, elementCaster: asLatLng)
    }

    func setWidth(_ arrowheadPathOverlay: NMFArrowheadPath, rawWidth: Any) {
        arrowheadPathOverlay.width = asCGFloat(rawWidth)
    }

    func setColor(_ arrowheadPathOverlay: NMFArrowheadPath, rawColor: Any) {
        arrowheadPathOverlay.color = asUIColor(rawColor)
    }

    func setOutlineWidth(_ arrowheadPathOverlay: NMFArrowheadPath, rawWidth: Any) {
        arrowheadPathOverlay.outlineWidth = asCGFloat(rawWidth)
    }

    func setOutlineColor(_ arrowheadPathOverlay: NMFArrowheadPath, rawColor: Any) {
        arrowheadPathOverlay.outlineColor = asUIColor(rawColor)
    }

    func setElevation(_ arrowheadPathOverlay: NMFArrowheadPath, rawElevation: Any) {
        arrowheadPathOverlay.elevation = asCGFloat(rawElevation)
    }

    func setHeadSizeRatio(_ arrowheadPathOverlay: NMFArrowheadPath, rawRatio: Any) {
        arrowheadPathOverlay.headSizeRatio = asCGFloat(rawRatio)
    }

    func getBounds(_ arrowheadPathOverlay: NMFArrowheadPath, success: (Dictionary<String, Any>) -> ()) {
        let bounds = NMGLatLngBounds(latLngs: arrowheadPathOverlay.points)
        success(bounds.toMessageable())
    }
        
    /* ----- Cluster Marker handler ----- */
        
    func syncClusterMarker(_ marker: NMFMarker, rawClusterMarker: Any, success: (Any?) -> ()) {
        let dictData = asDict(rawClusterMarker)
        let clusterMarker: NMarker = asAddableOverlayFromMessageableCorrector(json: dictData, creator: NMarker.fromMessageable) as! NMarker
        _ = clusterMarker.applyAtRawOverlay(marker)
        let hasCustomOnTapListener = castOrNull(dictData[hasOnTapListenerName], caster: asBool) == true
        if (hasCustomOnTapListener) {
            marker.touchHandler = { [weak self] overlay in
                self?.onOverlayTapped(info: NOverlayInfo.fromOverlay(overlay))
                return true
            }
        }
        marker.hidden = false
        success(nil)
    }

    /*
        --- deinit ---
    */

    func removeChannel() {
        channel.setMethodCallHandler(nil)
    }
}

internal extension  NaverMapOptionApplier {
    func applyOptions(args: Dictionary<String, Any>) throws {
        for (funcName, arg) in args {
            let fun = ApplyUtil.optionApplyFuncMap[funcName]?(self)
            if let fun = fun {
                fun(arg)
            } else {
                throw NSError()
            }
        }
    }
}

internal class ApplyUtil {
    static let optionApplyFuncMap: Dictionary<String, (NaverMapOptionApplier) -> (Any) -> Void> = [
        "initialCameraPosition": {
            $0.setInitialCameraPosition
        },
        "extent": {
            $0.setExtent
        },
        "mapType": {
            $0.setMapType
        },
        "liteModeEnable": {
            $0.setLiteModeEnable
        },
        "nightModeEnable": {
            $0.setNightModeEnable
        },
        "indoorEnable": {
            $0.setIndoorEnable
        },
        "activeLayerGroups": {
            $0.setActiveLayerGroups
        },
        "buildingHeight": {
            $0.setBuildingHeight
        },
        "lightness": {
            $0.setLightness
        },
        "symbolScale": {
            $0.setSymbolScale
        },
        "symbolPerspectiveRatio": {
            $0.setSymbolPerspectiveRatio
        },
        "indoorFocusRadius": {
            $0.setIndoorFocusRadius
        },
        "pickTolerance": {
            $0.setPickTolerance
        },
        "rotationGesturesEnable": {
            $0.setRotationGesturesEnable
        },
        "scrollGesturesEnable": {
            $0.setScrollGesturesEnable
        },
        "tiltGesturesEnable": {
            $0.setTiltGesturesEnable
        },
        "zoomGesturesEnable": {
            $0.setZoomGesturesEnable
        },
        "stopGesturesEnable": {
            $0.setStopGesturesEnable
        },
        "scrollGesturesFriction": {
            $0.setScrollGesturesFriction
        },
        "zoomGesturesFriction": {
            $0.setZoomGesturesFriction
        },
        "rotationGesturesFriction": {
            $0.setRotationGesturesFriction
        },
        "consumeSymbolTapEvents": { (_: NaverMapOptionApplier) in
            { (a: Any) in
                /** @see NaverMapView.setMapTapListener method */
            }
        },
        "scaleBarEnable": {
            $0.setScaleBarEnable
        },
        "indoorLevelPickerEnable": {
            $0.setIndoorLevelPickerEnable
        },
        "locationButtonEnable": {
            $0.setLocationButtonEnable
        },
        "logoClickEnable": {
            $0.setLogoClickEnable
        },
        "logoAlign": {
            $0.setLogoAlign
        },
        "logoMargin": {
            $0.setLogoMargin
        },
        "contentPadding": {
            $0.setContentPadding
        },
        "minZoom": {
            $0.setMinZoom
        },
        "maxZoom": {
            $0.setMaxZoom
        },
        "maxTilt": {
            $0.setMaxTilt
        },
        "locale": {
            $0.setLocale
        },
    ]
}

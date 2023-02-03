import NMapsMap

class NaverMapApplierImpl: NaverMapOptionApplier {
    private let naverMapView: NMFNaverMapView
    private var mapView: NMFMapView {
        get {
            naverMapView.mapView
        }
    }

    init(_ mapView: NMFNaverMapView) {
        naverMapView = mapView
    }

    func setInitialCameraPosition(_ rawPosition: Any) {
        // todo : 두번째부터는 적용되지 않도록 수정 필요. (init 이니까)
//        mapView.cameraPosition
    }

    func setExtent(_ rawLatLngBounds: Any) {
//        mapView.extent
    }

    func setMapType(_ rawMapType: Any) {

    }

    func setLiteModeEnable(_ rawEnable: Any) {
        mapView.liteModeEnabled = asBool(rawEnable)
    }

    func setNightModeEnable(_ rawEnable: Any) {
        mapView.isNightModeEnabled = asBool(rawEnable)
    }

    func setIndoorEnable(_ rawEnable: Any) {
        mapView.isIndoorMapEnabled = asBool(rawEnable)
    }

    func setActiveLayerGroups(_ rawLayerGroups: Any) {
    }

    func setBuildingHeight(_ rawHeight: Any) {
        mapView.buildingHeight = asFloat(rawHeight)
    }

    func setLightness(_ rawLightness: Any) {
        mapView.lightness = asCGFloat(rawLightness)
    }

    func setSymbolScale(_ rawScale: Any) {
        mapView.symbolScale = asCGFloat(rawScale)
    }

    func setSymbolPerspectiveRatio(_ rawRatio: Any) {
        mapView.symbolPerspectiveRatio = asCGFloat(rawRatio)
    }

    func setIndoorFocusRadius(_ rawDp: Any) {
        mapView.indoorFocusRadius = asDouble(rawDp)
    }

    func setPickTolerance(_ rawDp: Any) {
        mapView.pickTolerance = Int(asDouble(rawDp))
    }

    func setRotationGesturesEnable(_ rawEnable: Any) {
        mapView.isRotateGestureEnabled = asBool(rawEnable)
    }

    func setScrollGesturesEnable(_ rawEnable: Any) {
        mapView.isScrollGestureEnabled = asBool(rawEnable)
    }

    func setTiltGesturesEnable(_ rawEnable: Any) {
        mapView.isTiltGestureEnabled = asBool(rawEnable)
    }

    func setZoomGesturesEnable(_ rawEnable: Any) {
        mapView.isZoomGestureEnabled = asBool(rawEnable)
    }

    func setStopGesturesEnable(_ rawEnable: Any) {
        mapView.isStopGestureEnabled = asBool(rawEnable)
    }

    func setScrollGesturesFriction(_ rawFriction: Any) {
        mapView.scrollFriction = asCGFloat(rawFriction) // todo : 기본값 지정 필요 : -1
    }

    func setZoomGesturesFriction(_ rawFriction: Any) {
        mapView.zoomFriction = asCGFloat(rawFriction) // todo : 기본값 지정 필요 : -1
    }

    func setRotationGesturesFriction(_ rawFriction: Any) {
        mapView.rotateFriction = asCGFloat(rawFriction) // todo : 기본값 지정 필요 : -1
    }

    func setScaleBarEnable(_ rawEnable: Any) {
        naverMapView.showScaleBar = asBool(rawEnable)
    }

    func setIndoorLevelPickerEnable(_ rawEnable: Any) {
        naverMapView.showIndoorLevelPicker = asBool(rawEnable)
    }

    func setLocationButtonEnable(_ rawEnable: Any) {
        naverMapView.showLocationButton = asBool(rawEnable)
    }

    func setLogoClickEnable(_ rawEnable: Any) {
        mapView.logoInteractionEnabled = asBool(true)
    }

    func setLogoAlign(_ rawAlign: Any) {
    }

    func setLogoMargin(_ rawEdgeInsets: Any) {
    }

    func setContentPadding(_ rawEdgeInsets: Any) {
    }

    func setMinZoom(_ rawLevel: Any) {
        mapView.minZoomLevel = asDouble(rawLevel)
    }

    func setMaxZoom(_ rawLevel: Any) {
        mapView.maxZoomLevel = asDouble(rawLevel)
    }

    func setMaxTilt(_ rawTilt: Any) {
        mapView.maxTilt = asDouble(rawTilt)
    }

    func setLocale(_ rawLocale: Any) {
    }

    func setUseGLSurfaceView(_ rawUseSurface: Any) {
        // not support on iOS
    }
}

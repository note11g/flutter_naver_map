import NMapsMap

internal class NaverMapApplierImpl: NaverMapOptionApplier {
    private let isFirst: Bool
    private let naverMapView: NMFNaverMapView
    private var mapView: NMFMapView {
        naverMapView.mapView
    }

    init(_ mapView: NMFNaverMapView, isFirst: Bool) {
        naverMapView = mapView
        self.isFirst = isFirst
    }

    func setInitialCameraPosition(_ rawPosition: Any) {
        if (!isFirst) {
            return
        }
        let cameraUpdate = NMFCameraUpdate(position: asCameraPosition(rawPosition))
        cameraUpdate.animationDuration = 0
        mapView.moveCamera(cameraUpdate)
    }

    func setExtent(_ rawLatLngBounds: Any) {
        mapView.extent = asLatLngBounds(rawLatLngBounds)
    }

    func setMapType(_ rawMapType: Any) {
        mapView.mapType = asMapType(rawMapType)
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
        let layerGroups = NLayerGroups.fromRawArr(rawArr: rawLayerGroups)
        layerGroups.useWithEnableAndDisableGroups { enableGroups, disableGroups in
            enableGroups.forEach {
                mapView.setLayerGroup($0, isEnabled: true)
            }
            disableGroups.forEach {
                mapView.setLayerGroup($0, isEnabled: false)
            }
        }
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
        mapView.pickTolerance = asRoundInt(rawFloat: rawDp)
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
        mapView.scrollFriction = asCGFloat(rawFriction)
    }

    func setZoomGesturesFriction(_ rawFriction: Any) {
        mapView.zoomFriction = asCGFloat(rawFriction)
    }

    func setRotationGesturesFriction(_ rawFriction: Any) {
        mapView.rotateFriction = asCGFloat(rawFriction)
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
        mapView.logoInteractionEnabled = asBool(rawEnable)
    }

    func setLogoAlign(_ rawAlign: Any) {
        mapView.logoAlign = asLogoAlign(rawAlign)
    }

    func setLogoMargin(_ rawEdgeInsets: Any) {
        mapView.logoMargin = NEdgeInsets.fromMessageable(rawEdgeInsets).uiEdgeInsets
    }

    func setContentPadding(_ rawEdgeInsets: Any) {
        mapView.contentInset = NEdgeInsets.fromMessageable(rawEdgeInsets).uiEdgeInsets
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
        mapView.locale = NLocale.fromMessageable(rawLocale)?.localeStr
    }
}

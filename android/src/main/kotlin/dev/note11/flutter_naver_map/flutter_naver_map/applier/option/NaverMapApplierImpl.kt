package dev.note11.flutter_naver_map.flutter_naver_map.applier.option

import com.naver.maps.map.CameraUpdate
import com.naver.maps.map.NaverMap
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asBoolean
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asFloat
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLatLngBounds
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLogoAlign
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asMapType
import dev.note11.flutter_naver_map.flutter_naver_map.model.base.NEdgeInsets
import dev.note11.flutter_naver_map.flutter_naver_map.model.base.NLocale
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.NLayerGroups
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil

class NaverMapApplierImpl(
    private val naverMap: NaverMap,
    private val customStyleCallback: NaverMap.OnCustomStyleLoadCallback? = null,
) : NaverMapOptionApplier {

    override fun setInitialCameraPosition(rawPosition: Any) = Unit

    override fun setExtent(rawLatLngBounds: Any?) {
        naverMap.extent = rawLatLngBounds?.asLatLngBounds()
    }

    override fun setMapType(rawMapType: Any) {
        naverMap.mapType = rawMapType.asMapType()
    }

    override fun setLiteModeEnable(rawEnable: Any) {
        naverMap.isLiteModeEnabled = rawEnable.asBoolean()
    }

    override fun setNightModeEnable(rawEnable: Any) {
        naverMap.isNightModeEnabled = rawEnable.asBoolean()
    }

    override fun setIndoorEnable(rawEnable: Any) {
        naverMap.isIndoorEnabled = rawEnable.asBoolean()
    }

    override fun setActiveLayerGroups(rawLayerGroups: Any) {
        val layerGroups = NLayerGroups.fromRawList(rawLayerGroups)
        layerGroups.useWithEnableAndDisableGroups { enableGroups, disableGroups ->
            enableGroups.forEach { naverMap.setLayerGroupEnabled(it, true) }
            disableGroups.forEach { naverMap.setLayerGroupEnabled(it, false) }
        }
    }

    override fun setBuildingHeight(rawHeight: Any) {
        naverMap.buildingHeight = rawHeight.asFloat()
    }

    override fun setLightness(rawLightness: Any) {
        naverMap.lightness = rawLightness.asFloat()
    }

    override fun setSymbolScale(rawScale: Any) {
        naverMap.symbolScale = rawScale.asFloat()
    }

    override fun setSymbolPerspectiveRatio(rawRatio: Any) {
        naverMap.symbolPerspectiveRatio = rawRatio.asFloat()
    }

    override fun setIndoorFocusRadius(rawDp: Any) {
        naverMap.indoorFocusRadius = DisplayUtil.dpToPx(rawDp.asDouble())
    }

    override fun setPickTolerance(rawDp: Any) {
        naverMap.uiSettings.pickTolerance = DisplayUtil.dpToPx(rawDp.asDouble())
    }

    override fun setRotationGesturesEnable(rawEnable: Any) {
        naverMap.uiSettings.isRotateGesturesEnabled = rawEnable.asBoolean()
    }

    override fun setScrollGesturesEnable(rawEnable: Any) {
        naverMap.uiSettings.isScrollGesturesEnabled = rawEnable.asBoolean()
    }

    override fun setTiltGesturesEnable(rawEnable: Any) {
        naverMap.uiSettings.isTiltGesturesEnabled = rawEnable.asBoolean()
    }

    override fun setZoomGesturesEnable(rawEnable: Any) {
        naverMap.uiSettings.isZoomGesturesEnabled = rawEnable.asBoolean()
    }

    override fun setStopGesturesEnable(rawEnable: Any) {
        naverMap.uiSettings.isStopGesturesEnabled = rawEnable.asBoolean()
    }

    override fun setScrollGesturesFriction(rawFriction: Any) {
        val friction = rawFriction.asFloat()
        naverMap.uiSettings.scrollGesturesFriction = friction
    }

    override fun setZoomGesturesFriction(rawFriction: Any) {
        val friction = rawFriction.asFloat()
        naverMap.uiSettings.zoomGesturesFriction = friction
    }

    override fun setRotationGesturesFriction(rawFriction: Any) {
        val friction = rawFriction.asFloat()
        naverMap.uiSettings.rotateGesturesFriction = friction
    }

    override fun setIndoorLevelPickerEnable(rawEnable: Any) {
        naverMap.uiSettings.isIndoorLevelPickerEnabled = rawEnable.asBoolean()
    }

    override fun setLogoAlign(rawAlign: Any) {
        naverMap.uiSettings.logoGravity = rawAlign.asLogoAlign()
    }

    override fun setLogoMargin(rawEdgeInsets: Any) {
        val nEdgeInsets = NEdgeInsets.fromMessageable(rawEdgeInsets)
        nEdgeInsets.use(naverMap.uiSettings::setLogoMargin)
    }

    override fun setContentPadding(rawEdgeInsets: Any) {
        val nEdgeInsets = NEdgeInsets.fromMessageable(rawEdgeInsets)
        nEdgeInsets.use { l, t, r, b ->
            naverMap.setContentPadding(l, t, r, b, false, CameraUpdate.REASON_CONTENT_PADDING)
        }
    }

    override fun setMinZoom(rawLevel: Any) {
        naverMap.minZoom = rawLevel.asDouble()
    }

    override fun setMaxZoom(rawLevel: Any) {
        naverMap.maxZoom = rawLevel.asDouble()
    }

    override fun setMaxTilt(rawTilt: Any) {
        naverMap.maxTilt = rawTilt.asDouble()
    }

    override fun setLocale(rawLocale: Any) {
        val nLocale = NLocale.fromMessageable(rawLocale)
        naverMap.locale = nLocale?.toLocale()
    }

    override fun setCustomStyleId(rawCustomStyleId: Any?) {
        naverMap.setCustomStyleId(rawCustomStyleId?.toString(), customStyleCallback)
    }
}
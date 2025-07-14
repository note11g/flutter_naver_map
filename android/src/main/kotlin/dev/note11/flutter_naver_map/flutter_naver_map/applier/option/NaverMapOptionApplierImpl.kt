package dev.note11.flutter_naver_map.flutter_naver_map.applier.option

import com.naver.maps.map.NaverMapOptions
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asBoolean
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asDouble
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asFloat
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asCameraPosition
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLatLngBounds
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asLogoAlign
import dev.note11.flutter_naver_map.flutter_naver_map.converter.MapTypeConverter.asMapType
import dev.note11.flutter_naver_map.flutter_naver_map.model.base.NEdgeInsets
import dev.note11.flutter_naver_map.flutter_naver_map.model.base.NLocale
import dev.note11.flutter_naver_map.flutter_naver_map.model.map.NLayerGroups
import dev.note11.flutter_naver_map.flutter_naver_map.util.DisplayUtil

class NaverMapOptionApplierImpl(
    val options: NaverMapOptions,
) : NaverMapOptionApplier {

    override fun setInitialCameraPosition(rawPosition: Any) {
        val cameraPosition = rawPosition.asCameraPosition()
        options.camera(cameraPosition)
    }

    override fun setExtent(rawLatLngBounds: Any?) {
        options.extent(rawLatLngBounds?.asLatLngBounds())
    }

    override fun setMapType(rawMapType: Any) {
        options.mapType(rawMapType.asMapType())
    }

    override fun setLiteModeEnable(rawEnable: Any) {
        options.liteModeEnabled(rawEnable.asBoolean())
    }

    override fun setNightModeEnable(rawEnable: Any) {
        options.nightModeEnabled(rawEnable.asBoolean())
    }

    override fun setIndoorEnable(rawEnable: Any) {
        options.indoorEnabled(rawEnable.asBoolean())
    }

    override fun setActiveLayerGroups(rawLayerGroups: Any) {
        val layerGroups = NLayerGroups.fromRawList(rawLayerGroups)
        layerGroups.useWithEnableAndDisableGroups { enableGroups, disableGroups ->
            options.enabledLayerGroups(*enableGroups.toTypedArray())
            options.disabledLayerGroups(*disableGroups.toTypedArray())
        }
    }

    override fun setBuildingHeight(rawHeight: Any) {
        options.buildingHeight(rawHeight.asFloat())
    }

    override fun setLightness(rawLightness: Any) {
        options.lightness(rawLightness.asFloat())
    }

    override fun setSymbolScale(rawScale: Any) {
        options.symbolScale(rawScale.asFloat())
    }

    override fun setSymbolPerspectiveRatio(rawRatio: Any) {
        options.symbolPerspectiveRatio(rawRatio.asFloat())
    }

    override fun setIndoorFocusRadius(rawDp: Any) {
        DisplayUtil.dpToPx(rawDp.asDouble()).let { px -> options.indoorFocusRadius(px) }
    }

    override fun setPickTolerance(rawDp: Any) {
        DisplayUtil.dpToPx(rawDp.asDouble()).let { px -> options.pickTolerance(px) }
    }

    override fun setRotationGesturesEnable(rawEnable: Any) {
        options.rotateGesturesEnabled(rawEnable.asBoolean())
    }

    override fun setScrollGesturesEnable(rawEnable: Any) {
        options.scrollGesturesEnabled(rawEnable.asBoolean())
    }

    override fun setTiltGesturesEnable(rawEnable: Any) {
        options.tiltGesturesEnabled(rawEnable.asBoolean())
    }

    override fun setZoomGesturesEnable(rawEnable: Any) {
        options.zoomGesturesEnabled(rawEnable.asBoolean())
    }

    override fun setStopGesturesEnable(rawEnable: Any) {
        options.stopGesturesEnabled(rawEnable.asBoolean())
    }

    override fun setScrollGesturesFriction(rawFriction: Any) {
        val friction = rawFriction.asFloat()
        options.scrollGesturesFriction(friction)
    }

    override fun setZoomGesturesFriction(rawFriction: Any) {
        val friction = rawFriction.asFloat()
        options.zoomGesturesFriction(friction)
    }

    override fun setRotationGesturesFriction(rawFriction: Any) {
        val friction = rawFriction.asFloat()
        options.rotateGesturesFriction(friction)
    }

    override fun setIndoorLevelPickerEnable(rawEnable: Any) {
        options.indoorLevelPickerEnabled(rawEnable.asBoolean())
    }

    override fun setLogoAlign(rawAlign: Any) {
        options.logoGravity(rawAlign.asLogoAlign())
    }

    override fun setLogoMargin(rawEdgeInsets: Any) {
        val nEdgeInsets = NEdgeInsets.fromMessageable(rawEdgeInsets)
        nEdgeInsets.use(options::logoMargin)
    }

    override fun setContentPadding(rawEdgeInsets: Any) {
        val nEdgeInsets = NEdgeInsets.fromMessageable(rawEdgeInsets)
        nEdgeInsets.use(options::contentPadding)
    }

    override fun setMinZoom(rawLevel: Any) {
        options.minZoom(rawLevel.asDouble())
    }

    override fun setMaxZoom(rawLevel: Any) {
        options.maxZoom(rawLevel.asDouble())
    }

    override fun setMaxTilt(rawTilt: Any) {
        options.maxTilt(rawTilt.asDouble())
    }

    override fun setLocale(rawLocale: Any) {
        val nLocale = NLocale.fromMessageable(rawLocale)
        options.locale(nLocale?.toLocale())
    }

    override fun setCustomStyleId(rawCustomStyleId: Any?) {
        options.customStyleId(rawCustomStyleId?.toString())
    }
}
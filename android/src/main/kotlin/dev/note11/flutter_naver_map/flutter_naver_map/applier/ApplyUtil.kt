package dev.note11.flutter_naver_map.flutter_naver_map.applier

import dev.note11.flutter_naver_map.flutter_naver_map.applier.option.NaverMapOptionApplier
import dev.note11.flutter_naver_map.flutter_naver_map.view.NaverMapView

internal object ApplyUtil {
    internal fun <A : NaverMapOptionApplier> A.applyOptions(args: Map<String, Any>): A {
        for ((funcName, arg) in args) {
            try {
                val func = optionApplyFuncMap[funcName]?.invoke(this)
                func?.invoke(arg)
            } catch (e: NullPointerException) {
                throw NoSuchMethodException(
                    "No such method \"$funcName\". " +
                            "Please check the handling of this method."
                )
            }
        }
        return this
    }

    @Suppress("SuspiciousCallableReferenceInLambda") // Android Studio Linter Bugs. Fix in future. (PR Merged)
    private val optionApplyFuncMap: Map<String, ((NaverMapOptionApplier) -> ((Any) -> Unit))> =
        mapOf(
            "initialCameraPosition" to { it::setInitialCameraPosition },
            "extent" to { it::setExtent },
            "mapType" to { it::setMapType },
            "liteModeEnable" to { it::setLiteModeEnable },
            "nightModeEnable" to { it::setNightModeEnable },
            "indoorEnable" to { it::setIndoorEnable },
            "activeLayerGroups" to { it::setActiveLayerGroups },
            "buildingHeight" to { it::setBuildingHeight },
            "lightness" to { it::setLightness },
            "symbolScale" to { it::setSymbolScale },
            "symbolPerspectiveRatio" to { it::setSymbolPerspectiveRatio },
            "indoorFocusRadius" to { it::setIndoorFocusRadius },
            "pickTolerance" to { it::setPickTolerance },
            "rotationGesturesEnable" to { it::setRotationGesturesEnable },
            "scrollGesturesEnable" to { it::setScrollGesturesEnable },
            "tiltGesturesEnable" to { it::setTiltGesturesEnable },
            "zoomGesturesEnable" to { it::setZoomGesturesEnable },
            "stopGesturesEnable" to { it::setStopGesturesEnable },
            "scrollGesturesFriction" to { it::setScrollGesturesFriction },
            "zoomGesturesFriction" to { it::setZoomGesturesFriction },
            "rotationGesturesFriction" to { it::setRotationGesturesFriction },
            "consumeSymbolTapEvents" to { { /** @see NaverMapView.setMapTapListener method */ } },
            "scaleBarEnable" to { it::setScaleBarEnable },
            "indoorLevelPickerEnable" to { it::setIndoorLevelPickerEnable },
            "locationButtonEnable" to { it::setLocationButtonEnable },
            "logoClickEnable" to { it::setLogoClickEnable },
            "logoAlign" to { it::setLogoAlign },
            "logoMargin" to { it::setLogoMargin },
            "contentPadding" to { it::setContentPadding },
            "minZoom" to { it::setMinZoom },
            "maxZoom" to { it::setMaxZoom },
            "maxTilt" to { it::setMaxTilt },
            "locale" to { it::setLocale },
        )
}
package dev.note11.flutter_naver_map.flutter_naver_map.applier

import dev.note11.flutter_naver_map.flutter_naver_map.applier.option.NaverMapOptionApplier
import dev.note11.flutter_naver_map.flutter_naver_map.view.NaverMapView

internal object ApplyUtil {
    internal fun <A : NaverMapOptionApplier> A.applyOptions(args: Map<String, Any?>): A {
        for ((funcName, arg) in args) {
            val func = optionApplyFuncMap[funcName]?.invoke(this)
            if (func != null) {
                try {
                    func.invoke(arg)
                } catch (e: NullPointerException) {
                    throw IllegalArgumentException(
                        "Invalid argument for \"$funcName\". " +
                                "Please check the type of the argument: $arg. this option really can be null?"
                    )
                } catch (e: Exception) {
                    throw RuntimeException(
                        "Failed to apply option \"$funcName\" with argument: $arg",
                        e
                    )
                }
            } else {
                throw NoSuchMethodException(
                    "No such method \"$funcName\". " +
                            "Please check the handling of this method."
                )
            }
        }
        return this
    }

    private val optionApplyFuncMap: Map<String, ((NaverMapOptionApplier) -> ((Any?) -> Unit))> =
        mapOf(
            "initialCameraPosition" to nonNullFunc { it::setInitialCameraPosition },
            "extent" to { it::setExtent },
            "mapType" to nonNullFunc { it::setMapType },
            "liteModeEnable" to nonNullFunc { it::setLiteModeEnable },
            "nightModeEnable" to nonNullFunc { it::setNightModeEnable },
            "indoorEnable" to nonNullFunc { it::setIndoorEnable },
            "activeLayerGroups" to nonNullFunc { it::setActiveLayerGroups },
            "buildingHeight" to nonNullFunc { it::setBuildingHeight },
            "lightness" to nonNullFunc { it::setLightness },
            "symbolScale" to nonNullFunc { it::setSymbolScale },
            "symbolPerspectiveRatio" to nonNullFunc { it::setSymbolPerspectiveRatio },
            "indoorFocusRadius" to nonNullFunc { it::setIndoorFocusRadius },
            "pickTolerance" to nonNullFunc { it::setPickTolerance },
            "rotationGesturesEnable" to nonNullFunc { it::setRotationGesturesEnable },
            "scrollGesturesEnable" to nonNullFunc { it::setScrollGesturesEnable },
            "tiltGesturesEnable" to nonNullFunc { it::setTiltGesturesEnable },
            "zoomGesturesEnable" to nonNullFunc { it::setZoomGesturesEnable },
            "stopGesturesEnable" to nonNullFunc { it::setStopGesturesEnable },
            "scrollGesturesFriction" to nonNullFunc { it::setScrollGesturesFriction },
            "zoomGesturesFriction" to nonNullFunc { it::setZoomGesturesFriction },
            "rotationGesturesFriction" to nonNullFunc { it::setRotationGesturesFriction },
            "consumeSymbolTapEvents" to { { /** @see NaverMapView.setMapTapListener method */ } },
            "scaleBarEnable" to { { /* removed*/ } },
            "indoorLevelPickerEnable" to nonNullFunc { it::setIndoorLevelPickerEnable },
            "locationButtonEnable" to { { /* removed*/ } },
            "logoClickEnable" to { { /* removed*/ } },
            "logoAlign" to nonNullFunc { it::setLogoAlign },
            "logoMargin" to nonNullFunc { it::setLogoMargin },
            "contentPadding" to nonNullFunc { it::setContentPadding },
            "minZoom" to nonNullFunc { it::setMinZoom },
            "maxZoom" to nonNullFunc { it::setMaxZoom },
            "maxTilt" to nonNullFunc { it::setMaxTilt },
            "locale" to nonNullFunc { it::setLocale },
            "customStyleId" to { it::setCustomStyleId },
        )

    private fun nonNullFunc(ev: ((NaverMapOptionApplier) -> ((Any) -> Unit))): ((NaverMapOptionApplier) -> ((Any?) -> Unit)) {
        return { applier ->
            { arg ->
                if (arg == null) throw NullPointerException("Argument cannot be null for this option.")
                ev.invoke(applier).invoke(arg)
            }
        }
    }
}
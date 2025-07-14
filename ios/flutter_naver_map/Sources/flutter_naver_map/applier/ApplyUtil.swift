import Foundation

internal extension  NaverMapOptionApplier {
    func applyOptions(args: Dictionary<String, Any?>) throws {
        for (funcName, arg) in args {
            let fun = ApplyUtil.optionApplyFuncMap[funcName]?(self)
            if let fun = fun {
                do {
                    try fun(arg)
                } catch let error as NSError {
                    if error.domain == "NullPointerException" {
                        throw NSError(domain: "IllegalArgumentException", code: 0, userInfo: [
                            NSLocalizedDescriptionKey: "Invalid argument for \"\(funcName)\". Please check the type of the argument: \(String(describing: arg)). this option really can be null?"
                        ])
                    } else {
                        throw NSError(domain: "RuntimeException", code: 0, userInfo: [
                            NSLocalizedDescriptionKey: "Failed to apply option \"\(funcName)\" with argument: \(String(describing: arg))",
                            NSUnderlyingErrorKey: error
                        ])
                    }
                }
            } else {
                throw NSError(domain: "NoSuchMethodException", code: 0, userInfo: [
                    NSLocalizedDescriptionKey: "No such method \"\(funcName)\". Please check the handling of this method."
                ])
            }
        }
    }
}

internal class ApplyUtil {
    static let optionApplyFuncMap: Dictionary<String, (NaverMapOptionApplier) -> (Any?) throws -> Void> = [
        "initialCameraPosition": nonNullFunc {
            $0.setInitialCameraPosition
        },
        "extent": {
            $0.setExtent
        },
        "mapType": nonNullFunc {
            $0.setMapType
        },
        "liteModeEnable": nonNullFunc {
            $0.setLiteModeEnable
        },
        "nightModeEnable": nonNullFunc {
            $0.setNightModeEnable
        },
        "indoorEnable": nonNullFunc {
            $0.setIndoorEnable
        },
        "activeLayerGroups": nonNullFunc {
            $0.setActiveLayerGroups
        },
        "buildingHeight": nonNullFunc {
            $0.setBuildingHeight
        },
        "lightness": nonNullFunc {
            $0.setLightness
        },
        "symbolScale": nonNullFunc {
            $0.setSymbolScale
        },
        "symbolPerspectiveRatio": nonNullFunc {
            $0.setSymbolPerspectiveRatio
        },
        "indoorFocusRadius": nonNullFunc {
            $0.setIndoorFocusRadius
        },
        "pickTolerance": nonNullFunc {
            $0.setPickTolerance
        },
        "rotationGesturesEnable": nonNullFunc {
            $0.setRotationGesturesEnable
        },
        "scrollGesturesEnable": nonNullFunc {
            $0.setScrollGesturesEnable
        },
        "tiltGesturesEnable": nonNullFunc {
            $0.setTiltGesturesEnable
        },
        "zoomGesturesEnable": nonNullFunc {
            $0.setZoomGesturesEnable
        },
        "stopGesturesEnable": nonNullFunc {
            $0.setStopGesturesEnable
        },
        "scrollGesturesFriction": nonNullFunc {
            $0.setScrollGesturesFriction
        },
        "zoomGesturesFriction": nonNullFunc {
            $0.setZoomGesturesFriction
        },
        "rotationGesturesFriction": nonNullFunc {
            $0.setRotationGesturesFriction
        },
        "consumeSymbolTapEvents": { (_: NaverMapOptionApplier) in
            { (a: Any?) throws in
                /** @see NaverMapView.setMapTapListener method */
            }
        },
        "scaleBarEnable": { _ in { _ in /* removed*/ } },
        "indoorLevelPickerEnable": nonNullFunc {
            $0.setIndoorLevelPickerEnable
        },
        "locationButtonEnable": { _ in { _ in /* removed*/ } },
        "logoClickEnable": { _ in { _ in /* removed*/ } },
        "logoAlign": nonNullFunc {
            $0.setLogoAlign
        },
        "logoMargin": nonNullFunc {
            $0.setLogoMargin
        },
        "contentPadding": nonNullFunc {
            $0.setContentPadding
        },
        "minZoom": nonNullFunc {
            $0.setMinZoom
        },
        "maxZoom": nonNullFunc {
            $0.setMaxZoom
        },
        "maxTilt": nonNullFunc {
            $0.setMaxTilt
        },
        "locale": nonNullFunc {
            $0.setLocale
        },
        "customStyleId": {
            $0.setCustomStyleId
        }
    ]

    private static func nonNullFunc(_ ev: @escaping ((NaverMapOptionApplier) -> ((Any) -> Void))) -> ((NaverMapOptionApplier) -> ((Any?) throws -> Void)) {
        return { applier in
            { arg in
                guard let arg = arg else {
                    throw NSError(domain: "NullPointerException", code: 0, userInfo: [
                        NSLocalizedDescriptionKey: "Argument cannot be null for this option."
                    ])
                }
                ev(applier)(arg)
            }
        }
    }
}

import NMapsMap
import Flutter

internal protocol MarkerHandler: OverlayHandler {
    func hasOpenInfoWindow(_ marker: NMFMarker, success: (_ hasOpenInfoWindow: Bool) -> Void)

    func openInfoWindow(_ marker: NMFMarker, rawInfoWindow: Any, rawAlign: Any, success: (Any?) -> Void)

    func setPosition(_ marker: NMFMarker, rawPosition: Any)

    func setIcon(_ marker: NMFMarker, rawIcon: Any?)

    func setIconTintColor(_ marker: NMFMarker, rawIconTintColor: Any)

    func setAlpha(_ marker: NMFMarker, rawAlpha: Any)

    func setAngle(_ marker: NMFMarker, rawAngle: Any)

    func setAnchor(_ marker: NMFMarker, rawNPoint: Any)

    func setSize(_ marker: NMFMarker, rawSize: Any)

    func setCaption(_ marker: NMFMarker, rawCaption: Any)

    func setSubCaption(_ marker: NMFMarker, rawSubCaption: Any)

    func setCaptionAligns(_ marker: NMFMarker, rawCaptionAligns: Any)

    func setCaptionOffset(_ marker: NMFMarker, rawDpOffset: Any)

    func setIsCaptionPerspectiveEnabled(_ marker: NMFMarker, rawCaptionPerspectiveEnabled: Any)

    func setIsIconPerspectiveEnabled(_ marker: NMFMarker, rawIconPerspectiveEnabled: Any)

    func setIsFlat(_ marker: NMFMarker, rawFlat: Any)

    func setIsForceShowCaption(_ marker: NMFMarker, rawForceShowCaption: Any)

    func setIsForceShowIcon(_ marker: NMFMarker, rawForceShowIcon: Any)

    func setIsHideCollidedCaptions(_ marker: NMFMarker, rawHideCollidedCaptions: Any)

    func setIsHideCollidedMarkers(_ marker: NMFMarker, rawHideCollidedMarkers: Any)

    func setIsHideCollidedSymbols(_ marker: NMFMarker, rawHideCollidedSymbols: Any)
}

internal extension MarkerHandler {
    func handleMarker(marker: NMFOverlay,
                      method: String,
                      args: Any?,
                      result: @escaping FlutterResult) {
        let marker = marker as! NMFMarker
        switch method {
        case NMarker.hasOpenInfoWindowName: hasOpenInfoWindow(marker, success: result)
        case NMarker.openInfoWindowName:
            let d = asDict(args!)
            openInfoWindow(marker, rawInfoWindow: d["infoWindow"]!, rawAlign: d["align"]!, success: result)
        case NMarker.positionName: setPosition(marker, rawPosition: args!)
        case NMarker.iconName: setIcon(marker, rawIcon: args)
        case NMarker.iconTintColorName: setIconTintColor(marker, rawIconTintColor: args!)
        case NMarker.alphaName: setAlpha(marker, rawAlpha: args!)
        case NMarker.angleName: setAngle(marker, rawAngle: args!)
        case NMarker.anchorName: setAnchor(marker, rawNPoint: args!)
        case NMarker.sizeName: setSize(marker, rawSize: args!)
        case NMarker.captionName: setCaption(marker, rawCaption: args!)
        case NMarker.subCaptionName: setSubCaption(marker, rawSubCaption: args!)
        case NMarker.captionAlignsName: setCaptionAligns(marker, rawCaptionAligns: args!)
        case NMarker.captionOffsetName: setCaptionOffset(marker, rawDpOffset: args!)
        case NMarker.isCaptionPerspectiveEnabledName: setIsCaptionPerspectiveEnabled(marker, rawCaptionPerspectiveEnabled: args!)
        case NMarker.isIconPerspectiveEnabledName: setIsIconPerspectiveEnabled(marker, rawIconPerspectiveEnabled: args!)
        case NMarker.isFlatName: setIsFlat(marker, rawFlat: args!)
        case NMarker.isForceShowCaptionName: setIsForceShowCaption(marker, rawForceShowCaption: args!)
        case NMarker.isForceShowIconName: setIsForceShowIcon(marker, rawForceShowIcon: args!)
        case NMarker.isHideCollidedCaptionsName: setIsHideCollidedCaptions(marker, rawHideCollidedCaptions: args!)
        case NMarker.isHideCollidedMarkersName: setIsHideCollidedMarkers(marker, rawHideCollidedMarkers: args!)
        case NMarker.isHideCollidedSymbolsName: setIsHideCollidedSymbols(marker, rawHideCollidedSymbols: args!)
        default: result(FlutterMethodNotImplemented)
        }
    }
}

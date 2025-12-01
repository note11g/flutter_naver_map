import NMapsMap

internal struct NMarker: AddableOverlay {
    typealias OverlayType = NMFMarker
    var overlayPayload: Dictionary<String, Any?> = [:]

    let info: NOverlayInfo
    let position: NMGLatLng
    let icon: NOverlayImage?
    let iconTintColor: UIColor
    let alpha: CGFloat
    let angle: CGFloat
    let anchor: NPoint
    let size: NSize
    let caption: NOverlayCaption?
    let subCaption: NOverlayCaption?
    let captionAligns: Array<NMFAlignType>
    let captionOffset: CGFloat
    let isCaptionPerspectiveEnabled: Bool
    let isIconPerspectiveEnabled: Bool
    let isFlat: Bool
    let isForceShowCaption: Bool
    let isForceShowIcon: Bool
    let isHideCollidedCaptions: Bool
    let isHideCollidedMarkers: Bool
    let isHideCollidedSymbols: Bool

    func createMapOverlay() -> OverlayType {
        let marker = NMFMarker()
        return applyAtRawOverlay(marker)
    }
    
    func applyAtRawOverlay(_ marker: NMFMarker) -> NMFMarker {
        marker.position = position
        if let icon = icon {
            marker.iconImage = icon.overlayImage
        }
        marker.iconTintColor = iconTintColor
        marker.alpha = alpha
        marker.angle = angle
        marker.anchor = anchor.cgPoint
        marker.width = size.width
        marker.height = size.height
        
        if let caption = caption {
            marker.captionText = caption.text
            marker.captionTextSize = caption.textSize
            marker.captionColor = caption.color
            marker.captionHaloColor = caption.haloColor
            marker.captionMinZoom = caption.minZoom
            marker.captionMaxZoom = caption.maxZoom
            marker.captionRequestedWidth = caption.requestWidth
        }
        if let subCaption = subCaption {
            marker.subCaptionText = subCaption.text
            marker.subCaptionTextSize = subCaption.textSize
            marker.subCaptionColor = subCaption.color
            marker.subCaptionHaloColor = subCaption.haloColor
            marker.subCaptionMinZoom = subCaption.minZoom
            marker.subCaptionMaxZoom = subCaption.maxZoom
            marker.subCaptionRequestedWidth = subCaption.requestWidth
        }
        marker.captionAligns = captionAligns
        marker.captionOffset = captionOffset
        marker.captionPerspectiveEnabled = isCaptionPerspectiveEnabled
        marker.iconPerspectiveEnabled = isIconPerspectiveEnabled
        marker.isFlat = isFlat
        marker.isForceShowCaption = isForceShowCaption
        marker.isForceShowIcon = isForceShowIcon
        marker.isHideCollidedCaptions = isHideCollidedCaptions
        marker.isHideCollidedMarkers = isHideCollidedMarkers
        marker.isHideCollidedSymbols = isHideCollidedSymbols
        return marker
    }

    static func fromMessageable(_ v: Any) -> NMarker {
        let d = asDict(v)
        return NMarker(
                info: NOverlayInfo.fromMessageable(d[NMarker.infoName]!),
                position: asLatLng(d[NMarker.positionName]!),
                icon: castOrNull(d[NMarker.iconName], caster: NOverlayImage.fromMessageable),
                iconTintColor: asUIColor(d[NMarker.iconTintColorName]!),
                alpha: asCGFloat(d[NMarker.alphaName]!),
                angle: asCGFloat(d[NMarker.angleName]!),
                anchor: NPoint.fromMessageable(d[NMarker.anchorName]!),
                size: NSize.fromMessageable(d[NMarker.sizeName]!),
                caption: castOrNull(d[NMarker.captionName], caster: NOverlayCaption.fromMessageable),
                subCaption: castOrNull(d[NMarker.subCaptionName], caster: NOverlayCaption.fromMessageable),
                captionAligns: asArr(d[NMarker.captionAlignsName]!, elementCaster: asAlign),
                captionOffset: asCGFloat(d[NMarker.captionOffsetName]!),
                isCaptionPerspectiveEnabled: asBool(d[NMarker.isCaptionPerspectiveEnabledName]!),
                isIconPerspectiveEnabled: asBool(d[NMarker.isIconPerspectiveEnabledName]!),
                isFlat: asBool(d[NMarker.isFlatName]!),
                isForceShowCaption: asBool(d[NMarker.isForceShowCaptionName]!),
                isForceShowIcon: asBool(d[NMarker.isForceShowIconName]!),
                isHideCollidedCaptions: asBool(d[NMarker.isHideCollidedCaptionsName]!),
                isHideCollidedMarkers: asBool(d[NMarker.isHideCollidedMarkersName]!),
                isHideCollidedSymbols: asBool(d[NMarker.isHideCollidedSymbolsName]!)
        )
    }

    /*
        --- Messaging Name Define ---
    */
    private static let infoName = "info"
    static let hasOpenInfoWindowName = "hasOpenInfoWindow"
    static let openInfoWindowName = "openInfoWindow"
    static let positionName = "position"
    static let iconName = "icon"
    static let iconTintColorName = "iconTintColor"
    static let alphaName = "alpha"
    static let angleName = "angle"
    static let anchorName = "anchor"
    static let sizeName = "size"
    static let captionName = "caption"
    static let subCaptionName = "subCaption"
    static let captionAlignsName = "captionAligns"
    static let captionOffsetName = "captionOffset"
    static let isCaptionPerspectiveEnabledName = "isCaptionPerspectiveEnabled"
    static let isIconPerspectiveEnabledName = "isIconPerspectiveEnabled"
    static let isFlatName = "isFlat"
    static let isForceShowCaptionName = "isForceShowCaption"
    static let isForceShowIconName = "isForceShowIcon"
    static let isHideCollidedCaptionsName = "isHideCollidedCaptions"
    static let isHideCollidedMarkersName = "isHideCollidedMarkers"
    static let isHideCollidedSymbolsName = "isHideCollidedSymbols"
}

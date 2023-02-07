import NMapsMap

struct NMarker: AddableOverlay {
    typealias OverlayType = NMFMarker

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
        marker.position = position
        if let icon {
            marker.iconImage = icon.overlayImage
        }
        marker.iconTintColor = iconTintColor
        marker.alpha = alpha
        marker.angle = angle
        marker.anchor = anchor.cgPoint
        marker.width = size.width
        marker.height = size.height
        if let caption {
            marker.captionText = caption.text
            marker.captionTextSize = caption.textSize
            marker.captionColor = caption.color
            marker.captionHaloColor = caption.haloColor
            marker.captionMinZoom = caption.minZoom
            marker.captionMaxZoom = caption.maxZoom
            marker.captionRequestedWidth = caption.requestWidth
        }
        if let subCaption {
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

    func toMessageable() -> Dictionary<String, Any?> {
        [
            NMarker.infoName: info.toMessageable(),
            NMarker.positionName: position.toMessageable(),
            NMarker.iconName: icon?.toMessageable(),
            NMarker.iconTintColorName: iconTintColor.toInt(),
            NMarker.alphaName: alpha,
            NMarker.angleName: angle,
            NMarker.anchorName: anchor.toMessageable(),
            NMarker.sizeName: size.toMessageable(),
            NMarker.captionName: caption?.toMessageable(),
            NMarker.subCaptionName: subCaption?.toMessageable(),
            NMarker.captionAlignsName: captionAligns.map {
                $0.toMessageableString()
            },
            NMarker.captionOffsetName: captionOffset,
            NMarker.isCaptionPerspectiveEnabledName: isCaptionPerspectiveEnabled,
            NMarker.isIconPerspectiveEnabledName: isIconPerspectiveEnabled,
            NMarker.isFlatName: isFlat,
            NMarker.isForceShowCaptionName: isForceShowCaption,
            NMarker.isForceShowIconName: isForceShowIcon,
            NMarker.isHideCollidedCaptionsName: isHideCollidedCaptions,
            NMarker.isHideCollidedMarkersName: isHideCollidedMarkers,
            NMarker.isHideCollidedSymbolsName: isHideCollidedSymbols,
        ]
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

    static func fromOverlay(_ overlay: NMFOverlay, id: String) -> NMarker {
        let marker = overlay as! NMFMarker
        return NMarker(
                info: NOverlayInfo(type: .marker, id: id),
                position: marker.position,
                icon: NOverlayImage.none,
                iconTintColor: marker.iconTintColor,
                alpha: marker.alpha,
                angle: marker.angle,
                anchor: NPoint.fromCGPointWithOutDisplay(marker.anchor),
                size: NSize(width: marker.width, height: marker.height),
                caption: NOverlayCaption(
                        text: marker.captionText,
                        textSize: marker.captionTextSize,
                        color: marker.captionColor,
                        haloColor: marker.captionHaloColor,
                        minZoom: marker.minZoom,
                        maxZoom: marker.maxZoom,
                        requestWidth: marker.captionRequestedWidth
                ),
                subCaption: NOverlayCaption(
                        text: marker.subCaptionText,
                        textSize: marker.subCaptionTextSize,
                        color: marker.subCaptionColor,
                        haloColor: marker.subCaptionHaloColor,
                        minZoom: marker.subCaptionMinZoom,
                        maxZoom: marker.subCaptionMaxZoom,
                        requestWidth: marker.subCaptionRequestedWidth
                ),
                captionAligns: marker.captionAligns,
                captionOffset: marker.captionOffset,
                isCaptionPerspectiveEnabled: marker.captionPerspectiveEnabled,
                isIconPerspectiveEnabled: marker.iconPerspectiveEnabled,
                isFlat: marker.isFlat,
                isForceShowCaption: marker.isForceShowCaption,
                isForceShowIcon: marker.isForceShowIcon,
                isHideCollidedCaptions: marker.isHideCollidedCaptions,
                isHideCollidedMarkers: marker.isHideCollidedMarkers,
                isHideCollidedSymbols: marker.isHideCollidedSymbols
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
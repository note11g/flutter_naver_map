import NMapsMap

internal struct NewNMarker: NOverlay {
    typealias OverlayType = NMFMarker
    
    let mapOverlay: OverlayType = NMFMarker()
    let info: NOverlayInfo
    
    var position: NMGLatLng {
        get {
            mapOverlay.position
        }
        set {
            mapOverlay.position = newValue
        }
    }
    
    private var _icon: NOverlayImage? = nil
    var icon: NOverlayImage? {
        get {
            _icon
        }
        set {
            _icon = newValue
            if let overlayImage = newValue?.overlayImage {
                mapOverlay.iconImage = overlayImage
                let scaleFactor = UIScreen.main.scale
                size = NSize(width: overlayImage.imageWidth / scaleFactor, height: overlayImage.imageHeight / scaleFactor)
            }
        }
    }
    
    var size: NSize {
        get {
            NSize(width: mapOverlay.width, height: mapOverlay.height)
        }
        set {
            mapOverlay.width = newValue.width
            mapOverlay.height = newValue.height
        }
    }
    
    init(info: NOverlayInfo, position: NMGLatLng, icon: NOverlayImage?, iconTintColor: UIColor, alpha: CGFloat, angle: CGFloat, anchor: NPoint, size: NSize, caption: NOverlayCaption?, subCaption: NOverlayCaption?, captionAligns: Array<NMFAlignType>, captionOffset: CGFloat, isCaptionPerspectiveEnabled: Bool, isIconPerspectiveEnabled: Bool, isFlat: Bool, isForceShowCaption: Bool, isForceShowIcon: Bool, isHideCollidedCaptions: Bool, isHideCollidedMarkers: Bool, isHideCollidedSymbols: Bool) {
        self.info = info
        self.position = position
        self.size = size
    }
    
    static func fromMessageable(_ v: Any) -> Self {
        let d = asDict(v)
        
        
        let m = NewNMarker(
                info: NOverlayInfo.fromMessageable(d[Self.infoName]!),
                position: asLatLng(d[Self.positionName]!),
                icon: castOrNull(d[Self.iconName], caster: NOverlayImage.fromMessageable),
                iconTintColor: asUIColor(d[Self.iconTintColorName]!),
                alpha: asCGFloat(d[Self.alphaName]!),
                angle: asCGFloat(d[Self.angleName]!),
                anchor: NPoint.fromMessageable(d[Self.anchorName]!),
                size: NSize.fromMessageable(d[Self.sizeName]!),
                caption: castOrNull(d[Self.captionName], caster: NOverlayCaption.fromMessageable),
                subCaption: castOrNull(d[Self.subCaptionName], caster: NOverlayCaption.fromMessageable),
                captionAligns: asArr(d[Self.captionAlignsName]!, elementCaster: asAlign),
                captionOffset: asCGFloat(d[Self.captionOffsetName]!),
                isCaptionPerspectiveEnabled: asBool(d[Self.isCaptionPerspectiveEnabledName]!),
                isIconPerspectiveEnabled: asBool(d[Self.isIconPerspectiveEnabledName]!),
                isFlat: asBool(d[Self.isFlatName]!),
                isForceShowCaption: asBool(d[Self.isForceShowCaptionName]!),
                isForceShowIcon: asBool(d[Self.isForceShowIconName]!),
                isHideCollidedCaptions: asBool(d[Self.isHideCollidedCaptionsName]!),
                isHideCollidedMarkers: asBool(d[Self.isHideCollidedMarkersName]!),
                isHideCollidedSymbols: asBool(d[Self.isHideCollidedSymbolsName]!)
        )
        
//        for (key, caster) in casters {
//            if let rawValue = d[key] {
//                let value = caster(rawValue)
//                m.info =
//            }
//        }
        
        return m
    }

    /*
        --- Messaging Name Define ---
    */
    private static let casters: Dictionary<String, (_ v: Any) -> Any?> = [
        "info": NOverlayInfo.fromMessageable,
        "position": asLatLng,
        "icon": { return castOrNull($0, caster: NOverlayImage.fromMessageable) },
        "iconTintColor": asUIColor,
        "sizeName": NSize.fromMessageable
    ]
    
    private static let infoName = "info"
    private static let hasOpenInfoWindowName = "hasOpenInfoWindow"
    private static let openInfoWindowName = "openInfoWindow"
    private static let positionName = "position"
    private static let iconName = "icon"
    private static let iconTintColorName = "iconTintColor"
    private static let alphaName = "alpha"
    private static let angleName = "angle"
    private static let anchorName = "anchor"
    private static let sizeName = "size"
    private static let captionName = "caption"
    private static let subCaptionName = "subCaption"
    private static let captionAlignsName = "captionAligns"
    private static let captionOffsetName = "captionOffset"
    private static let isCaptionPerspectiveEnabledName = "isCaptionPerspectiveEnabled"
    private static let isIconPerspectiveEnabledName = "isIconPerspectiveEnabled"
    private static let isFlatName = "isFlat"
    private static let isForceShowCaptionName = "isForceShowCaption"
    private static let isForceShowIconName = "isForceShowIcon"
    private static let isHideCollidedCaptionsName = "isHideCollidedCaptions"
    private static let isHideCollidedMarkersName = "isHideCollidedMarkers"
    private static let isHideCollidedSymbolsName = "isHideCollidedSymbols"
    
}

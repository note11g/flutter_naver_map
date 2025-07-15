import NMapsMap
import Flutter

internal protocol OverlayHandler {
    func hasOverlay(info: NOverlayInfo) -> Bool

    func saveOverlay(overlay: NMFOverlay, info: NOverlayInfo)

    func deleteOverlay(info: NOverlayInfo)

    func clearOverlays()

    func clearOverlays(type: NOverlayType)
    
    func initializeLocationOverlay(overlay: NMFLocationOverlay)

    /*
      --- methods ---
    */

    func setZIndex(_ overlay: NMFOverlay, rawZIndex: Any)

    func setGlobalZIndex(_ overlay: NMFOverlay, rawGlobalZIndex: Any)

    func setIsVisible(_ overlay: NMFOverlay, rawIsVisible: Any)

    func setMinZoom(_ overlay: NMFOverlay, rawMinZoom: Any)

    func setMaxZoom(_ overlay: NMFOverlay, rawMaxZoom: Any)

    func setIsMinZoomInclusive(_ overlay: NMFOverlay, rawIsMinZoomInclusive: Any)

    func setIsMaxZoomInclusive(_ overlay: NMFOverlay, rawIsMaxZoomInclusive: Any)

    func performClick(_ overlay: NMFOverlay, success: (Any?) -> Void)
    
    func setHasOnTapListener(_ overlay: NMFOverlay, rawHasOnTapListener: Any)
    
    func removeChannel()
}

func getterName(_ name: String) -> String {
    "get\(name)"
}

let zIndexName = "zIndex"
let globalZIndexName = "globalZIndex"
let isAddedName = "isAdded"
let isVisibleName = "isVisible"
let minZoomName = "minZoom"
let maxZoomName = "maxZoom"
let isMinZoomInclusiveName = "isMinZoomInclusive"
let isMaxZoomInclusiveName = "isMaxZoomInclusive"
private let performClickName = "performClick"
let hasOnTapListenerName = "hasOnTapListener"
let onTapName = "onTap"
let allPropertyNames = [
    zIndexName,
    globalZIndexName,
    isVisibleName,
    minZoomName,
    maxZoomName,
    isMinZoomInclusiveName,
    isMaxZoomInclusiveName,
    hasOnTapListenerName,
]

internal extension OverlayHandler {
    func handleOverlay(
            overlay: NMFOverlay,
            method: String,
            arg: Any?,
            result: FlutterResult? // Optional Closure is @escaping as a default.
    ) -> Bool {
        switch method {
        case zIndexName: setZIndex(overlay, rawZIndex: arg!)
        case globalZIndexName: setGlobalZIndex(overlay, rawGlobalZIndex: arg!)
        case isVisibleName: setIsVisible(overlay, rawIsVisible: arg!)
        case minZoomName: setMinZoom(overlay, rawMinZoom: arg!)
        case maxZoomName: setMaxZoom(overlay, rawMaxZoom: arg!)
        case isMinZoomInclusiveName: setIsMinZoomInclusive(overlay, rawIsMinZoomInclusive: arg!)
        case isMaxZoomInclusiveName: setIsMaxZoomInclusive(overlay, rawIsMaxZoomInclusive: arg!)
        case performClickName: performClick(overlay, success: result!)
        case hasOnTapListenerName: setHasOnTapListener(overlay, rawHasOnTapListener: arg!)
        default: return false
        }
        return true
    }

    func saveOverlayWithAddable<C: AddableOverlay>(
        creator: C,
        createdOverlay: C.OverlayType? = nil
    ) -> NMFOverlay {
        if hasOverlay(info: creator.info) {
            deleteOverlay(info: creator.info)
        }

        let overlay = createdOverlay != nil
        ? creator.applyAtRawOverlay(createdOverlay!)
         : creator.createMapOverlay()
        
        creator.applyCommonProperties { name, arg in
            _ = handleOverlay(overlay: overlay, method: name, arg: arg, result: nil)
        }
        
        saveOverlay(overlay: overlay, info: creator.info)
        return overlay
    }
}

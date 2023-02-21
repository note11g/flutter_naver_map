import NMapsMap

internal protocol OverlayHandler {
    func hasOverlay(info: NOverlayInfo) -> Bool

    func saveOverlay(overlay: NMFOverlay, info: NOverlayInfo)

    func deleteOverlay(info: NOverlayInfo)

    func clearOverlays()

    func clearOverlays(type: NOverlayType)

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
let onTapName = "onTap"

internal extension OverlayHandler {
    func handleOverlay(
            overlay: NMFOverlay,
            method: String,
            args: Any?,
            result: @escaping FlutterResult
    ) -> Bool {
        switch method {
        case zIndexName: setZIndex(overlay, rawZIndex: args!)
        case globalZIndexName: setGlobalZIndex(overlay, rawGlobalZIndex: args!)
        case isVisibleName: setIsVisible(overlay, rawIsVisible: args!)
        case minZoomName: setMinZoom(overlay, rawMinZoom: args!)
        case maxZoomName: setMaxZoom(overlay, rawMaxZoom: args!)
        case isMinZoomInclusiveName: setIsMinZoomInclusive(overlay, rawIsMinZoomInclusive: args!)
        case isMaxZoomInclusiveName: setIsMaxZoomInclusive(overlay, rawIsMaxZoomInclusive: args!)
        case performClickName: performClick(overlay, success: result)
        default: return false
        }
        return true
    }

    func saveOverlayWithAddable(creator: any AddableOverlay) -> NMFOverlay {
        if hasOverlay(info: creator.info) {
            deleteOverlay(info: creator.info)
        }

        let overlay = creator.createMapOverlay()
        saveOverlay(overlay: overlay, info: creator.info)
        return overlay
    }
}
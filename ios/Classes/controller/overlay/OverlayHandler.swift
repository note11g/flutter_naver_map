import NMapsMap

protocol OverlayHandler {
    func hasOverlay(info: NOverlayInfo) -> Bool

    func saveOverlay(overlay: NMFOverlay, info: NOverlayInfo)

    func deleteOverlay(info: NOverlayInfo)

    func clearOverlays()

    func clearOverlays(type: NOverlayType)

    func getSavedOverlayKey(overlay: NMFOverlay) -> String?

    /*
      --- methods ---
    */

    func getZIndex(_ overlay: NMFOverlay, success: (_ zIndex: Int) -> Void)

    func setZIndex(_ overlay: NMFOverlay, rawZIndex: Any)

    func getGlobalZIndex(_ overlay: NMFOverlay, success: (_ globalZIndex: Int) -> Void)

    func setGlobalZIndex(_ overlay: NMFOverlay, rawGlobalZIndex: Any)

    func getTag(_ overlay: NMFOverlay, success: (_ tag: String?) -> Void)

    func setTag(_ overlay: NMFOverlay, rawTag: String)

    func getIsAdded(_ overlay: NMFOverlay, success: (_ isAdded: Bool) -> Void)

    func getIsVisible(_ overlay: NMFOverlay, success: (_ isVisible: Bool) -> Void)

    func setIsVisible(_ overlay: NMFOverlay, rawIsVisible: Any)

    func getMinZoom(_ overlay: NMFOverlay, success: (_ minZoom: Double) -> Void)

    func setMinZoom(_ overlay: NMFOverlay, rawMinZoom: Any)

    func getMaxZoom(_ overlay: NMFOverlay, success: (_ maxZoom: Double) -> Void)

    func setMaxZoom(_ overlay: NMFOverlay, rawMaxZoom: Any)

    func getIsMinZoomInclusive(_ overlay: NMFOverlay, success: (_ isMinZoomInclusive: Bool) -> Void)

    func setIsMinZoomInclusive(_ overlay: NMFOverlay, rawIsMinZoomInclusive: Any)

    func getIsMaxZoomInclusive(_ overlay: NMFOverlay, success: (_ isMaxZoomInclusive: Bool) -> Void)

    func setIsMaxZoomInclusive(_ overlay: NMFOverlay, rawIsMaxZoomInclusive: Any)

    func performClick(_ overlay: NMFOverlay, success: (Any?) -> Void)
}

func getterName(_ name: String) -> String {
    "get\(name)"
}

private let zIndexName = "zIndex"
private let globalZIndexName = "globalZIndex"
private let tagName = "tag"
private let isAddedName = "isAdded"
private let isVisibleName = "isVisible"
private let minZoomName = "minZoom"
private let maxZoomName = "maxZoom"
private let isMinZoomInclusiveName = "isMinZoomInclusive"
private let isMaxZoomInclusiveName = "isMaxZoomInclusive"
private let performClickName = "performClick"
let onTapName = "onTap"

extension OverlayHandler {
    func handleOverlay(
            overlay: NMFOverlay,
            method: String,
            args: Any?,
            result: @escaping FlutterResult
    ) -> Bool {
        switch method {
        case zIndexName: setZIndex(overlay, rawZIndex: args!)
        case globalZIndexName: setGlobalZIndex(overlay, rawGlobalZIndex: args!)
        case tagName: setTag(overlay, rawTag: asString(args!))
        case isVisibleName: setIsVisible(overlay, rawIsVisible: args!)
        case minZoomName: setMinZoom(overlay, rawMinZoom: args!)
        case maxZoomName: setMaxZoom(overlay, rawMaxZoom: args!)
        case isMinZoomInclusiveName: setIsMinZoomInclusive(overlay, rawIsMinZoomInclusive: args!)
        case isMaxZoomInclusiveName: setIsMaxZoomInclusive(overlay, rawIsMaxZoomInclusive: args!)
        case getterName(zIndexName): getZIndex(overlay, success: result)
        case getterName(globalZIndexName): getGlobalZIndex(overlay, success: result)
        case getterName(tagName): getTag(overlay, success: result)
        case getterName(isAddedName): getIsAdded(overlay, success: result)
        case getterName(isVisibleName): getIsVisible(overlay, success: result)
        case getterName(minZoomName): getMinZoom(overlay, success: result)
        case getterName(maxZoomName): getMaxZoom(overlay, success: result)
        case getterName(isMinZoomInclusiveName): getIsMinZoomInclusive(overlay, success: result)
        case getterName(isMaxZoomInclusiveName): getIsMaxZoomInclusive(overlay, success: result)
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
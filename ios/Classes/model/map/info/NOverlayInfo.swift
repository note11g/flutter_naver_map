import NMapsMap

internal struct NOverlayInfo: NPickableInfo, Hashable {
    let type: NOverlayType
    let id: String

    static func fromMessageable(_ v: Any) -> NOverlayInfo {
        let d = asDict(v)
        return NOverlayInfo(
                type: NOverlayType(rawValue: asString(d["type"]!))!,
                id: asString(d["id"]!)
        )
    }

    static func fromOverlay(_ overlay: NMFOverlay) -> NOverlayInfo {
        overlay.userInfo["info"] as! NOverlayInfo
    }

    func toMessageable() -> Dictionary<String, Any?> {
        ["type": type.rawValue, "id": id]
    }

    func saveAtOverlay(_ overlay: NMFOverlay) {
        overlay.userInfo["info"] = self
    }

    static let locationOverlayInfo = NOverlayInfo(type: .locationOverlay, id: "L")

    // ----- Hashable -----

    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(id)
    }

    static func ==(i1: NOverlayInfo, i2: NOverlayInfo) -> Bool {
        if i1.type != i2.type {
            return false
        }
        if i1.id != i2.id {
            return false
        }
        return true
    }
}
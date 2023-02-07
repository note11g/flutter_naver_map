import NMapsMap

struct NOverlayInfo {
    let type: NOverlayType
    let id: String
    let method: String?

    init(type: NOverlayType, id: String, method: String? = nil) {
        self.type = type
        self.id = id
        self.method = method
    }

    func getOverlay(overlays: Dictionary<String, NMFOverlay>) -> NMFOverlay? {
        overlays[overlayMapKey]
    }

    /* ----- toMessageable ----- */

    var overlayMapKey: String {
        [type.rawValue, id].joined(separator: NOverlayInfo.separateString)
    }

    func toQueryString(injectMethod: String? = nil) -> String {
        [overlayMapKey, (injectMethod ?? method!)].joined(separator: NOverlayInfo.separateString)
    }

    func toMessageable() -> Dictionary<String, Any> {
        ["type": type.rawValue, "id": id]
    }

    /* ----- fromMessageable ----- */

    static func fromMessageable(_ v: Any) -> NOverlayInfo {
        let d = asDict(v)
        return NOverlayInfo(
                type: NOverlayType(rawValue: asString(d["type"]!))!,
                id: asString(d["id"]!)
        )
    }

    static func fromString(_ query: String) -> NOverlayInfo {
        let arr = query.components(separatedBy: NOverlayInfo.separateString)
        return NOverlayInfo(
                type: NOverlayType(rawValue: asString(arr[0]))!,
                id: asString(arr[1]),
                method: (arr.count > 2) ? asString(arr[2]) : nil
        )
    }

    private static let separateString = "\"";

    static let locationOverlayInfo = NOverlayInfo(type: .locationOverlay, id: "L")
}
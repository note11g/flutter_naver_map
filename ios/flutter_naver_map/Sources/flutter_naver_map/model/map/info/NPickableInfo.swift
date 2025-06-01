import NMapsMap

internal protocol NPickableInfo {
    func toMessageable() -> Dictionary<String, Any?>
}

extension NPickableInfo {
    func toSignedMessageable() -> Dictionary<String, Any?> {
        toMessageable().merging(["signature": (self is NSymbolInfo ? "symbol" : "overlay")],
                uniquingKeysWith: { (current, _) in current })
    }

    static func fromPickable(pickable: NMFPickable) -> NPickableInfo {
        switch (pickable) {
        case let symbol as NMFSymbol:return NSymbolInfo(symbol: symbol)
        case let overlay as NMFOverlay:return NOverlayInfo.fromOverlay(overlay)
        default: fatalError("Unknown pickable type")
        }
    }
}
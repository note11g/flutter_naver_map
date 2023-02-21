import NMapsMap

internal struct NSymbolInfo: NPickableInfo {
    let caption: String
    let position: NMGLatLng

    init(symbol: NMFSymbol) {
        caption = symbol.caption
        position = symbol.position
    }

    func toMessageable() -> Dictionary<String, Any?> {
        ["caption": caption, "position": position.toMessageable()]
    }
}
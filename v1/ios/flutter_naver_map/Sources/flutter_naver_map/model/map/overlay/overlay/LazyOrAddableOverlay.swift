internal protocol LazyOrAddableOverlay {
    associatedtype OverlayType: Any
    
    func createMapOverlay() -> OverlayType
}

internal func asLazyOverlayOrAddableOverlayFromMessageable(
    info: NOverlayInfo,
    args: Dictionary<String, Any>
) throws -> any LazyOrAddableOverlay {
    if (info.type.isLazy) {
        return try asLazyOverlayFromMessageable(info: info, args: args)
    }
    return try asAddableOverlayFromMessageable(info: info, json: args)
}

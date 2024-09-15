import NMapsMap

internal protocol LazyOverlay: LazyOrAddableOverlay {
    override associatedtype OverlayType: Any
    associatedtype RealOverlayType: AddableOverlay // Wrapped
    
    override func createMapOverlay() -> OverlayType
    
    var info: NOverlayInfo { get }
    var wrappedOverlay: RealOverlayType { get }
}

internal func asLazyOverlayFromMessageable(info: NOverlayInfo, args: Dictionary<String, Any>) throws -> any LazyOverlay  {
    return switch info.type {
    case .clusterableMarker: NClusterableMarker.fromMessageable(args)
    default: throw NSError(domain: "LazyOverlay", code: 0, userInfo: [
        NSLocalizedDescriptionKey: "\(info.type) is not LazyOverlay"
    ])
    }
}

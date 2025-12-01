import NMapsMap

internal protocol NClusterNode {}

internal class NClusterableMarker: NSObject, LazyOverlay, NClusterNode {
    typealias OverlayType = NClusterableMarker
    typealias RealOverlayType = NMarker
    
    var info: NOverlayInfo { clusterInfo }
    let clusterInfo: NClusterableMarkerInfo
    let wrappedOverlay: NMarker
    
    init(clusterInfo: NClusterableMarkerInfo, wrappedOverlay: NMarker) {
        self.clusterInfo = clusterInfo
        self.wrappedOverlay = wrappedOverlay
    }
    
    func createMapOverlay() -> NClusterableMarker {
        self
    }
    
    static func fromMessageable(_ v: Any) -> NClusterableMarker{
        let d = asDict(v)
        return NClusterableMarker(
            clusterInfo: NClusterableMarkerInfo.fromMessageableAtClusterableMarker(d[infoName]!),
            wrappedOverlay: asAddableOverlayFromMessageableCorrector(
                json: d, creator:NMarker.fromMessageable) as! NMarker
        )
    }
    
    private static let infoName = "info"
}

internal class NClusterInfo: NSObject, NClusterNode {
    let children: [NClusterableMarkerInfo]
    let clusterSize: Int
    let position: NMGLatLng
    let mergedTagKey: String?
    let mergedTag: String?
    
    init(children: [NClusterableMarkerInfo], clusterSize: Int, position: NMGLatLng, mergedTagKey: String?, mergedTag: String?) {
        self.children = children
        self.clusterSize = clusterSize
        self.position = position
        self.mergedTagKey = mergedTagKey
        self.mergedTag = mergedTag
    }
    
    var id: String { String(hashValue) }
    
    lazy var markerInfo: NClusterableMarkerInfo! = NClusterableMarkerInfo(id: id, tags: [:], position: position)
    
    func toMessageable() -> Dictionary<String, Any?> {
        return [
            "id": id,
            "children": children.map { (child) in child.toMessageable() },
            "clusterSize": clusterSize,
            "position": position.toMessageable(),
            "mergedTagKey": mergedTagKey,
            "mergedTag" : mergedTag,
        ]
    }
    
    override func isEqual(_ o: Any?) -> Bool {
        guard let o = o as? NClusterInfo else { return false }
        if self === o { return true }
        return children == o.children
        && clusterSize == o.clusterSize
        && position == o.position
    }

    override var hash: Int {
        var hasher = Hasher()
        hasher.combine(children)
        hasher.combine(clusterSize)
        hasher.combine(position)
        return hasher.finalize()
    }
}

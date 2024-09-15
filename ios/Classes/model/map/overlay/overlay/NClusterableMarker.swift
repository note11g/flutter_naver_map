import NMapsMap

internal protocol NClusterNode {}

internal struct NClusterableMarker: LazyOverlay, NClusterNode {
    typealias OverlayType = NClusterableMarker
    typealias RealOverlayType = NMarker
    
    let info: NOverlayInfo // todo ClusterableMarkerInfo
    let wrappedOverlay: NMarker
    
    func createMapOverlay() -> NClusterableMarker {
        self
    }
    
    static func fromMessageable(_ v: Any) -> NClusterableMarker{
        let d = asDict(v)
        return NClusterableMarker(info: NClusterableMarkerInfo.fromMessageableAtClusterableMarker(d[infoName]!), wrappedOverlay: asAddableOverlayFromMessageableCorrector(json: d, creator:NMarker.fromMessageable) as! NMarker)
    }
    
    private static let infoName = "info"
}

internal struct NClusterInfo: NClusterNode, Hashable {
    let children: [NClusterableMarkerInfo]
    let clusterSize: Int
    let position: NMGLatLng
    let mergedTagKey: String?
    let mergedTag: String?
    
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
    
    static func ==(i1: NClusterInfo, i2: NClusterInfo) -> Bool {
        if i1.children != i2.children { return false }
        if i1.clusterSize != i2.clusterSize { return false }
        if i1.position != i2.position { return false }
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(children)
        hasher.combine(clusterSize)
        hasher.combine(position)
    }
}

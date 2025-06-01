import NMapsMap

internal class NClusterableMarkerInfo: NOverlayInfo, NMCClusteringKey {
    let tags: Dictionary<String, String>
    let position: NMGLatLng
    
    var messageOverlayInfo: NOverlayInfo { NOverlayInfo(type: .clusterableMarker, id: id) }
    
    init(id: String, tags: Dictionary<String, String>, position: NMGLatLng) {
        self.tags = tags
        self.position = position
        super.init(type: .clusterableMarker, id: id)
    }

    static func ==(i1: NClusterableMarkerInfo, i2: NClusterableMarkerInfo) -> Bool {
        if i1.id != i2.id {
            return false
        }
        return true
    }
    
    override func isEqual(_ o: Any?) -> Bool {
        guard let o = o as? NOverlayInfo else {
            return false
        }
        if self === o {
            return true
        }
        return o.id == self.id
    }

    override var hash: Int {
        return self.id.hashValue
    }

    func copy(with zone: NSZone? = nil) -> Any {
        return NClusterableMarkerInfo(id: self.id, tags: self.tags, position: self.position)
    }
    
    override func toMessageable() -> Dictionary<String, Any?> {
        super.toMessageable().merging([
            "tags": tags,
            "position": position.toMessageable()
        ]) { _, v2 in v2 }
    }
    
    static func fromMessageableAtClusterableMarker(_ v: Any) -> NClusterableMarkerInfo {
        let d = asDict(v)
        return NClusterableMarkerInfo(
            id: asString(d["id"]!),
            tags: asStringDict(d["tags"]!),
            position: asLatLng(d["position"]!)
        )
    }
}

import NMapsMap

internal class ClusteringController: NMCDefaultClusterMarkerUpdater, NMCThresholdStrategy, NMCTagMergeStrategy {
    private let naverMap: NMFNaverMapView!
    private let overlayController: OverlayHandler
    private let messageSender: (_ method: String, _ args: Any) -> Void
    
    init(naverMap: NMFNaverMapView!, overlayController: OverlayHandler, messageSender: @escaping (_: String, _: Any) -> Void) {
        self.naverMap = naverMap
        self.overlayController = overlayController
        self.messageSender = messageSender
    }
    
    private var clusterOptions: NaverMapClusterOptions!
    
    private var clusterer: NMCClusterer<NClusterableMarkerInfo>?
    
    private var clusterableMarkers: [NClusterableMarkerInfo: NClusterableMarker] = [:]
    private var mergedScreenDistanceCacheArray: [Double] = Array(repeating: NMC_DEFAULT_SCREEN_DISTANCE, count: 24) // idx: zoom, distance
    private lazy var clusterMarkerUpdate = ClusterMarkerUpdater(callback: self.onClusterMarkerUpdate)
    private lazy var clusterableMarkerUpdate = ClusterableMarkerUpdater(callback: self.onClusterableMarkerUpdate)
    
    func updateClusterOptions(_ options: NaverMapClusterOptions) {
        clusterOptions = options
        print(options)
        if clusterer != nil { clusterer?.mapView = nil }
        
        cacheScreenDistance(options.mergeStrategy.willMergedScreenDistance)
        
        let builder = NMCComplexBuilder<NClusterableMarkerInfo>()
        builder.minClusteringZoom = options.enableZoomRange.min ?? Int(NMF_MIN_ZOOM)
        builder.maxClusteringZoom = options.enableZoomRange.max ?? Int(NMF_MAX_ZOOM)
        builder.animationDuration = Double(options.animationDuration) * 0.001
        builder.thresholdStrategy = self
        builder.tagMergeStrategy = self
        builder.minIndexingZoom = 0
        builder.maxIndexingZoom = 0
        builder.clusterMarkerUpdater = clusterMarkerUpdate
        builder.leafMarkerUpdater = clusterableMarkerUpdate
        clusterer = builder.build()
    }
    
    private func cacheScreenDistance(_ willMergedScreenDistance: Dictionary<NRange<Int>, Double>) {
        for i in Int(NMF_MIN_ZOOM)...Int(NMF_MAX_ZOOM) { // 0 ~ 21
            let firstMatchedDistance: Double? = willMergedScreenDistance.first(
                where: { k, v in k.isInRange(i) })?.value
            if let distance = firstMatchedDistance { mergedScreenDistanceCacheArray[i] = distance }
        }
    }
    
    private func updateClusterer() {
        clusterer!.mapView = nil
        clusterer!.mapView = naverMap.mapView
    }
    
    func addClusterableMarkerAll(_ markers: [NClusterableMarker]) {
        let markersWithTag: [NClusterableMarkerInfo: NClusterableMarker]
        = Dictionary(uniqueKeysWithValues: markers.map { ($0.clusterInfo, $0) })
        clusterer?.addAll(markersWithTag)
        clusterableMarkers.merge(markersWithTag, uniquingKeysWith: { $1 })
        updateClusterer()
        print("클러스터블 마커 추가: \(markers)")
    }
    
    func deleteClusterableMarker(_ overlayInfo: NOverlayInfo) {
        let clusterableOverlayInfo = NClusterableMarkerInfo(id: overlayInfo.id, tags: [:], position: NMGLatLng.invalid())
        clusterableMarkers.removeValue(forKey: clusterableOverlayInfo)
        overlayController.deleteOverlay(info: overlayInfo)
        clusterer?.remove(clusterableOverlayInfo) // if needed use callback
        updateClusterer()
        print("클러스터블 마커 삭제: \(overlayInfo)")
    }
    
    func clearClusterableMarker() {
        clusterableMarkers.removeAll()
        overlayController.clearOverlays(type: .clusterableMarker)
        clusterer?.clear()
        updateClusterer()
        print("클러스터블 마커 전체 삭제 \(clusterer?.empty)")
    }
    
    private func onClusterMarkerUpdate(_ clusterMarkerInfo: NMCClusterMarkerInfo, _ marker: NMFMarker) {
        guard let info = clusterMarkerInfo.tag as? NClusterInfo else { return }
        overlayController.saveOverlay(overlay: marker, info: info.markerInfo.messageOverlayInfo)
        marker.hidden = true
        sendClusterMarkerEvent(info: info)
    }
    
    private func sendClusterMarkerEvent(info: NClusterInfo) {
        messageSender("clusterMarkerBuilder", info.toMessageable())
    }
    
    private func onClusterableMarkerUpdate(_ clusterableMarkerInfo: NMCLeafMarkerInfo, _ marker: NMFMarker) {
        marker.iconImage = NMF_MARKER_IMAGE_BLACK
        let nClusterableMarker: NClusterableMarker = clusterableMarkerInfo.tag as! NClusterableMarker
        let nMarker: NMarker = nClusterableMarker.wrappedOverlay
        _ = overlayController.saveOverlayWithAddable(creator: nMarker, createdOverlay: marker)
    }
    
    func getThreshold(_ zoom: Int) -> Double {
        return mergedScreenDistanceCacheArray[zoom]
    }
    
    func mergeTag(_ cluster: NMCCluster) -> NSObject? {
        var mergedTagKey: String? = nil
        var children: [NClusterableMarkerInfo] = []
        
        for node in cluster.children {
            let data = node.tag
            switch data {
            case let data as NClusterableMarker:
                children.append(data.clusterInfo)
            case let data as NClusterInfo:
                if mergedTagKey == nil { mergedTagKey = data.mergedTagKey }
                children.append(contentsOf: data.children)
            default:
                print(data?.description ?? "empty tag")
            }
        }
        
        return NClusterInfo(
            children: children,
            clusterSize: children.count,
            position: cluster.position,
            mergedTagKey: mergedTagKey,
            mergedTag: nil
        )
    }
}

class ClusterMarkerUpdater: NMCDefaultClusterMarkerUpdater {
    let callback: (_ clusterMarkerInfo: NMCClusterMarkerInfo, _ marker: NMFMarker) -> Void
    
    init(callback: @escaping (_: NMCClusterMarkerInfo, _: NMFMarker) -> Void) {
        self.callback = callback
    }
    
    override func updateClusterMarker(_ info: NMCClusterMarkerInfo, _ marker: NMFMarker) {
        super.updateClusterMarker(info, marker)
        callback(info, marker)
    }
}

class ClusterableMarkerUpdater: NMCDefaultLeafMarkerUpdater {
    let callback: (_ clusterableMarkerInfo: NMCLeafMarkerInfo, _ marker: NMFMarker) -> Void
    
    init(callback: @escaping (_: NMCLeafMarkerInfo, _: NMFMarker) -> Void) {
        self.callback = callback
    }
    
    override func updateLeafMarker(_ info: NMCLeafMarkerInfo, _ marker: NMFMarker) {
        super.updateLeafMarker(info, marker)
        callback(info, marker)
    }
}

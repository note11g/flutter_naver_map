import NMapsMap

internal class NaverMapViewEventDelegate: NSObject, NMFMapViewTouchDelegate, NMFMapViewCameraDelegate, NMFIndoorSelectionDelegate, NMFOfflineStorageDelegate, NMFTileCoverHelperDelegate {
    private weak var sender: NaverMapControlSender?

    private let initializeConsumeSymbolTapEvents: Bool
    private var animated: Bool = true
    private let offlineStorageHelper: NMFOfflineStorage = NMFOfflineStorage()
    private var isLoaded: Bool = false
    private var tileCoverHelper: NMFTileCoverHelper?

    init(sender: NaverMapControlSender, initializeConsumeSymbolTapEvents: Bool) {
        self.sender = sender
        self.initializeConsumeSymbolTapEvents = initializeConsumeSymbolTapEvents
    }

    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        sender?.onMapTapped(nPoint: NPoint.fromCGPointWithDisplay(point), latLng: latlng)
    }

    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
        sender?.onSymbolTapped(symbol: symbol) ?? initializeConsumeSymbolTapEvents
    }

    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        self.animated = animated
        sender?.onCameraChange(cameraUpdateReason: reason, animated: animated)
    }

    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        sender?.onCameraChange(cameraUpdateReason: reason, animated: animated)
    }

    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        self.animated = animated
        sender?.onCameraChange(cameraUpdateReason: reason, animated: animated)
    }

    func mapViewCameraIdle(_ mapView: NMFMapView) {
        sender?.onCameraIdle()
    }

    func indoorSelectionDidChanged(_ indoorSelection: NMFIndoorSelection?) {
        sender?.onSelectedIndoorChanged(selectedIndoor: indoorSelection)
    }

    func registerDelegates(mapView: NMFMapView) {
        mapView.touchDelegate = self
        mapView.addCameraDelegate(delegate: self)
        mapView.addIndoorSelectionDelegate(delegate: self)
        
        let sharedOfflineStorage = NMFOfflineStorage.shared
        
        offlineStorageHelper.delegate = self
//        sharedOfflineStorage.delegate = self
        
        if tileCoverHelper == nil { tileCoverHelper = NMFTileCoverHelper(mapView) }
        tileCoverHelper!.delegate = self
    }

    func unregisterDelegates(mapView: NMFMapView) {
        mapView.touchDelegate = nil
        mapView.removeCameraDelegate(delegate: self)
        mapView.removeIndoorSelectionDelegate(delegate: self)
        offlineStorageHelper.delegate = nil
        tileCoverHelper?.delegate = nil
    }
    
    func onTileChanged(_ addedTileIds: [NSNumber]?, removedTileIds: [NSNumber]?) {
//        if addedTileIds?.isEmpty == false {
//            let diff = LoadedTiles.shared.addTilesAndCheckUnLoadedTiles(addedTileIds!, mapHashCode: self.hashValue)
//            print("diff: \(diff)")
//            let alreadyLoaded = diff.isEmpty
//            if !isLoaded && alreadyLoaded { onMapLoaded(desc: "maybe") }
//        }
//        if removedTileIds?.isEmpty == false {
//            LoadedTiles.shared.removeTiles(removedTileIds!)
//        }
    }
    
    func offlineStorage(_ storage: NMFOfflineStorage, urlForResourceOf kind: NMFResourceKind, with url: URL) -> URL {
        onMapLoaded(desc: "sure")
//        LoadedTiles.shared.mapLoaded(self.hashValue)
    
        offlineStorageHelper.delegate = nil
        return url
    }
    
    private func onMapLoaded(desc: String) {
        if isLoaded { return }
        do {
            isLoaded = true
            sender?.onMapLoaded()
            print("[swift, \(desc)] onMapLoaded! : \(Date().timeIntervalSince1970)")
        }
    }
}

//private class LoadedTiles {
//    static func removeAllStorageCache(onDone: @escaping () -> Void) {
//        let sharedOfflineStorage = NMFOfflineStorage.shared
//        let isFirst = sharedOfflineStorage.packs == nil
//        if isFirst {
//            sharedOfflineStorage.flushCache { _ in
//                sharedOfflineStorage.resetDatabase(completionHandler: {_ in
//                    onDone()
//                })
//            }
//        }
//    }
//    
//    static let shared = LoadedTiles() // already lazy. see https://developer.apple.com/swift/blog/?id=7
//    
//    private init() {}
//    
//    // todo : load를 Map으로 변경하여, 로드 여부까지 표시할 수 있음 (첫 로드 시점에 true로 변경)
//    
//    // 1. tileId를 통해 tile이 로드되었는지 정보가 필요한 것이다.
//    // 2. 로드되었는지는, map이 로드되었는지 여부와 상관관계를 가진다.
//    
//    typealias TileId = NSNumber
//    typealias MapHashCode = Int
//    
//    // unsafe for thread
//    private var _tiles: Dictionary<TileId, MapHashCode> = [:] // key: TileId, value: mapHashCode
//    private var _loadedHashes: Set<MapHashCode> = [] // MapHashCode
//    var loadedTiles: Array<TileId> {
//        [TileId](_tiles.filter({ _loadedHashes.contains($1) }).keys)
//    }
//    
//    var isFirstLoad: Bool { _tiles.isEmpty }
//    
//    func mapLoaded(_ mapHashCode: MapHashCode) {
//        print("** mapLoaded ** : \(mapHashCode)")
//        _loadedHashes.insert(mapHashCode)
//        print("+++nowLoadedTiles: \(String(describing: loadedTiles))")
//    }
//    
//    // 새로 로드될 타일에 대해서 반환됩니다. 없다면, 빈배열.
//    func addTilesAndCheckUnLoadedTiles(_ tiles: [TileId], mapHashCode: MapHashCode) -> [TileId] {
//        var newLoadTiles: [TileId] = []
//
//        for tile in tiles {
//            let alreadyLoaded = loadedTiles.contains(tile)
//            if !alreadyLoaded {
//                _tiles[tile] = mapHashCode
//                newLoadTiles.append(tile)
//            }
//        }
//
//        return newLoadTiles
//    }
//    
//    func removeTiles(_ tileIdList: [TileId]) {
//        var depentMaps: Set<MapHashCode> = []
//        
//        for tileId in tileIdList {
//            let mapHashCode = _tiles[tileId]
//            _tiles[tileId] = nil
//            if let mapHashCode = mapHashCode {
//                depentMaps.insert(mapHashCode)
//            }
//        }
//        
//        for depentMap in depentMaps {
//            if !_tiles.contains(where: { _, map in depentMap == map }) {
//                _loadedHashes.remove(depentMap)
//            }
//        }
//    }
//}

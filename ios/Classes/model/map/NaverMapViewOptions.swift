import NMapsMap

struct NaverMapViewOptions {
    private let args: Dictionary<String, Any>
    let consumeSymbolTapEvents: Bool

    static func fromMap(_ args: Dictionary<String, Any>) -> NaverMapViewOptions {
        let consumeSymbolTapEvents = asBool(args["consumeSymbolTapEvents"]!)
        return NaverMapViewOptions(args: args, consumeSymbolTapEvents: consumeSymbolTapEvents)
    }

    func updateWithNaverMapView(naverMap: NMFNaverMapView, isFirst: Bool) {
        naverMap.showCompass = false
        naverMap.showZoomControls = false

        let applier = NaverMapApplierImpl(naverMap, isFirst: isFirst)
        try! applier.applyOptions(args: args)
    }
}
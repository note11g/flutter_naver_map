import NMapsMap

class NaverMapViewOptions {
    private let args: Dictionary<String, Any>
    let consumeSymbolTapEvents: Bool

    init(consumeSymbolTapEvents: Bool, args: Dictionary<String, Any>) {
        self.consumeSymbolTapEvents = consumeSymbolTapEvents
        self.args = args
    }

    static func fromMap(_ args: Dictionary<String, Any>) -> NaverMapViewOptions {
        let consumeSymbolTapEvents = asBool(args["consumeSymbolTapEvents"]!)
        return NaverMapViewOptions(consumeSymbolTapEvents: consumeSymbolTapEvents, args: args)
    }

    func updateWithNaverMapView(naverMap: NMFNaverMapView, isFirst: Bool) {
        naverMap.showCompass = false
        naverMap.showZoomControls = false

        let applier = NaverMapApplierImpl(naverMap, isFirst: isFirst)
        try! applier.applyOptions(args: args)
    }
}
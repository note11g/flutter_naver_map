import NMapsMap

internal struct NaverMapViewOptions {
    private let args: Dictionary<String, Any?>
    let consumeSymbolTapEvents: Bool

    static func fromMessageable(_ messageableDict: Dictionary<String, Any?>) -> NaverMapViewOptions {
        let consumeSymbolTapEvents = asBool(messageableDict["consumeSymbolTapEvents"]!)
        return NaverMapViewOptions(args: messageableDict, consumeSymbolTapEvents: consumeSymbolTapEvents)
    }

    func updateWithNaverMapView(naverMap: NMFNaverMapView, isFirst: Bool, customStyleCallbacks: CustomStyleCallbacks? = nil) {
        naverMap.showCompass = false
        naverMap.showZoomControls = false
        naverMap.showScaleBar = false
        naverMap.showLocationButton = false
        naverMap.mapView.logoInteractionEnabled = false

        let applier = NaverMapApplierImpl(naverMap, isFirst: isFirst, customStyleCallbacks: customStyleCallbacks)
        try! applier.applyOptions(args: args)
    }
}

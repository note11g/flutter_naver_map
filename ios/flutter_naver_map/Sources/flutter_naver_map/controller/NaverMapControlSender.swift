import NMapsMap

internal protocol NaverMapControlSender : AnyObject {
    func onMapReady()
    
    func onMapLoaded()

    func onMapTapped(nPoint: NPoint, latLng: NMGLatLng)
    
    func onMapLongTapped(nPoint: NPoint, latLng: NMGLatLng)

    func onSymbolTapped(symbol: NMFSymbol) -> Bool?

    func onCameraChange(cameraUpdateReason: Int, animated: Bool)

    func onCameraIdle()

    func onSelectedIndoorChanged(selectedIndoor: NMFIndoorSelection?)

    func onCustomStyleLoaded()

    func onCustomStyleLoadFailed(exception: any Error)
    
    func dispose()
}

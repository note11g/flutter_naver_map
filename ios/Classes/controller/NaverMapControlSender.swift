import NMapsMap

internal protocol NaverMapControlSender : AnyObject {
    func onMapReady()

    func onMapTapped(nPoint: NPoint, latLng: NMGLatLng)

    func onSymbolTapped(symbol: NMFSymbol) -> Bool?

    func onCameraChange(cameraUpdateReason: Int, animated: Bool)

    func onCameraIdle()

    func onSelectedIndoorChanged(selectedIndoor: NMFIndoorSelection?)
}
import NMapsMap

internal protocol AddableOverlay {
    associatedtype OverlayType: NMFOverlay

    var info: NOverlayInfo { get }

    func createMapOverlay() -> OverlayType

    func toMessageable() -> Dictionary<String, Any?>

    static func fromMessageable(_ v: Any) -> Self

    static func fromOverlay(_ overlay: NMFOverlay, id: String) -> Self
}

func asAddableOverlay(info: NOverlayInfo, json: Any) throws -> any AddableOverlay {
    let d = asDict(json)
    let creator: (Any) -> any AddableOverlay
    switch info.type {
    case .marker: creator = NMarker.fromMessageable
    case .infoWindow: creator = NInfoWindow.fromMessageable
    case .circleOverlay: creator = NCircleOverlay.fromMessageable
    case .groundOverlay: creator = NGroundOverlay.fromMessageable
    case .polygonOverlay: creator = NPolygonOverlay.fromMessageable
    case .polylineOverlay: creator = NPolylineOverlay.fromMessageable
    case .pathOverlay: creator = NPathOverlay.fromMessageable
    case .multipartPathOverlay: creator = NMultipartPathOverlay.fromMessageable
    case .arrowheadPathOverlay: creator = NArrowheadPathOverlay.fromMessageable
    case .locationOverlay: throw NSError()
    }
    return creator(d)
}

func getAddableOverlayFromOverlay(_ overlay: NMFOverlay, info: NOverlayInfo) throws -> any AddableOverlay {
    let creator: (NMFOverlay, String) -> any AddableOverlay
    switch info.type {
    case .marker: creator = NMarker.fromOverlay
    case .infoWindow: creator = NInfoWindow.fromOverlay
    case .circleOverlay: creator = NCircleOverlay.fromOverlay
    case .groundOverlay: creator = NGroundOverlay.fromOverlay
    case .polygonOverlay: creator = NPolygonOverlay.fromOverlay
    case .polylineOverlay: creator = NPolylineOverlay.fromOverlay
    case .pathOverlay: creator = NPathOverlay.fromOverlay
    case .multipartPathOverlay: creator = NMultipartPathOverlay.fromOverlay
    case .arrowheadPathOverlay: creator = NArrowheadPathOverlay.fromOverlay
    case .locationOverlay: throw NSError()
    }
    return creator(overlay, info.id)
}
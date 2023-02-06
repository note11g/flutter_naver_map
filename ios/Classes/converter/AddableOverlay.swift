import NMapsMap

protocol AddableOverlay {
    associatedtype OverlayType: NMFOverlay

    var info: NOverlayInfo { get }

    func createMapOverlay() -> OverlayType

    func toDict() -> Dictionary<String, Any?>

    static func fromJson(_ v: Any) -> Self

    static func fromOverlay(_ overlay: NMFOverlay, id: String) -> Self
}

func asAddableOverlay(info: NOverlayInfo, json: Any) throws -> any AddableOverlay {
    let d = asDict(json)
    let creator: (Any) -> any AddableOverlay
    switch info.type {
    case .marker: creator = NMarker.fromJson
    case .infoWindow: creator = NInfoWindow.fromJson
    case .circleOverlay: creator = NCircleOverlay.fromJson
    case .groundOverlay: creator = NGroundOverlay.fromJson
    case .polygonOverlay: creator = NPolygonOverlay.fromJson
    case .polylineOverlay: creator = NPolylineOverlay.fromJson
    case .pathOverlay: creator = NPathOverlay.fromJson
    case .multipartPathOverlay: creator = NMultipartPathOverlay.fromJson
    case .arrowheadPathOverlay: creator = NArrowheadPathOverlay.fromJson
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
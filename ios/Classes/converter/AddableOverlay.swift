import NMapsMap

protocol AddableOverlay {
    associatedtype OverlayType: NMFOverlay

    var info: NOverlayInfo { get }

    func createMapOverlay() -> OverlayType

    func toDict() -> Dictionary<String, Any?>

    static func fromJson(_ v: Any) -> Self

    static func fromOverlay(_ overlay: NMFOverlay, id: String) -> Self
}


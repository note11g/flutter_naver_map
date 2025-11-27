enum NOverlayType: String {
    case marker = "ma"
    case infoWindow = "in"
    case circleOverlay = "ci"
    case groundOverlay = "gr"
    case polygonOverlay = "pg"
    case polylineOverlay = "pl"
    case pathOverlay = "pa"
    case multipartPathOverlay = "mp"
    case arrowheadPathOverlay = "ah"
    case locationOverlay = "lo"
    case clusterableMarker = "cm"
    
    var isLazy: Bool {
        switch(self) {
        case .clusterableMarker:
            true
        default:
            false
        }
    }
}

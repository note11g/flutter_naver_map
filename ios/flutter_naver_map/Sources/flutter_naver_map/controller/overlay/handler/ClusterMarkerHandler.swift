import NMapsMap
import Flutter

internal protocol ClusterMarkerHandler {
    func syncClusterMarker(_ marker: NMFMarker, rawClusterMarker: Any, success: (Any?) -> ())
}

internal extension ClusterMarkerHandler {
    func handleClusterMarker(
        marker: NMFOverlay, 
        method: String,
        arg: Any?,
        result: @escaping FlutterResult) {
        let marker = marker as! NMFMarker
        
        switch method {
        case syncClusterMarkerName:
            syncClusterMarker(marker, rawClusterMarker: arg!, success: result)
        default: result(FlutterMethodNotImplemented)
        }
    }
}

internal let syncClusterMarkerName = "lSyncClusterMarker"

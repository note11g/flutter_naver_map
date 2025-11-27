import NMapsMap
import Flutter

internal protocol ClusterableMarkerHandler: MarkerHandler, ClusterMarkerHandler {
    
}

internal extension ClusterableMarkerHandler {
    func handleClusterableMarker(
        marker: NMFOverlay,
        method: String,
        arg: Any?,
        result: @escaping FlutterResult)
    {
        let marker = marker as! NMFMarker
        let isMarkerClusterMode = method.starts(with: "l")
        
        if isMarkerClusterMode {
            return handleClusterMarker(marker: marker, method: method, arg: arg, result: result)
        }
        
        switch method {
        default: handleMarker(marker: marker, method: method, args: arg, result: result)
        }
    }
}

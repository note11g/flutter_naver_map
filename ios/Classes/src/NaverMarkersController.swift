//
//  NaverMarkersController.swift
//  naver_map_plugin
//
//  Created by Maximilian on 2020/08/26.
//

import NMapsMap
import Flutter

class NMarkerController: NSObject {
    let marker: NMFMarker
    let registrar: FlutterPluginRegistrar
    let id: String
    var infoWindowTitle: String?
    
    init(json: NSDictionary, registrar: FlutterPluginRegistrar) {
        assert(json["markerId"] != nil && json["position"] != nil)
        marker = NMFMarker()
        self.id = json["markerId"] as! String
        self.registrar = registrar
        
        super.init()
        marker.userInfo = ["marker" : self]
        
        interpret(json: json)
    }
    
    func interpret(json: NSDictionary) {
        if let positionData = json["position"] {
            marker.position = toLatLng(json: positionData)
        }
        if let alpha = json["alpha"] as? CGFloat {
            marker.alpha = alpha
        }
        if let flat = json["flat"] as? Bool {
            marker.isFlat = flat
        }
        if let captionText = json["captionText"] as? String {
            marker.captionText = captionText
        }
        if let captionTextSize = json["captionTextSize"] as? CGFloat{
            marker.captionTextSize = captionTextSize
        }
        if let captionColor = json["captionColor"] as? NSNumber {
            marker.captionColor = toColor(colorNumber: captionColor)
        }
        if let captionHaloColor = json["captionHaloColor"] as? NSNumber{
            marker.captionHaloColor = toColor(colorNumber: captionHaloColor)
        }
        if let width = json["width"] as? CGFloat {
            marker.width = width
        }
        if let height = json["height"] as? CGFloat {
            marker.height = height
        }
        if let maxZoom = json["maxZoom"] as? Double{
            marker.maxZoom = maxZoom
        }
        if let minZoom = json["minZoom"] as? Double{
            marker.minZoom = minZoom
        }
        if let angle = json["angle"] as? CGFloat {
            marker.angle = angle
        }
        if let anchorList = json["anchor"] as? Array<Double> {
            marker.anchor = CGPoint(x: anchorList[0], y: anchorList[1])
        }
        if let captionRequestWidth = json["captionRequestedWidth"] as? CGFloat {
            marker.captionRequestedWidth = captionRequestWidth
        }
        if let captionMaxZoom = json["captionMaxZoom"] as? Double {
            marker.captionMaxZoom = captionMaxZoom
        }
        if let captionMinZoom = json["captionMinZoom"] as? Double {
            marker.captionMinZoom = captionMinZoom
        }
        if let captionOffset = json["captionOffset"] as? CGFloat {
            marker.captionOffset = captionOffset
        }
        if let isCaptionPerspectiveEnable = json["captionPerspectiveEnabled"] as? Bool {
            marker.iconPerspectiveEnabled = isCaptionPerspectiveEnable
        }
        if let zIndex = json["zIndex"] as? Int {
            marker.zIndex = zIndex
        }
        if let globalZIndex = json["globalZIndex"] as? Int {
            marker.globalZIndex = globalZIndex
        }
        if let iconTintColor = json["iconTintColor"] as? NSNumber{
            marker.iconTintColor = toColor(colorNumber: iconTintColor)
        }
        if let subCaptionText = json["subCaptionText"] as? String {
            marker.subCaptionText = subCaptionText
        }
        if let subCaptionTextSize = json["subCaptionTextSize"] as? CGFloat {
            marker.subCaptionTextSize = subCaptionTextSize
        }
        if let subCaptionColor = json["subCaptionColor"] as? NSNumber {
            marker.subCaptionColor = toColor(colorNumber: subCaptionColor)
        }
        if let subCaptionHaloColor = json["subCaptionHaloColor"] as? NSNumber {
            marker.subCaptionHaloColor = toColor(colorNumber: subCaptionHaloColor)
        }
        if let subCaptionRequestedWidth = json["subCaptionRequestedWidth"] as? CGFloat {
            marker.subCaptionRequestedWidth = subCaptionRequestedWidth
        }
        if let assetName = json["icon"] as? String,
           let overlayImage = toOverlayImage(assetName:assetName, registrar: registrar) {
            marker.iconImage = overlayImage
        }
        if let imagePath = json["iconFromPath"] as? String,
           let overlayImage = toOverlayImageFromFile(imagePath: imagePath) {
            marker.iconImage = overlayImage
        }
        if let imageByteArray = json["iconFromByteArray"] as? FlutterStandardTypedData,
           let overlayImage = toOverlayImageFromByteArray(data: imageByteArray.data) {
            marker.iconImage = overlayImage
        }
        if let infoWindowText = json["infoWindow"] as? String {
            self.infoWindowTitle = infoWindowText
        }
    }
    
    func setMap(_ naverMap: NMFNaverMapView?) {
        self.marker.mapView = naverMap?.mapView
    }
}

class NaverMarkersController: NSObject {
    private var idToController = Dictionary<String, NMarkerController>()
    let naverMap: NMFNaverMapView
    let registrar: FlutterPluginRegistrar
    let infoWindow = NMFInfoWindow()
    var dataSource = NMFInfoWindowDefaultTextSource.data()
    let touchHandler: (NMFOverlay)->Bool
    
    var infoWindowMarkerId: String?
    
    init(naverMap: NMFNaverMapView, registrar: FlutterPluginRegistrar, touchHandler: @escaping ((NMFOverlay)->Bool)) {
        self.naverMap = naverMap
        self.registrar = registrar
        self.touchHandler = touchHandler
    }
    
    func add(jsonArray: Array<Any>) {
        jsonArray.forEach { (json) in
            DispatchQueue.main.async {
                if let data = json as? NSDictionary {
                    let marker = NMarkerController(json: data, registrar: self.registrar)
                    marker.setMap(self.naverMap)
                    marker.marker.touchHandler = self.touchHandler
                    self.idToController[marker.id] = marker
                }
            }
        }
    }
    
    func remove(jsonArray: Array<Any>) {
        jsonArray.forEach { (rawId) in
            DispatchQueue.main.async {
                if let id = rawId as? String, let controller = self.idToController[id] {
                    controller.marker.touchHandler = nil
                    controller.setMap(nil)
                    self.idToController.removeValue(forKey: id)
                }
            }
        }
    }
    
    func modify(jsonArray: Array<Any>) {
        jsonArray.forEach { (json) in
            DispatchQueue.main.async {
                if let data = json as? NSDictionary {
                    let id = data["markerId"] as! String
                    self.idToController[id]?.interpret(json: data)
                }
            }
        }
    }
    
    func toggleInfoWindow(_ marker: NMarkerController) -> Bool{
        if let title = marker.infoWindowTitle {
            if infoWindowMarkerId != nil && infoWindowMarkerId == marker.id {
                infoWindow.close()
                infoWindowMarkerId = nil
            }else {
                dataSource.title = title
                infoWindow.dataSource = dataSource
                infoWindow.open(with: marker.marker)
                infoWindowMarkerId = marker.id
            }
        }
        return true
    }
    
}

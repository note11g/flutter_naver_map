//
//  NaverCircleController.swift
//  naver_map_plugin
//
//  Created by Maximilian on 2020/08/31.
//

import NMapsMap
import Flutter

class NCircleController: NSObject{
    let circle: NMFCircleOverlay
    let id: String
    
    init(json: NSDictionary) {
        assert(json["overlayId"] != nil
            && json["center"] != nil
            && json["radius"] != nil)
        circle = NMFCircleOverlay()
        self.id = json["overlayId"] as! String
        
        super.init()
        circle.userInfo = ["circle" : self]
        
        interprete(json: json)
    }
    
    func interprete(json: NSDictionary){
        if let centerData = json["center"] {
            circle.center = toLatLng(json: centerData)
        }
        if let radius = json["radius"] as? Double {
            circle.radius = radius
        }
        if let color = json["color"] as? NSNumber {
            circle.fillColor = toColor(colorNumber: color)
        }
        if let outlineColor = json["outlineColor"] as? NSNumber {
            circle.outlineColor = toColor(colorNumber: outlineColor)
        }
        if let outlineWidth = json["outlineWidth"] as? Double {
            circle.outlineWidth = outlineWidth
        }
        if let zIndex = json["zIndex"] as? Int {
            circle.zIndex = zIndex
        }
        if let globalZIndex = json["globalZIndex"] as? Int {
            circle.globalZIndex = globalZIndex
        }
        if let minZoom = json["minZoom"] as? Double {
            circle.minZoom = minZoom
        }
        if let maxZoom = json["maxZoom"] as? Double {
            circle.maxZoom = maxZoom
        }
    }
    
    func setMap(_ naverMap: NMFNaverMapView?){
        circle.mapView = naverMap?.mapView
    }
}

class NaverCircleController: NSObject{
    private var idToController = Dictionary<String, NCircleController>()
    let naverMap: NMFNaverMapView
    let touchHandler: (NMFOverlay)->Bool
    
    init(naverMap: NMFNaverMapView, touchHandler: @escaping (NMFOverlay)->Bool) {
        self.naverMap = naverMap
        self.touchHandler = touchHandler
    }
    
    func add(jsonArray: Array<Any>) {
        jsonArray.forEach { (json) in
            DispatchQueue.main.async {
                if let data = json as? NSDictionary {
                    let circleToAdd = NCircleController(json: data)
                    circleToAdd.setMap(self.naverMap)
                    circleToAdd.circle.touchHandler = self.touchHandler
                    self.idToController[circleToAdd.id] = circleToAdd
                }
            }
        }
    }
    
    func remove(jsonArray: Array<Any>) {
        jsonArray.forEach { (rawId) in
            DispatchQueue.main.async {
                if let id = rawId as? String, let circleToRemove = self.idToController[id] {
                    circleToRemove.circle.touchHandler = nil
                    circleToRemove.setMap(nil)
                    self.idToController.removeValue(forKey: id)
                }
            }
        }
    }
    
    func modify(jsonArray: Array<Any>) {
        jsonArray.forEach { (json) in
            DispatchQueue.main.async {
                if let data = json as? NSDictionary {
                    let id = data["overlayId"] as! String
                    self.idToController[id]?.interprete(json: data)
                }
            }
        }
    }
    
}

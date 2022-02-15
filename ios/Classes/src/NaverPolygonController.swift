//
//  NaverPolygonController.swift
//  naver_map_plugin
//
//  Created by Maximilian on 2020/11/26.
//

import Foundation
import Flutter
import NMapsMap

class NPolygonController: NSObject {
    var polygonOverlay : NMFPolygonOverlay
    let id : String
    
    init(json: NSDictionary) {
        assert(json["polygonOverlayId"] != nil && json["coords"] != nil)
        polygonOverlay = NMFPolygonOverlay()
        self.id = json["polygonOverlayId"] as! String
        
        super.init()
        polygonOverlay.userInfo = ["polygon" : self]
        interpret(json: json)
    }
    
    func interpret(json: NSDictionary) {
        var shape = NMGPolygon<AnyObject>()
        if let coordData = json["coords"] as? Array<Any>, coordData.count > 2 {
            var coords : Array<AnyObject> = []
            coordData.forEach { (latLngData) in
                coords.append(toLatLng(json: latLngData))
            }
            if toLatLng(json: coordData.first!) != toLatLng(json: coordData.last!) {
                coords.append(toLatLng(json: coordData.first!))
            }
            let line = NMGLineString(points: coords)
            shape = NMGPolygon(ring: line)
        }
        if let color = json["color"] as? NSNumber {
            polygonOverlay.fillColor = toColor(colorNumber: color)
        }
        if let outlineColor = json["outlineColor"] as? NSNumber {
            polygonOverlay.outlineColor = toColor(colorNumber: outlineColor)
        }
        if let outlineWidth = json["outlineWidth"] as? UInt {
            polygonOverlay.outlineWidth = outlineWidth
        }
        if let globalZIndex = json["globalZIndex"] as? Int {
            polygonOverlay.globalZIndex = globalZIndex
        }
        if let holeData = json["holes"] as? Array<Any> {
            holeData.forEach { data in
                if let coordData =  data as? Array<Any> {
                    var coords : Array<NMGLatLng> = []
                    coordData.forEach { (latLngData) in
                        coords.append(toLatLng(json: latLngData))
                    }
                    if coords.first != coords.last {
                        coords.append(toLatLng(json: coordData.first!))
                    }
                    shape.addInteriorRing(NMGLineString(points: coords))
                }
            }
        }
        polygonOverlay.polygon = shape
    }
    
    func setMap(_ map: NMFNaverMapView?) {
        polygonOverlay.polygon.exteriorRing.points.forEach { point in
            print(point)
            if let latlng = point as? NMGLatLng {
                print("lat: \(latlng.lat), lng: \(latlng.lng)")
            }
        }
        polygonOverlay.mapView = map?.mapView
    }
}


class NaverPolygonController: NSObject {
    private var idToController = Dictionary<String, NPolygonController>()
    let naverMap: NMFNaverMapView
    let touchHandler: (NMFOverlay) -> Bool
    
    init(naverMap: NMFNaverMapView, touchHandler: @escaping (NMFOverlay) -> Bool) {
        self.naverMap = naverMap
        self.touchHandler = touchHandler
    }
    
    func add(jsonArray: Array<Any>) {
        jsonArray.forEach{ json in
            DispatchQueue.main.async {
                if let data = json as? NSDictionary {
                    let polygon = NPolygonController(json: data)
                    polygon.setMap(self.naverMap)
                    polygon.polygonOverlay.touchHandler = self.touchHandler
                    self.idToController[polygon.id] = polygon
                }
            }
        }
    }
    
    func remove(jsonArray: Array<Any>) {
        jsonArray.forEach { (rawId) in
            DispatchQueue.main.async {
                if let id = rawId as? String, let polygonToRemove = self.idToController[id] {
                    polygonToRemove.polygonOverlay.touchHandler = nil
                    polygonToRemove.setMap(nil)
                    self.idToController.removeValue(forKey: id)
                }
            }
        }
    }
    
    func modify(jsonArray: Array<Any>) {
        jsonArray.forEach { (json) in
            DispatchQueue.main.async {
                if let data = json as? NSDictionary {
                    let id = data["polygonOverlayId"] as! String
                    self.idToController[id]?.interpret(json: data)
                }
            }
        }
    }
}

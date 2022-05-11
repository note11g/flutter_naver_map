//
//  NaverPathsController.swift
//  naver_map_plugin
//
//  Created by Maximilian on 2020/08/28.
//

import Foundation
import Flutter
import NMapsMap

class NPathController: NSObject {
    let path:NMFPath
    let id: String
    let registrar: FlutterPluginRegistrar
    
    init(json: NSDictionary, registrar: FlutterPluginRegistrar) {
        assert(json["pathOverlayId"] != nil && json["coords"] != nil)
        path = NMFPath()
        self.id = json["pathOverlayId"] as! String
        self.registrar = registrar
        
        super.init()
        path.userInfo = ["path" : self]
        
        interprete(json)
    }// init
    
    func interprete(_ json: NSDictionary){
        if let coordData = json["coords"] as? Array<Any>, coordData.count > 1 {
            var coords: Array<NMGLatLng> = []
            coordData.forEach { (latLngData) in
                coords.append(toLatLng(json: latLngData))
            }
            path.path = NMGLineString(points: coords)
        }
        if let globalZIndex = json["globalZIndex"] as? Int {
            path.globalZIndex = globalZIndex
        }
        if let hideCollidedCaptions = json["hideCollidedCaptions"] as? Bool{
            path.isHideCollidedCaptions = hideCollidedCaptions
        }
        if let hideCollidedMarkers = json["hideCollidedMarkers"] as? Bool{
            path.isHideCollidedMarkers = hideCollidedMarkers
        }
        if let hideCollidedSymbols = json["hideCollidedSymbols"] as? Bool{
            path.isHideCollidedSymbols = hideCollidedSymbols
        }
        if let color = json["color"] as? NSNumber {
            path.color = toColor(colorNumber: color)
        }
        if let outlineColor = json["outlineColor"] as? NSNumber{
            path.outlineColor = toColor(colorNumber: outlineColor)
        }
        if let outlineWidth = json["outlineWidth"] as? CGFloat {
            path.outlineWidth = outlineWidth
        }
        if let passedColors = json["passedColor"] as? NSNumber{
            path.passedColor = toColor(colorNumber: passedColors)
        }
        if let passedOutlineColor = json["passedOutlineColor"] as? NSNumber{
            path.passedOutlineColor = toColor(colorNumber: passedOutlineColor)
        }
        if let patternImage = json["patternImage"] as? String {
            path.patternIcon = toOverlayImage(assetName: patternImage, registrar: registrar)
        }
        if let patternImageFromFile = json["patternImageFromPath"] as? String {
            path.patternIcon = toOverlayImageFromFile(imagePath: patternImageFromFile)
        }
        if let patternInterval = json["patternInterval"] as? UInt {
            path.patternInterval = patternInterval
        }
        if let progress = json["progress"] as? Double{
            path.progress = progress
        }
        if let width = json["width"] as? CGFloat {
            path.width = width
        }
    }
    
    func setMap(_ map:NMFNaverMapView?){
        path.mapView = map?.mapView
    }
}

class NaverPathController:NSObject {
    private var idToController = Dictionary<String, NPathController>()
    let registrar: FlutterPluginRegistrar
    let naverMap: NMFNaverMapView
    let touchHandler: (NMFOverlay)->Bool
    
    init(naverMap: NMFNaverMapView, registrar: FlutterPluginRegistrar, touchHandler: @escaping (NMFOverlay)->Bool) {
        self.naverMap = naverMap
        self.registrar = registrar
        self.touchHandler = touchHandler
    }
    
    func set(jsonArray: Array<Any>) {
        jsonArray.forEach { (json) in
            DispatchQueue.main.async {
                if let data = json as? NSDictionary {
                    if let id = data["pathOverlayId"] as? String, self.idToController[id] != nil {
                        // 객체 update.. 속성값 변경
                        self.idToController[id]?.interprete(data)
                        return
                    }
                    let pathToAdd = NPathController(json: data, registrar: self.registrar)
                    pathToAdd.setMap(self.naverMap)
                    pathToAdd.path.touchHandler = self.touchHandler
                    self.idToController[pathToAdd.id] = pathToAdd
                }
            }
        }
    }
    
    func remove(jsonArray: Array<Any>) {
        jsonArray.forEach { (rawId) in
            DispatchQueue.main.async {
                if let id = rawId as? String, let pathToRemove = self.idToController[id] {
                    pathToRemove.path.touchHandler = nil
                    pathToRemove.setMap(nil)
                    self.idToController.removeValue(forKey: id)
                }
            }
        }
    }
    
}

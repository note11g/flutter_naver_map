//
//  NaverMapController.swift
//  naver_map_plugin
//
//  Created by Maximilian on 2020/08/19.
//

import UIKit
import Flutter
import NMapsMap

protocol NaverMapOptionSink {
    func setIndoorEnable(_ indoorEnable: Bool)
    func setNightModeEnable(_ nightModeEnable: Bool)
    func setLiteModeEnable(_ liteModeEnable: Bool)
    func setMapType(_ typeIndex: Int)
    func setBuildingHeight(_ buildingHeight: Float)
    func setSymbolScale(_ symbolScale: CGFloat)
    func setSymbolPerspectiveRatio(_ symbolPerspectiveRatio: CGFloat)
    func setActiveLayers(_ activeLayers: Array<Any>)
    func setContentPadding(_ paddingData: Array<CGFloat>)
    func setMaxZoom(_ maxZoom: Double)
    func setMinZoom(_ minZoom: Double)
    
    func setRotationGestureEnable(_ rotationGestureEnable: Bool)
    func setScrollGestureEnable(_ scrollGestureEnable: Bool)
    func setTiltGestureEnable(_ tiltGestureEnable: Bool)
    func setZoomGestureEnable(_ zoomGestureEnable: Bool)
    func setLocationTrackingMode(_ locationTrackingMode: UInt)
    func setLocationButtonEnable(_ locationButtonEnable: Bool)
}


class NaverMapController: NSObject, FlutterPlatformView, NaverMapOptionSink, NMFMapViewTouchDelegate, NMFMapViewCameraDelegate, NMFAuthManagerDelegate {
    
    var mapView : NMFMapView?
    var naverMap : NMFNaverMapView?
    let viewId : Int64
    
    var markersController: NaverMarkersController?
    var pathController: NaverPathController?
    var circleController: NaverCircleController?
    var polygonController: NaverPolygonController?
    
    var channel : FlutterMethodChannel?
    var registrar : FlutterPluginRegistrar?
    
    init(viewId: Int64, frame: CGRect, registrar: FlutterPluginRegistrar, argument: NSDictionary?) {
        self.viewId = viewId
        self.registrar = registrar
        
        // need more http connections during getting map tile (default : 4)
        URLSession.shared.configuration.httpMaximumConnectionsPerHost = 8
        
        // property set
        naverMap = NMFNaverMapView(frame: frame)
        mapView = naverMap!.mapView
        channel = FlutterMethodChannel(name: "naver_map_plugin_\(viewId)",
                                       binaryMessenger: registrar.messenger())
        super.init()
        markersController = NaverMarkersController(naverMap: naverMap!,
                                                   registrar: registrar,
                                                   touchHandler: overlayTouchHandler(overlay:))
        pathController = NaverPathController(naverMap: naverMap!,
                                             registrar: registrar,
                                             touchHandler: overlayTouchHandler(overlay:))
        circleController = NaverCircleController(naverMap: naverMap!,
                                                 touchHandler: overlayTouchHandler(overlay:))
        polygonController = NaverPolygonController(naverMap: naverMap!,
                                                   touchHandler: overlayTouchHandler(overlay:))
        channel?.setMethodCallHandler(handle(call:result:))
        
        // map view 설정
        NMFAuthManager.shared().delegate = self as NMFAuthManagerDelegate // for debug

        mapView!.touchDelegate = self
        mapView!.addCameraDelegate(delegate: self)
        if let arg = argument {
            if let initialPositionData = arg["initialCameraPosition"] {
                if initialPositionData is NSDictionary {
                    mapView!.moveCamera(NMFCameraUpdate(position: toCameraPosition(json: initialPositionData)))
                }
            }
            if let options = arg["options"] as? NSDictionary {
                interpretMapOption(option: options, sink: self)
            }
            if let markerData = arg["markers"] as? Array<Any> {
                markersController?.add(jsonArray: markerData)
            }
            if let pathData = arg["paths"] as? Array<Any> {
                pathController?.set(jsonArray: pathData)
            }
            if let circleData = arg["circles"] as? Array<Any> {
                circleController?.add(jsonArray: circleData)
            }
            if let polygonData = arg["polygons"] as? Array<Any> {
                polygonController?.add(jsonArray: polygonData)
            }
        }
        
        // 제대로 동작하지 않는 컨트롤러 UI로 원인이 밝혀지기 전까진 강제 비활성화.
        naverMap!.showZoomControls = false
        naverMap!.showIndoorLevelPicker = false
    }
    
    func view() -> UIView {
        return naverMap!
    }
    
    func handle(call: FlutterMethodCall, result:@escaping FlutterResult) {
        switch call.method {
        case "map#clearMapView":
            mapView = nil
            naverMap = nil
            markersController = nil
            polygonController = nil
            pathController = nil
            circleController = nil
            registrar = nil
            channel = nil
            print("NaverMapController 인스턴스 속성, 메모리 해제");
            break
        case "map#waitForMap":
            result(nil)
            break
        case "map#update":
            if let arg = call.arguments as! NSDictionary?, let option = arg["options"] as? NSDictionary {
                interpretMapOption(option: option, sink: self)
                result(true)
            } else {
                result(false)
            }
            break
        case "map#type":
            if let arg = call.arguments as! NSDictionary?, let type = arg["mapType"] as? Int {
                setMapType(type)
                result(nil)
            }
        case "map#getVisibleRegion":
            let bounds = mapView!.contentBounds
            result(latlngBoundToJson(bound: bounds))
            break
        case "map#getPosition":
            let position = mapView!.cameraPosition
            result(cameraPositionToJson(position: position))
            break
        case "tracking#mode":
            if let arg = call.arguments as! NSDictionary? {
                setLocationTrackingMode(arg["locationTrackingMode"] as! UInt)
                result(true)
            } else {
                result(false)
            }
            break
        case "map#getSize" :
            let width = CGFloat(mapView!.mapWidth)
            let height = CGFloat(mapView!.mapHeight)
            let resolution = UIScreen.main.nativeBounds.width / UIScreen.main.bounds.width
            let data : Dictionary<String, Int> = [
                "width" : Int(round(width * resolution)),
                "height" : Int(round(height * resolution))
            ]
            result(data)
            break
        case "meter#dp" :
            let meterPerPx = mapView!.projection.metersPerPixel().advanced(by: 0.0)
            let density = Double.init(UIScreen.main.scale)
            result(meterPerPx*density)
            break
        case "meter#px":
            let meterPerPx = mapView!.projection.metersPerPixel().advanced(by: 0.0)
            result(meterPerPx)
            break
        case "camera#move" :
            if let arg = call.arguments as? NSDictionary {
                let update = toCameraUpdate(json: arg["cameraUpdate"]!)
                let isAnimate = arg["animation"] as? Bool ?? true
                if isAnimate { update.animation = .easeOut }
                mapView!.moveCamera(update, completion: { isCancelled in
                    result(nil)
                })
            } else {
                result(nil)
            }
            break
        case "map#capture" :
            let dir = NSTemporaryDirectory()
            let fileName = "\(NSUUID().uuidString).jpg"
            if let tmpFileUrl = NSURL.fileURL(withPathComponents: [dir, fileName]) {
                DispatchQueue.main.async {
                    self.naverMap!.takeSnapShot({ (image) in
                        if let data = image.jpegData(compressionQuality: 1.0) ?? image.pngData() {
                            do{
                                try data.write(to: tmpFileUrl)
                                self.channel?.invokeMethod("snapshot#done", arguments: ["path" : tmpFileUrl.path])
                            }catch {
                                self.channel?.invokeMethod("snapshot#done", arguments: ["path" : nil])
                            }
                        }else {
                            self.channel?.invokeMethod("snapshot#done", arguments: ["path" : nil])
                        }
                    })
                }
            }
            result(nil)
            break
        case "map#padding":
            if let arg = call.arguments as? NSDictionary {
                if let top = arg["top"] as? CGFloat, let left = arg["left"] as? CGFloat,
                   let right = arg["right"] as? CGFloat, let bottom = arg["bottom"] as? CGFloat {
                    mapView!.contentInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
                }
            }
            result(nil)
            break
        case "circleOverlay#update" :
            if let arg = call.arguments as? NSDictionary {
                if let dataToAdd = arg["circlesToAdd"] as? Array<Any> {
                    circleController?.add(jsonArray: dataToAdd)
                }
                if let dataToModify = arg["circlesToChange"] as? Array<Any> {
                    circleController?.modify(jsonArray: dataToModify)
                }
                if let dataToRemove = arg["circleIdsToRemove"] as? Array<Any>{
                    circleController?.remove(jsonArray: dataToRemove)
                }
            }
            result(nil)
            break
        case "pathOverlay#update" :
            if let arg = call.arguments as? NSDictionary {
                if let dataToAdd = arg["pathToAddOrUpdate"] as? Array<Any> {
                    pathController?.set(jsonArray: dataToAdd)
                }
                if let dataToRemove = arg["pathIdsToRemove"] as? Array<Any>{
                    pathController?.remove(jsonArray: dataToRemove)
                }
            }
            result(nil)
            break
        case "polygonOverlay#update" :
            if let arg = call.arguments as? NSDictionary {
                if let dataToAdd = arg["polygonToAdd"] as? Array<Any> {
                    polygonController?.add(jsonArray: dataToAdd)
                }
                if let dataToModify = arg["polygonToChange"] as? Array<Any> {
                    polygonController?.modify(jsonArray: dataToModify)
                }
                if let dataToRemove = arg["polygonToRemove"] as? Array<Any>{
                    polygonController?.remove(jsonArray: dataToRemove)
                }
            }
            result(nil)
        case "markers#update" :
            if let arg = call.arguments as? NSDictionary {
                if let dataToAdd = arg["markersToAdd"] as? Array<Any> {
                    markersController?.add(jsonArray: dataToAdd)
                }
                if let dataToModify = arg["markersToChange"] as? Array<Any> {
                    markersController?.modify(jsonArray: dataToModify)
                }
                if let dataToRemove = arg["markerIdsToRemove"] as? Array<Any>{
                    markersController?.remove(jsonArray: dataToRemove)
                }
            }
            result(nil)
            break
        case "LO#set#position" :
            if let arg = call.arguments as? NSDictionary, let data = arg["position"] {
                let latLng = toLatLng(json: data)
                mapView!.locationOverlay.location = latLng
            }
            result(nil)
            break
        case "LO#set#bearing" :
            if let arg = call.arguments as? NSDictionary, let bearing = arg["bearing"] as? NSNumber {
                mapView!.locationOverlay.heading = CGFloat(bearing.floatValue)
            }
            result(nil)
            break
        default:
            print("지정되지 않은 메서드콜 함수명이 들어왔습니다.\n함수명 : \(call.method)")
        }
    }
    
    // ==================== naver map camera delegate ==================
    
    // onCameraChange
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        var r = 0;
        switch reason {
        case NMFMapChangedByGesture:
            r = 1
            break
        case NMFMapChangedByControl:
            r = 2
            break
        case NMFMapChangedByLocation:
            r = 3
            break;
        default:
            r = 0;
        }
        self.channel?.invokeMethod("camera#move",
                                   arguments: ["position" : latlngToJson(latlng: mapView.cameraPosition.target),
                                               "reason" : r,
                                               "animated" : animated])
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        self.channel?.invokeMethod("camera#idle" , arguments: nil)
    }
    
    // ========================== About Map Option ==============================
    func interpretMapOption(option: NSDictionary, sink: NaverMapOptionSink){
        if let indoorEnable = option["indoorEnable"] as? Bool {
            sink.setIndoorEnable(indoorEnable)
        }
        if let nightModeEnable = option["nightModeEnable"] as? Bool {
            sink.setNightModeEnable(nightModeEnable)
        }
        if let liteModeEnable = option["liteModeEnable"] as? Bool {
            sink.setLiteModeEnable(liteModeEnable)
        }
        if let mapType = option["mapType"] as? Int {
            sink.setMapType(mapType)
        }
        if let height = option["buildingHeight"] as? Float {
             sink.setBuildingHeight(height)
        }
        if let scale = option["symbolScale"] as? CGFloat {
            sink.setSymbolScale(scale)
        }
        if let ratio = option["symbolPerspectiveRatio"] as? CGFloat{
            sink.setSymbolPerspectiveRatio(ratio)
        }
        if let layers = option["activeLayers"] as? Array<Any> {
            sink.setActiveLayers(layers)
        }
        if let rotationGestureEnable = option["rotationGestureEnable"] as? Bool {
            sink.setRotationGestureEnable(rotationGestureEnable)
        }
        if let scrollGestureEnable = option["scrollGestureEnable"] as? Bool {
            sink.setScrollGestureEnable(scrollGestureEnable)
        }
        if let tiltGestureEnable = option["tiltGestureEnable"] as? Bool {
            sink.setTiltGestureEnable(tiltGestureEnable)
        }
        if let zoomGestureEnable = option["zoomGestureEnable"] as? Bool{
            sink.setZoomGestureEnable(zoomGestureEnable)
        }
        if let locationTrackingMode = option["locationTrackingMode"] as? UInt {
            sink.setLocationTrackingMode(locationTrackingMode)
        }
        if let locationButtonEnable = option["locationButtonEnable"] as? Bool{
           sink.setLocationButtonEnable(locationButtonEnable)
        }
        if let paddingData = option["contentPadding"] as? Array<CGFloat> {
            sink.setContentPadding(paddingData)
        }
        if let maxZoom = option["maxZoom"] as? Double{
            sink.setMaxZoom(maxZoom)
        }
        if let minZoom = option["minZoom"] as? Double{
            sink.setMinZoom(minZoom)
        }
    }
    
    // Naver touch Delegate method
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        channel?.invokeMethod("map#onTap", arguments: ["position" : [latlng.lat, latlng.lng]])
    }
    
    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
        channel?.invokeMethod("map#onSymbolClick",
                              arguments: ["position" : latlngToJson(latlng: symbol.position),
                                          "caption" : symbol.caption!])
        return false
    }
    
    // naver overlay touch handler
    func overlayTouchHandler(overlay: NMFOverlay) -> Bool {
        if let marker = overlay.userInfo["marker"] as? NMarkerController {
            channel?.invokeMethod("marker#onTap", arguments: ["markerId" : marker.id,
                                                              "iconWidth" :  pxFromPt(marker.marker.width),
                                                              "iconHeight" : pxFromPt(marker.marker.height)])
            return markersController!.toggleInfoWindow(marker)
        } else if let path = overlay.userInfo["path"] as? NPathController {
            channel?.invokeMethod("path#onTap",
                                  arguments: ["pathId" , path.id])
            return true
        } else if let circle = overlay.userInfo["circle"] as? NCircleController{
            channel?.invokeMethod("circle#onTap",
                                  arguments: ["overlayId" : circle.id])
            return true
        } else if let polygon = overlay.userInfo["polygon"] as? NPolygonController {
            channel?.invokeMethod("polygon#onTap",
                                  arguments: ["polygonOverlayId" : polygon.id])
            return true
        }
        return false
    }
    
    // naver map option sink method
    func setIndoorEnable(_ indoorEnable: Bool) {
        mapView!.isIndoorMapEnabled = indoorEnable
    }
    
    func setNightModeEnable(_ nightModeEnable: Bool) {
        mapView!.isNightModeEnabled = nightModeEnable
    }
    
    func setLiteModeEnable(_ liteModeEnable: Bool) {
        mapView!.liteModeEnabled = liteModeEnable
    }
    
    func setMapType(_ typeIndex: Int) {
        let type = NMFMapType(rawValue: typeIndex)!
        mapView!.mapType = type
    }
    
    func setBuildingHeight(_ buildingHeight: Float) {
        mapView!.buildingHeight = buildingHeight
    }
    
    func setSymbolScale(_ symbolScale: CGFloat) {
        mapView!.symbolScale = symbolScale
    }
    
    func setSymbolPerspectiveRatio(_ symbolPerspectiveRatio: CGFloat) {
        mapView!.symbolPerspectiveRatio = symbolPerspectiveRatio
    }
    
    func setActiveLayers(_ activeLayers: Array<Any>) {
        mapView!.setLayerGroup(NMF_LAYER_GROUP_BUILDING, isEnabled: false)
        mapView!.setLayerGroup(NMF_LAYER_GROUP_TRAFFIC, isEnabled: false)
        mapView!.setLayerGroup(NMF_LAYER_GROUP_TRANSIT, isEnabled: false)
        mapView!.setLayerGroup(NMF_LAYER_GROUP_BICYCLE, isEnabled: false)
        mapView!.setLayerGroup(NMF_LAYER_GROUP_MOUNTAIN, isEnabled: false)
        mapView!.setLayerGroup(NMF_LAYER_GROUP_CADASTRAL, isEnabled: false)
        activeLayers.forEach { (any) in
            let index = any as! Int
            switch index {
            case 0 :
                mapView!.setLayerGroup(NMF_LAYER_GROUP_BUILDING, isEnabled: true)
                break
            case 1:
                mapView!.setLayerGroup(NMF_LAYER_GROUP_TRAFFIC, isEnabled: true)
                break
            case 2:
                mapView!.setLayerGroup(NMF_LAYER_GROUP_TRANSIT, isEnabled: true)
                break
            case 3:
                mapView!.setLayerGroup(NMF_LAYER_GROUP_BICYCLE, isEnabled: true)
                break
            case 4:
                mapView!.setLayerGroup(NMF_LAYER_GROUP_MOUNTAIN, isEnabled: true)
                break
            case 5:
                mapView!.setLayerGroup(NMF_LAYER_GROUP_CADASTRAL, isEnabled: true)
                break
            default:
                return
            }
        }
    }
    
    func setRotationGestureEnable(_ rotationGestureEnable: Bool) {
        mapView!.isRotateGestureEnabled = rotationGestureEnable
    }
    
    func setScrollGestureEnable(_ scrollGestureEnable: Bool) {
        mapView!.isScrollGestureEnabled = scrollGestureEnable
    }
    
    func setTiltGestureEnable(_ tiltGestureEnable: Bool) {
        mapView!.isTiltGestureEnabled = tiltGestureEnable
    }
    
    func setZoomGestureEnable(_ zoomGestureEnable: Bool) {
        mapView!.isZoomGestureEnabled = zoomGestureEnable
    }
    
    func setLocationTrackingMode(_ locationTrackingMode: UInt) {
        mapView!.positionMode = NMFMyPositionMode(rawValue: locationTrackingMode)!
    }
    
    func setContentPadding(_ paddingData: Array<CGFloat>) {
        mapView!.contentInset = UIEdgeInsets(top: paddingData[1], left: paddingData[0], bottom: paddingData[3], right: paddingData[2])
    }
    
    func setLocationButtonEnable(_ locationButtonEnable: Bool) {
        naverMap!.showLocationButton = locationButtonEnable
    }
    
    func setMaxZoom(_ maxZoom: Double){
        mapView!.maxZoomLevel = maxZoom
    }
    
    func setMinZoom(_ minZoom: Double){
        mapView!.minZoomLevel = minZoom
    }
    
    // ===================== authManagerDelegate ========================
    func authorized(_ state: NMFAuthState, error: Error?) {
        switch state {
        case .authorized:
            print("네이버 지도 인증 완료")
            break
        case .authorizing:
            print("네이버 지도 인증 진행중")
            break
        case .pending:
            print("네이버 지도 인증 대기중")
            break
        case .unauthorized:
            print("네이버 지도 인증 실패")
            break
        default:
            break
        }
        if let e = error {
            print("네이버 지도 인증 에러 발생 : \(e.localizedDescription)")
        }
    }
}

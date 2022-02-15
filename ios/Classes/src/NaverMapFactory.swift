//
//  NaverMapFactory.swift
//  naver_map_plugin
//
//  Created by Maximilian on 2020/08/19.
//

import Flutter

class NaverMapFactory: NSObject, FlutterPlatformViewFactory {
    let refistrar : FlutterPluginRegistrar
    
    init(registrar: FlutterPluginRegistrar) {
        self.refistrar = registrar
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return NaverMapController(viewId: viewId,
                                  frame: frame,
                                  registrar: refistrar,
                                  argument: args as? NSDictionary)
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

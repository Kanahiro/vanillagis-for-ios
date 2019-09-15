//
//  NewMapModel.swift
//  vanillagis
//
//  Created by Kanahiro Iguchi on 2019/09/13.
//  Copyright © 2019 Labo288. All rights reserved.
//

import Foundation
import Mapbox

struct MapModel {
    var name: String
    var style: [String:Any]
    var sources: [MGLShapeSource] = []
    var layers: [MGLStyleLayer] = []
    
    init(name:String, style:[String:Any] = [:]) {
        self.name = name
        //if STYLE in argument is empty, set default style
        if style.count == 0 {
            var mapStyleManager = MapStyleManager()
            mapStyleManager.apllyDefault()
            self.style = mapStyleManager.getStyle()
        } else {
            self.style = style
        }
    }
    
    mutating func appendSource(source:MGLShapeSource) {
        self.sources.append(source)
    }
    
    mutating func appendLayer(layer:MGLStyleLayer) {
        self.layers.append(layer)
    }
    
    func draw(mapView:MGLMapView) {
        guard let style = mapView.style else { return }
        for source in self.sources {
            style.addSource(source)
        }
        for layer in self.layers {
            style.addLayer(layer)
        }
    }
    
    func export() -> [String:Any] {
        let exportDic:[String:Any] = [
            "name":self.name,
            "style":self.style,
            "sources":self.sources,
            "layers":self.layers
        ]
        return exportDic
    }
}

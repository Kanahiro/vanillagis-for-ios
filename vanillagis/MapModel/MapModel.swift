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
    var style: [String:Any] = [:]
    var sources: [MGLShapeSource] = []
    var layers: [MGLStyleLayer] = []
    
    init(name:String) {
        self.name = name
        var mapStyleManager = MapStyleManager()
        mapStyleManager.apllyDefault()
        self.style = mapStyleManager.getStyle()
    }
    
    init(name:String, sources:[MGLShapeSource], layers:[MGLStyleLayer]) {
        self.name = name
        self.sources = sources
        self.layers = layers
    }
    
    mutating func append(source:MGLShapeSource, layer:MGLStyleLayer) {
        self.appendSource(source: source)
        self.appendLayer(layer: layer)
    }
    
    private mutating func appendSource(source:MGLShapeSource) {
        self.sources.append(source)
    }
    
    private mutating func appendLayer(layer:MGLStyleLayer) {
        self.layers.append(layer)
    }
    
    mutating func drawAll(mapView:MGLMapView) {
        guard let style = mapView.style else { return }
        for source in self.sources {
            style.addSource(source)
        }
        for layer in self.layers {
            style.addLayer(layer)
        }
    }
    
    mutating func draw(mapView:MGLMapView, source:MGLShapeSource, layer:MGLStyleLayer) {
        guard let style = mapView.style else { return }
        
        //もし既に読み込まれているレイヤーならば、警告を出し何も処理しない
        if (style.source(withIdentifier: source.identifier) != nil) { return }
        if (style.layer(withIdentifier: layer.identifier) != nil) { return }
        
        self.append(source: source, layer: layer)
        style.addSource(source)
        style.addLayer(layer)
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

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
    var sources: [MGLShapeSource] = []
    var layers: [MGLStyleLayer] = []
    
    init(name:String) {
        self.name = name
    }
    
    init(name:String, sources:[MGLShapeSource], layers:[MGLStyleLayer]) {
        self.name = name
        self.sources = sources
        self.layers = layers
    }
    
    mutating func append(source:MGLShapeSource, layer:MGLStyleLayer) {
        self.sources.append(source)
        self.layers.append(layer)
    }
    
    mutating func remove(index:Int) {
        if (self.sources.count < 1) { return }
        self.sources.remove(at: index)
        self.layers.remove(at: index)
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
    
    mutating func draw(mapView:MGLMapView, source:MGLShapeSource, layer:MGLStyleLayer) -> Bool {
        guard let style = mapView.style else { return true }
        
        //もし既に読み込まれているレイヤーならば、警告を出し何も処理しない
        if (style.source(withIdentifier: source.identifier) != nil) { return true }
        if (style.layer(withIdentifier: layer.identifier) != nil) { return true }
        
        self.append(source: source, layer: layer)
        style.addSource(source)
        style.addLayer(layer)
        
        return false
    }
    
    func export() -> [String:Any] {
        let exportDic:[String:Any] = [
            "name":self.name,
            "sources":self.sources,
            "layers":self.layers
        ]
        return exportDic
    }
}

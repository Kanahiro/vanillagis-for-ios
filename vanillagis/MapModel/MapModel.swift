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
    var name: String!
    var sources: Set<MGLSource> = []
    var layers: [MGLStyleLayer] = []
    
    init(name:String) {
        self.name = name
    }
    
    init(name:String, sources:Set<MGLSource>, layers:[MGLStyleLayer]) {
        self.name = name
        self.sources = sources
        self.layers = layers
    }
    
    init(importDic:[String:Any]) {
        self.name = String(describing: importDic["name"])
        self.sources = importDic["sources"] as! Set<MGLSource>
        self.layers = importDic["layers"] as! [MGLStyleLayer]
    }
    
    mutating func append(source:MGLSource, layer:MGLStyleLayer) {
        self.sources.insert(source)
        self.layers.append(layer)
    }
    
    mutating func remove(source:MGLSource, layer:MGLStyleLayer) {
        if (self.sources.count < 1) { return }
        self.removeSource(source: source)
        self.removeLayer(layer: layer)
    }
    
    mutating func removeSource(source:MGLSource) {
        self.sources.remove(source)
    }
    
    mutating func removeLayer(layer:MGLStyleLayer) {
        let index = self.layers.firstIndex(of: layer)!
        self.layers.remove(at: index)
    }
    
    func export() -> [String:Any] {
        let exportDic:[String:Any] = [
            "name":self.name!,
            "sources":self.sources,
            "layers":self.layers
        ]
        return exportDic
    }
}

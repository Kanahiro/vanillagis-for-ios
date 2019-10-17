//
//  NewMapModel.swift
//  vanillagis
//
//  Created by Kanahiro Iguchi on 2019/09/13.
//  Copyright © 2019 Labo288. All rights reserved.
//

import Foundation
import UIKit
import Mapbox


class MapModel: NSObject, NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.sources, forKey: "sources")
        aCoder.encode(self.layers, forKey: "layers")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.sources = aDecoder.decodeObject(forKey: "sources") as! Set<MGLSource>
        self.layers = aDecoder.decodeObject(forKey: "layers") as! [MGLStyleLayer]
    }
    
    //class vars
    var name: String = "Unnamed"
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
    
    func append(source:MGLSource, layer:MGLStyleLayer) {
        self.sources.insert(source)
        self.layers.append(layer)
    }
    
    func remove(source:MGLSource, layer:MGLStyleLayer) {
        if (self.sources.count < 1) { return }
        self.removeSource(source: source)
        self.removeLayer(layer: layer)
    }
    
    func removeSource(source:MGLSource) {
        self.sources.remove(source)
    }
    
    func removeLayer(layer:MGLStyleLayer) {
        let index = self.layers.firstIndex(of: layer)!
        self.layers.remove(at: index)
    }
    
    func export() -> NSDictionary {
        let exportDic:NSDictionary = [
            "name":self.name,
            "sources":self.sources,
            "layers":self.layers
        ]
        return exportDic
    }
}

//
//  CustomMap.swift
//  vanillagis
//
//  Created by Kanahiro Iguchi on 2019/09/12.
//  Copyright © 2019 Labo288. All rights reserved.
//

import Foundation
import Mapbox

protocol TestMapModel {
    var name:String { get set }
    var style:[String:Any] { get set }
    var sources:[MGLShapeSource] { get set }
    var layers:[MGLStyleLayer] { get set }
}

extension TestMapModel {
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

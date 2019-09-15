//
//  GeoJsonSourceModel.swift
//  vanillagis
//
//  Created by Kanahiro Iguchi on 2019/09/12.
//  Copyright © 2019 Labo288. All rights reserved.
//

import Foundation
import Mapbox

struct GeoJsonSourceModel:DataSourceModel {
    let filepath:URL
    var type:String = "polyline"
    
    init(filepath:URL){
        self.filepath = filepath
    }
    
    func loadGeoJson() -> Data {
        let jsonUrl = self.filepath
        guard let jsonData = try? Data(contentsOf: jsonUrl) else {
            preconditionFailure("Failed to parse GeoJSON file")
        }
        return jsonData
    }
    
    func getType() -> String {
        return "point"
    }
    
    func makeSource() -> MGLShapeSource {
        let jsonData:Data = self.loadGeoJson()
        // MGLMapView.style is optional, so you must guard against it not being set.
        guard let shapeFromGeoJSON = try? MGLShape(data: jsonData, encoding: String.Encoding.utf8.rawValue) else {
            fatalError("Could not generate MGLShape")
        }
        let source = MGLShapeSource(identifier: self.type, shape: shapeFromGeoJSON, options: nil)
        return source
    }
    
    func makeLayer() -> MGLStyleLayer {
        let source = self.makeSource()
        // Create new layer for the line.
        let layer = MGLLineStyleLayer(identifier: self.type, source: source)
        
        layer.lineColor = NSExpression(forConstantValue: UIColor(red: 59/255, green: 178/255, blue: 208/255, alpha: 1))
        
        // Use `NSExpression` to smoothly adjust the line width from 2pt to 20pt between zoom levels 14 and 18. The `interpolationBase` parameter allows the values to interpolate along an exponential curve.
        layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)", [14: 2, 18: 20])
        
        return layer
    }
}

//
//  MapLayer.swift
//  vanillagis
//
//  Created by Kanahiro Iguchi on 2019/09/05.
//  Copyright © 2019 Labo288. All rights reserved.
//

import Foundation
import Mapbox

protocol DataSourceModel {
    var name:String { get }
    var data:Data! { get }
    var geotype:String! { get }
}
/*
extension DataSourceModel {
    
    func decodeData(data:Data) -> [String:Any] {
        guard let obj = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
            preconditionFailure("Failed to parse JSON file")
        }
        return obj
    }
    
    func makeSource(data:Data) -> MGLShapeSource {
        guard let shapeFromGeoJSON = try? MGLShape(data: data, encoding: String.Encoding.utf8.rawValue) else {
            fatalError("Could not generate MGLShape")
        }
        let source = MGLShapeSource(identifier: self.filepath.lastPathComponent, shape: shapeFromGeoJSON, options: nil)
        return source
    }
    
    func makeLayer(data:Data, type:String) -> MGLStyleLayer {
        let source = self.makeSource()
        
        //make a layer depending layer type
        //Geojson type will have classfied as one of three layer types in self.getType().
        switch type {
        case "polyline":
            let layer = MGLLineStyleLayer(identifier: self.filepath.lastPathComponent, source: source)
            layer.lineColor = self.randomColor()
            layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)", [14: 2, 18: 20])
            return layer
            
        case "polygon":
            let layer = MGLFillStyleLayer(identifier: self.filepath.lastPathComponent, source: source)
            let color:NSExpression = self.randomColor()
            layer.fillOutlineColor = NSExpression(forConstantValue: UIColor(red: 1, green: 1, blue: 1, alpha: 1))
            layer.fillColor = color
            layer.fillOpacity = NSExpression(forConstantValue: 0.5)
            return layer
            
        default:
            let layer = MGLCircleStyleLayer(identifier: self.filepath.lastPathComponent, source: source)
            layer.circleStrokeWidth = NSExpression(forConstantValue: 0.2)
            layer.circleStrokeColor = NSExpression(forConstantValue: UIColor(red: 1, green: 1, blue: 1, alpha: 1))
            layer.circleColor = self.randomColor()
            layer.circleRadius = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'exponential', 1.75, %@)",
                                              [12: 5,
                                               18: 25])
            return layer
        }
    }
    
    private func randomColor() -> NSExpression {
        let redValue = CGFloat(Int.random(in:0..<256))
        let greenValue = CGFloat(Int.random(in:0..<256))
        let blueValue = CGFloat(Int.random(in:0..<256))
        let color = NSExpression(forConstantValue: UIColor(red: redValue/255, green: greenValue/255, blue: blueValue/255, alpha: 1))
        return color
    }
}
*/

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
    var type:String?
    
    init(filepath:URL){
        self.filepath = filepath
        self.type = self.getType()
    }
    func loadGeoJson() -> Data {
        let jsonUrl = self.filepath
        guard let jsonData = try? Data(contentsOf: jsonUrl) else {
            preconditionFailure("Failed to parse GeoJSON file")
        }
        return jsonData
    }
    
    func getType() -> String {
        let jsonData:Data = self.loadGeoJson()
        guard let jsonObj = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:Any] else {
            preconditionFailure("Failed to parse JSON file")
        }
        
        //Parse Geojson and get a Geometry type
        var jsonType:String?
        if jsonObj["type"] as? String != "FeatureCollection" {
            let geometry = jsonObj["geometry"] as! [String:Any]
            let featureType = geometry["type"]
            jsonType = featureType as? String
        } else {
            let features = jsonObj["features"] as! [[String:Any]]
            let firstFeature = features[0]
            let firstFeatureGeom = firstFeature["geometry"] as! [String:Any]
            let firstFeatureType = firstFeatureGeom["type"]
            jsonType = firstFeatureType as? String
        }
        
        //Convert the Geometry type into a Layer type and return
        var layerType:String?
        switch jsonType! {
        case "LineString", "MultiLineString":
            layerType = "polyline"
        case "Polygon", "MultiPolygon":
            layerType = "polygon"
        default:
            layerType = "point"
        }
        return layerType!
    }
    
    func makeSource() -> MGLShapeSource {
        let jsonData:Data = self.loadGeoJson()
        guard let shapeFromGeoJSON = try? MGLShape(data: jsonData, encoding: String.Encoding.utf8.rawValue) else {
            fatalError("Could not generate MGLShape")
        }
        let source = MGLShapeSource(identifier: self.filepath.lastPathComponent, shape: shapeFromGeoJSON, options: nil)
        return source
    }
    
    func makeLayer() -> MGLStyleLayer {
        let source = self.makeSource()
        
        //make a layer depending layer type
        //Geojson type will have classfied as one of three layer types in self.getType().
        switch self.type {
        case "polyline":
            let layer = MGLLineStyleLayer(identifier: self.filepath.lastPathComponent, source: source)
            layer.lineColor = self.randomColor()
            layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)", [14: 2, 18: 20])
            return layer
            
        case "polygon":
            let layer = MGLFillStyleLayer(identifier: self.filepath.lastPathComponent, source: source)
            let color:NSExpression = self.randomColor()
            layer.fillOutlineColor = color
            layer.fillColor = color
            layer.fillOpacity = NSExpression(forConstantValue: 0.5)
            return layer
            
        default:
            let layer = MGLCircleStyleLayer(identifier: self.filepath.lastPathComponent, source: source)
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

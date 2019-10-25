//
//  GeoJsonSourceModel.swift
//  vanillagis
//
//  Created by Kanahiro Iguchi on 2019/09/12.
//  Copyright © 2019 Labo288. All rights reserved.
//

import Foundation
import Mapbox

struct GeoJsonSource:DataSourceModel {
    var name:String = "unnamed"
    var data:Data!
    var geotype:String!
    
    init(filepath:URL){
        self.name = filepath.lastPathComponent
        self.data = self.loadGeoJson(filepath: filepath)
        self.geotype = self.getType(data: self.data!)
    }
    
    init(name:String, data:Data){
        self.name = name
        self.data = data
        self.geotype = self.getType(data: self.data!)
    }
    
    func loadGeoJson(filepath:URL) -> Data {
        guard let jsonData = try? Data(contentsOf: filepath) else {
            preconditionFailure("Failed to parse GeoJSON file")
        }
        return jsonData
    }
    
    func getType(data: Data) -> String {
        guard let jsonObj = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
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
    /*
    func makeSource() -> MGLShapeSource {
        guard let shapeFromGeoJSON = try? MGLShape(data: self.data!, encoding: String.Encoding.utf8.rawValue) else {
            fatalError("Could not generate MGLShape")
        }
        let source = MGLShapeSource(identifier: self.name, shape: shapeFromGeoJSON, options: nil)
        return source
    }
    
    func makeLayer() -> MGLStyleLayer {
        let source = self.makeSource()
        
        //make a layer depending layer type
        //Geojson type will have classfied as one of three layer types in self.getType().
        switch self.type {
        case "polyline":
            let layer = MGLLineStyleLayer(identifier: self.name, source: source)
            layer.lineColor = NSExpression(forConstantValue: self.randomColor() )
            layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)", [14: 2, 18: 20])
            return layer
            
        case "polygon":
            let layer = MGLFillStyleLayer(identifier: self.name, source: source)
            let color:NSExpression = NSExpression(forConstantValue: self.randomColor() )
            layer.fillOutlineColor = NSExpression(forConstantValue: UIColor(red: 1, green: 1, blue: 1, alpha: 1))
            layer.fillColor = color
            layer.fillOpacity = NSExpression(forConstantValue: 0.5)
            return layer
            
        default:
            let layer = MGLCircleStyleLayer(identifier: self.name, source: source)
            layer.circleStrokeWidth = NSExpression(forConstantValue: 0.2)
            layer.circleStrokeColor = NSExpression(forConstantValue: UIColor(red: 1, green: 1, blue: 1, alpha: 1))
            layer.circleColor = NSExpression(forConstantValue: self.randomColor() )
            layer.circleRadius = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'exponential', 1.75, %@)",
                                              [12: 5,
                                               18: 25])
            return layer
        }
    }
    
    private func randomColor() -> UIColor {
        let redValue = CGFloat(Int.random(in:0..<256))
        let greenValue = CGFloat(Int.random(in:0..<256))
        let blueValue = CGFloat(Int.random(in:0..<256))
        let color = UIColor(red: redValue/255, green: greenValue/255, blue: blueValue/255, alpha: 1)
        return color
    }
    */
}
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
    
    func getCRS() -> String {
        guard let jsonObj = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
            preconditionFailure("Failed to parse JSON file")
        }
        let crsObj = jsonObj["crs"] as! [String:Any]
        let crsProps = crsObj["properties"] as! [String:Any]
        let crsName = crsProps["name"] as! String
        return crsName
        //sample: WGS84 => urn:ogc:def:crs:EPSG::4326
    }
}

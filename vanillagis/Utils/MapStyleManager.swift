//
//  mapStyleMaker.swift
//  vanillagis
//
//  Created by Kanahiro Iguchi on 2019/09/13.
//  Copyright © 2019 Labo288. All rights reserved.
//

import Foundation

struct MapStyleManager {
    private var style:[String:Any] = [
        "version":8,
        "name":"basemap",
        "sources":[],
        "layers":[],
    ]
    
    mutating func applyDefault() {
        let defaultName = "国土地理院オルソ"
        let defaultTileUrl = "https://cyberjapandata.gsi.go.jp/xyz/seamlessphoto/{z}/{x}/{y}.jpg"
        let defaultAttributionUrl = "https://maps.gsi.go.jp/development/ichiran.html"
        self.setBasemap(name: defaultName, tileUrlStr: defaultTileUrl, attributionUrl:defaultAttributionUrl)
    }
    
    func getStyle() -> [String:Any] {
        return self.style
    }
    
    mutating func setStyle(styleDict:[String:Any]) {
        self.style = styleDict
    }
    
    mutating func setBasemap(name:String, tileUrlStr:String, attributionUrl:String="", tileSize:Int=256) {
        self.style["name"] = name
        
        let sources = [
            name:[
                "type":"raster",
                "tiles":[tileUrlStr],
                "attribution":"<a href='" + attributionUrl + "'>" + name + "</a>",
                "tileSize":tileSize
            ]
        ]
        
        let layers = [
            [
                "id":name,
                "type":"raster",
                "source":name,
                "minzoom":0,
                "maxzoom":18
            ]
        ]
        
        self.style["sources"] = sources
        self.style["layers"] = layers
    }
    
    func readJson(inputDir:String, filename:String) -> [String:Any] {
        let nsHomeDir = NSHomeDirectory()
        let inputPath = nsHomeDir + inputDir + "/" + filename + ".json"
        
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: inputPath) ) else {
            preconditionFailure("Failed to load JSON file")
        }
        
        guard let jsonObj = try? JSONSerialization.jsonObject(with: jsonData, options: []) else {
            preconditionFailure("Failed to parse JSON file")
        }
        
        let jsonDict = jsonObj as! [String:Any]
        return jsonDict
    }
    
    //By serializing styleDic(class prop, Swift Dictionary), WRITE .JSON.
    func writeJson(outputDir:String, filename:String) -> URL? {
        let nsHomeDir = NSHomeDirectory()
        let outputPath = nsHomeDir + outputDir + "/" + filename + ".json"
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self.style, options: .prettyPrinted)
            try jsonData.write(to: URL(fileURLWithPath: outputPath))
            return URL(fileURLWithPath: outputPath)
        } catch {
            print("error")
            return nil
        }
    }
}

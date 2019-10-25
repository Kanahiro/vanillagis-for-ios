//
//  LayerModel.swift
//  vanillagis
//
//  Created by Kanahiro Iguchi on 2019/10/21.
//  Copyright © 2019 Labo288. All rights reserved.
//

//ひとつのGISデータに対してひとつインスタンスを生成する
//レイヤー名、データ、データタイプ、レイヤー設定をもつ

import Foundation
import UIKit
import Mapbox

class LayerSet:NSObject, NSCoding {
    //NSCoding protocol
    func encode(with coder: NSCoder) {
        coder.encode(self.identifier, forKey: "identifier")
        coder.encode(self.data, forKey: "data")
        coder.encode(self.geotype, forKey: "geotype")
        coder.encode(self.setting, forKey: "setting")
    }
    
    required init?(coder: NSCoder) {
        self.identifier = coder.decodeObject(forKey: "identifier") as! String
        self.data = coder.decodeObject(forKey: "data") as! Data
        self.geotype = coder.decodeObject(forKey: "geotype") as! String
        self.setting = coder.decodeObject(forKey: "setting") as! [String:Any]
    }
    
    //class vars
    var identifier:String
    var data:Data
    var geotype:String
    var setting:[String:Any]
    
    init(identifier:String, data:Data, geotype:String) {
        self.identifier = identifier
        self.data = data
        self.geotype = geotype
        self.setting = [:]
        
        super.init()
        
        let randomRGB = self.convertToRGB(self.randomColor())
        let layerSetting:[String:Any] = [
            "red":randomRGB.red,
            "green":randomRGB.green,
            "blue":randomRGB.blue,
            "opacity":0.5,
            "size":10,
            "heatmap":false
        ]
        self.setting = layerSetting
    }
    
    init(identifier:String, data:Data, geotype:String, setting:[String:Any]) {
        self.identifier = identifier
        self.data = data
        self.geotype = geotype
        self.setting = setting
        super.init()
    }
    
    func convertToRGB(_ color: UIColor) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let components = color.cgColor.components!
        return (red: components[0], green: components[1], blue: components[2], alpha: components[3])
    }
    
    func randomColor() -> UIColor {
        let redValue = CGFloat(Int.random(in:0..<256))
        let greenValue = CGFloat(Int.random(in:0..<256))
        let blueValue = CGFloat(Int.random(in:0..<256))
        let color = UIColor(red: redValue/255, green: greenValue/255, blue: blueValue/255, alpha: 1)
        return color
    }
    
    func setLayerSetting(layer:MGLStyleLayer) {
        let layerClass = String(describing: type(of: layer))
        switch layerClass{
        case "MGLFillStyleLayer":
            let polygonLayer = layer as! MGLFillStyleLayer
            let fillColor = self.convertToRGB(polygonLayer.fillColor.constantValue as! UIColor)
            let fillOpacity = polygonLayer.fillOpacity.constantValue as! Float
            self.setting["red"] = fillColor.red
            self.setting["green"] = fillColor.green
            self.setting["blue"] = fillColor.blue
            self.setting["opacity"] = fillOpacity
        case "MGLLineStyleLayer":
            let polylineLayer = layer as! MGLLineStyleLayer
            let lineColor = self.convertToRGB(polylineLayer.lineColor.constantValue as! UIColor)
            let lineOpacity = polylineLayer.lineOpacity.constantValue as! Float
            self.setting["red"] = lineColor.red
            self.setting["green"] = lineColor.green
            self.setting["blue"] = lineColor.blue
            self.setting["opacity"] = lineOpacity
        case "MGLCircleStyleLayer":
            let pointLayer = layer as! MGLCircleStyleLayer
            let pointColor = self.convertToRGB(pointLayer.circleColor.constantValue as! UIColor)
            let pointOpacity = pointLayer.circleOpacity.constantValue as! Float
            self.setting["red"] = pointColor.red
            self.setting["green"] = pointColor.green
            self.setting["blue"] = pointColor.blue
            self.setting["opacity"] = pointOpacity
            self.setting["heatmap"] = false
        case "MGLHeatmapStyleLayer":
            let heatmapLayer = layer as! MGLHeatmapStyleLayer
            let heatmapOpacity = heatmapLayer.heatmapOpacity.constantValue as! Float
            self.setting["opacity"] = heatmapOpacity
            self.setting["heatmap"] = true
        default:
            return
        }
    }
    
    func setSetting(red:Float, green:Float, blue:Float, opacity:Float, heatmap:Bool=false) {
        self.setting["red"] = red
        self.setting["green"] = green
        self.setting["blue"] = blue
        self.setting["opacity"] = opacity
        self.setting["heatmap"] = heatmap
    }
}

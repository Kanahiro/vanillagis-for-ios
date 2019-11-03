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
    //class vars
    var name: String
    var layerSets: [LayerSet]
    
    //NSCoding protocol
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.layerSets, forKey: "layerSets")
    }
    
    required init?(coder: NSCoder) {
        self.name = coder.decodeObject(forKey: "name") as! String
        self.layerSets = coder.decodeObject(forKey: "layerSets") as! [LayerSet]
    }
    
    init(name:String) {
        self.name = name
        self.layerSets = []
    }
    
    init(name:String, layerSets:[LayerSet]) {
        self.name = name
        self.layerSets = layerSets
    }
    
    func showLayer(mapView:MGLMapView, layerSet:LayerSet) {
        DispatchQueue.global(qos: .userInitiated).async {
            let source = self.makeSource(layerSet: layerSet)
            let layer = self.makeLayer(layerSet: layerSet)
            DispatchQueue.main.async {
                let sourcesInMapView = mapView.style?.sources
                //sourcesが空なら中断
                if sourcesInMapView == nil { return }
                //sourcesに既にsourceが含まれているなら中断
                for s in sourcesInMapView! {
                    if (source.identifier == s.identifier) { return }
                }
                mapView.style!.addSource(source)
                mapView.style!.addLayer(layer)
            }
        }
    }
    
    func showAllLayer(mapView:MGLMapView) {
        for layerSet in self.layerSets {
            self.showLayer(mapView: mapView, layerSet: layerSet)
        }
    }
    
    func sources() -> Set<MGLShapeSource> {
        var sourcesArray:Set<MGLShapeSource> = []
        for layerSet in self.layerSets {
            sourcesArray.insert(makeSource(layerSet: layerSet))
        }
        return sourcesArray
    }
    
    func layers() -> [MGLStyleLayer] {
        var layersArray:[MGLStyleLayer] = []
        for layerSet in self.layerSets {
            layersArray.append(makeLayer(layerSet: layerSet))
        }
        return layersArray
    }
    
    func addData(dataSource:DataSourceModel) {
        let newLayerSet = LayerSet(identifier: dataSource.name, data: dataSource.data!, geotype: dataSource.geotype!)
        
        for layerSet in self.layerSets {
            if layerSet.identifier == newLayerSet.identifier {
                newLayerSet.identifier = newLayerSet.identifier + "1"
            }
        }
        
        self.layerSets.append(newLayerSet)
    }
    
    func makeSource(layerSet:LayerSet) -> MGLShapeSource {
        guard let shapeFromGeoJSON = try? MGLShape(data: layerSet.data, encoding: String.Encoding.utf8.rawValue) else {
            fatalError("Could not generate MGLShape")
        }
        let source = MGLShapeSource(identifier: layerSet.identifier, shape: shapeFromGeoJSON, options: nil)
        return source
    }
    
    func makeLayer(layerSet:LayerSet) -> MGLStyleLayer {
        let source = self.makeSource(layerSet: layerSet)
        
        //make a layer depending layer type
        //Geojson type will have classfied as one of three layer types in self.getType().
        switch layerSet.geotype {
        case "polyline":
            let layer = MGLLineStyleLayer(identifier: layerSet.identifier, source: source)
            layer.lineColor = NSExpression(forConstantValue: makeUIColor(red: layerSet.setting["red"] as! CGFloat,
                                                                         green: layerSet.setting["green"] as! CGFloat,
                                                                         blue: layerSet.setting["blue"] as! CGFloat) )
            layer.lineOpacity = NSExpression(forConstantValue:layerSet.setting["opacity"])
            layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)", [15: 1, 18: 2])
            return layer
        case "polygon":
            let layer = MGLFillStyleLayer(identifier: layerSet.identifier, source: source)
            layer.fillOutlineColor = NSExpression(forConstantValue: UIColor(red: 1, green: 1, blue: 1, alpha: 1))
            layer.fillColor = NSExpression(forConstantValue: makeUIColor(red: layerSet.setting["red"] as! CGFloat,
                                                                        green: layerSet.setting["green"] as! CGFloat,
                                                                        blue: layerSet.setting["blue"] as! CGFloat) )
            layer.fillOpacity = NSExpression(forConstantValue: layerSet.setting["opacity"])
            return layer
        default:
            if (layerSet.setting["heatmap"] as! Bool) {
                let layer = MGLHeatmapStyleLayer(identifier: layerSet.identifier, source: source)
                layer.heatmapOpacity = NSExpression(forConstantValue: layerSet.setting["opacity"])
                return layer
            } else {
                //Point
                let layer = MGLCircleStyleLayer(identifier: layerSet.identifier, source: source)
                layer.circleStrokeWidth = NSExpression(forConstantValue: 0.2)
                layer.circleStrokeColor = NSExpression(forConstantValue: UIColor(red: 1, green: 1, blue: 1, alpha: 1))
                layer.circleColor = NSExpression(forConstantValue: makeUIColor(red: layerSet.setting["red"] as! CGFloat,
                                                                                green: layerSet.setting["green"] as! CGFloat,
                                                                                blue: layerSet.setting["blue"] as! CGFloat) )
                layer.circleOpacity = NSExpression(forConstantValue: layerSet.setting["opacity"])
                layer.circleRadius = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'exponential', 1.75, %@)",
                                                  [10: 5,
                                                   18: 25])
                return layer
            }
        }
    }
    
    func makeUIColor(red:CGFloat, green:CGFloat, blue:CGFloat) -> UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    func removeLayer(layer:MGLStyleLayer) {
        for i in 0..<self.layerSets.count {
            if self.layerSets[i].identifier == layer.identifier {
                self.layerSets.remove(at: i)
            }
            return
        }
    }
    
    func removeLayersInAllLayerSet(layers:[MGLStyleLayer]) {
        //layerSetsとlayersのidentifierを比較して、一致したlayerSetのみでnewLayerSetをつくる
        var newLayerSets:[LayerSet] = []
        for layerSet in self.layerSets {
            for layer in layers {
                if layerSet.identifier == layer.identifier {
                    newLayerSets.append(layerSet)
                    break
                }
            }
        }
        self.layerSets = newLayerSets
    }
    
    func apllyLayerSettingsForAllLayerSets(layers:[MGLStyleLayer]) {
        for layer in layers {
            self.apllyLayerSettingForLayerSet(layer: layer)
        }
    }
    
    func apllyLayerSettingForLayerSet(layer:MGLStyleLayer) {
        for layerSet in self.layerSets {
            if layerSet.identifier == layer.identifier {
                layerSet.setLayerSetting(layer: layer)
                return
            }
        }
    }
}

//
//  NewMapModel.swift
//  vanillagis
//
//  Created by Kanahiro Iguchi on 2019/09/13.
//  Copyright © 2019 Labo288. All rights reserved.
//

import Foundation
import Mapbox

struct NewMapModel:MapModel {
    var name: String
    var style: [String:Any]
    var sources: [MGLShapeSource] = []
    var layers: [MGLStyleLayer] = []
    
    init(name:String, style:[String:Any] = [:]) {
        self.name = name
        self.style = style
        
        //if style empty, set default style
        if self.style.count == 0 {
            let mapStyleManager = MapStyleManager()
            mapStyleManager.apllyDefault()
            self.style = mapStyleManager.style
        } else {
            self.style = style
        }
    }
}

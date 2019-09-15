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
    var filepath:URL { get }
    func makeSource() -> MGLShapeSource
    func makeLayer() -> MGLStyleLayer
}

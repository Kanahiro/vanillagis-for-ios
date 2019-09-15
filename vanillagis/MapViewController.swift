//
//  ViewController.swift
//  vanillagis
//
//  Created by Kanahiro Iguchi on 2019/09/02.
//  Copyright © 2019 Labo288. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController, MGLMapViewDelegate {
    var mapView:MGLMapView!
    var mapModel:MapModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initMapView()
    }
    
    func initMapView() {
        var msManager = MapStyleManager()
        msManager.setStyle(styleDict: mapModel.style)
        let tmpStyleUrl = msManager.writeJson(outputDir: "/tmp", filename: "tmp")
        
        mapView = MGLMapView(frame: view.bounds, styleURL: tmpStyleUrl!)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 44.2, longitude: 142.4), zoomLevel: 9, animated: false)
        
        mapView.delegate = self
        
        self.view.addSubview(mapView)
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MGLMapView, fullyRendered: Bool) {
        mapModel.draw(mapView:self.mapView)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
    }
    
}


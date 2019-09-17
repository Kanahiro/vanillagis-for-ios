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
    
    var test = false
    override func viewWillAppear(_ animated: Bool) {
        self.mapModel.draw(mapView: self.mapView)
        if (test) { return }
        test = true
        self.addDocument()
    }

    func initMapView() {
        var msManager = MapStyleManager()
        msManager.setStyle(styleDict: mapModel.style)
        //write temp-jsonfile as tmp.json, because MGLMapView needs styleURL to be initialized.
        let tmpStyleUrl = msManager.writeJson(outputDir: "/tmp", filename: "style")
        
        mapView = MGLMapView(frame: view.bounds, styleURL: tmpStyleUrl!)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 44.2, longitude: 142.4), zoomLevel: 9, animated: false)
        
        mapView.delegate = self
        
        self.view.addSubview(mapView)
    }
    
    func initUserLocation() {
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
    }
    
    //open documentsVC and add Layer to MapView
    func addDocument() {
        let docVc = DocumentsViewController()
        docVc.directory = NSHomeDirectory() + "/Documents" + "/geojsons"
        docVc.senderViewController = self
        self.present(docVc, animated: true, completion: nil)
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MGLMapView, fullyRendered: Bool) {
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        self.initUserLocation()
    }
    
}


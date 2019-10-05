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
        
        self.title = mapModel.name
        
        self.initMapView()
        self.initToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    func initMapView() {
        var msManager = MapStyleManager()
        msManager.setStyle(styleDict: mapModel.style)
        //write temp-jsonfile as tmp.json, because MGLMapView needs styleURL to be initialized.
        let tmpStyleUrl = msManager.writeJson(outputDir: "/tmp", filename: "style")
        
        // ステータスバーの高さを取得
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        // ナビゲーションバーの高さを取得
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        
        let rect = CGRect(x: 0, y: statusBarHeight + navBarHeight!, width: self.view.bounds.size.width, height: self.view.bounds.size.height - (statusBarHeight + navBarHeight! + 42))
        mapView = MGLMapView(frame: rect, styleURL: tmpStyleUrl!)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 44.2, longitude: 142.4), zoomLevel: 9, animated: false)
        
        mapView.maximumZoomLevel = 18
        mapView.minimumZoomLevel = 0
        
        mapView.delegate = self
        
        self.view.addSubview(mapView)
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MGLMapView, fullyRendered: Bool) {
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        self.initUserLocation()
    }
    
    func initUserLocation() {
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
    }
    
    func initToolbar() {
        var myToolbar: UIToolbar!
        myToolbar = UIToolbar(frame: CGRect(x: 0, y: self.view.bounds.size.height - 44, width: self.view.bounds.size.width, height: 44.0))
        myToolbar.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height-20.0)
        myToolbar.isTranslucent = false
        let addIcon = UIImage(named: "icon_add.png")
        let addButton: UIBarButtonItem = UIBarButtonItem(image : addIcon, style: UIBarButtonItem.Style.plain ,target: self, action: #selector(self.addDocument(sender:)))
        addButton.tag = 1
        
        let saveIcon = UIImage(named: "icon_save.png")
        let saveButton: UIBarButtonItem = UIBarButtonItem(image : saveIcon, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.saveMap(sender:)))
        saveButton.tag = 2
        
        let layerIcon = UIImage(named: "icon_layer.png")
        let layerButton: UIBarButtonItem = UIBarButtonItem(image: layerIcon, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.showLayer(sender:)))
        layerButton.tag = 3
        
        let locateIcon = UIImage(named: "icon_locate.png")
        let locateButton: UIBarButtonItem = UIBarButtonItem(image: locateIcon, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.showLocate(sender:)))
        layerButton.tag = 4
        
        let spacer = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        myToolbar.items = [addButton, spacer, layerButton, spacer, locateButton, spacer, saveButton]
        
        self.view.addSubview(myToolbar)
    }
    
    //open documentsVC and add Layer to MapView
    @objc func addDocument(sender:UIBarButtonItem) {
        let docVc = DocumentsViewController()
        docVc.directory = NSHomeDirectory() + "/Documents" + "/geojsons"
        docVc.senderViewController = self
        present(docVc, animated: true, completion: nil)
    }
    
    @objc func saveMap(sender:UIBarButtonItem) {
        print("save")
    }
    
    @objc func showLayer(sender:UIBarButtonItem) {
        let layerVc = LayerViewController()
        layerVc.layers = self.mapView.style?.layers
        present(layerVc, animated: true, completion: nil)
    }
    
    @objc func showLocate(sender:UIBarButtonItem) {
        if (self.mapView.userTrackingMode != .follow) {
            self.mapView.userTrackingMode = .follow
        } else {
            self.mapView.userTrackingMode = .followWithHeading
        }
    }
    
}


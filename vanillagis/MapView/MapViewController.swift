//
//  ViewController.swift
//  vanillagis
//
//  Created by Kanahiro Iguchi on 2019/09/02.
//  Copyright © 2019 Labo288. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController {
    var mapView:MGLMapView!

    var mapModel:MapModel!
    var attributesWindowView:AttributesWindowView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setMapTitle()
        
        self.initMapView()
        self.initButtons()
        self.initAnnotationTableView()
        self.initToolbar()
    }
    
    func setMapTitle() {
        if (self.mapModel == nil) {
            self.mapModel = MapModel(name: "New Map")
        }
        self.title = self.mapModel.name
    }
    
    func initMapView() {
        // ステータスバーの高さを取得
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        // ナビゲーションバーの高さを取得
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        //mapViewエリアを設定
        let rect = CGRect(x: 0, y: statusBarHeight + navBarHeight!, width: self.view.bounds.size.width, height: self.view.bounds.size.height - (statusBarHeight + navBarHeight! + 42))
        var msManager = MapStyleManager()
        msManager.applyDefault()
        let styleUrl = msManager.writeJson(outputDir:"/tmp", filename:"style")
        mapView = MGLMapView(frame: rect, styleURL: styleUrl)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 38.0, longitude: 135.0), zoomLevel: 3, animated: false)
        mapView.maximumZoomLevel = 18
        mapView.minimumZoomLevel = 2
        mapView.backgroundColor = .white
        mapView.logoViewPosition = MGLOrnamentPosition.bottomLeft
        mapView.showsScale = true
        mapView.scaleBarPosition = MGLOrnamentPosition.bottomRight
        mapView.compassViewPosition = MGLOrnamentPosition.topLeft
        mapView.attributionButtonPosition = MGLOrnamentPosition.topRight
        mapView.delegate = self
        
        self.view.addSubview(mapView)
        
        //mapview tap event
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped(sender:)))
        for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
            singleTap.require(toFail: recognizer)
        }
        mapView.addGestureRecognizer(singleTap)
    }
    
    @objc @IBAction func mapViewTapped(sender: UITapGestureRecognizer) {
        //init annotations
        let annotations = mapView.annotations
        if annotations != nil {
            for annotation in annotations! {
                mapView.removeAnnotation(annotation)
            }
        }
        // Get the CGPoint where the user tapped.
        let spot = sender.location(in: mapView)
         
        // Access the features at that point within the state layer.
        let features = mapView.visibleFeatures(at: spot)
        toggleAnnotationWindow(features: features)
    }
    
    func initButtons() {
        let changeBtn = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(self.pushChangeButton(sender:)))
        self.navigationItem.rightBarButtonItem = changeBtn
    }
    
    @objc func pushChangeButton(sender: UIButton){
        let basemapSelectionVC = BasemapSelectionViewController()
        basemapSelectionVC.mapView = self.mapView
        self.present(basemapSelectionVC, animated: true, completion: nil)
    }
    
    //属性表示ウィンドウの初期化
    func initAnnotationTableView() {
        // ステータスバーの高さを取得
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        // ナビゲーションバーの高さを取得
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        
        attributesWindowView = AttributesWindowView(frame: CGRect(x: 0, y: statusBarHeight + navBarHeight!, width: self.view.bounds.size.width, height: 90))
        attributesWindowView.initTableView()
        attributesWindowView.isHidden = true
        
        self.view.addSubview(attributesWindowView)
    }
    //annotationWindow on-off toggle
    func toggleAnnotationWindow(features:[MGLFeature]) {
        //クリックされた地物の属性をannotationTableViewに渡す
        if (features.count > 0) {
            let feature = features[0]
            var headers:[String] = []
            var values:[Any] = []
            for (key, value) in feature.attributes {
                headers.append(key)
                values.append(value)
            }
            //tableviewで適切に表示するために配列として渡す
            attributesWindowView.headers = headers
            attributesWindowView.values = values
            attributesWindowView.tableView.reloadData()
            attributesWindowView.isHidden = false
        } else {
            attributesWindowView.isHidden = true
        }
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
        docVc.directory = NSHomeDirectory() + "/Documents/geojsons"
        docVc.senderViewController = self
        present(docVc, animated: true, completion: nil)
    }
    
    @objc func saveMap(sender:UIBarButtonItem) {
        var alertTextField: UITextField!
        let alert = UIAlertController(
            title: "Save Your Map",
            message: "Input Map Name. Always overwrite if same-name file exist.",
            preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(
            configurationHandler: {(textField: UITextField!) in
                alertTextField = textField
                textField.text = self.mapModel.name
        })
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: UIAlertAction.Style.cancel,
                handler: nil))
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default) { _ in
                    if alertTextField.text != nil {
                        self.writeMapModel(mapName: alertTextField.text!)
                }
            }
        )
        self.present(alert, animated: true, completion: nil)
    }
    
    func writeMapModel(mapName:String) {
        self.mapModel.name = mapName
        self.mapModel.removeLayersInAllLayerSet(layers: self.mapView.style!.layers)
        self.mapModel.apllyLayerSettingsForAllLayerSets(layers: self.mapView.style!.layers)
        let archivedData = try! NSKeyedArchiver.archivedData(withRootObject: mapModel!, requiringSecureCoding: false)
        let outputPath = NSHomeDirectory() + "/Documents/maps/" + mapName + ".vgs"
        do {
            try archivedData.write(to: URL(fileURLWithPath: outputPath))
        } catch {
            self.showDialog(title:"Failure", message:"Error occured!")
            return
        }
        self.showDialog(title:"Success", message:"Writing file has completed!")
    }
    
    private func showDialog(title:String, message:String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert)

        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default,
                handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func showLayer(sender:UIBarButtonItem) {
        let layerVc = LayerViewController()
        layerVc.mapView = self.mapView
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

extension MapViewController:MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        self.initUserLocation()
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MGLMapView, fullyRendered: Bool) {
        self.mapModel.showAllLayer(mapView: mapView)
    }
}


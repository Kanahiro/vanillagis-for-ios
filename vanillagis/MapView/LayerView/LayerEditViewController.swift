//
//  LayerEditViewController.swift
//  vanillagis
//
//  Created by Kanahiro Iguchi on 2019/10/06.
//  Copyright © 2019 Labo288. All rights reserved.
//

import UIKit
import Mapbox
import ColorSlider

class LayerEditViewController: UITableViewController {
    
    //raster
    @IBOutlet weak var tileUrlLabel: UILabel!
    @IBOutlet weak var rasterOpacity: UISlider!
    
    //polygon
    @IBOutlet weak var polygonColorSliderView: UIView!
    private var polygonColor: UIColor!
    @IBOutlet weak var fillOpacity: UISlider!
    
    //polyline
    @IBOutlet weak var lineColorSliderView: UIView!
    private var lineColor: UIColor!
    @IBOutlet weak var lineOpacity: UISlider!
    
    //point
    @IBOutlet weak var pointColorSliderView: UIView!
    private var pointColor: UIColor!
    @IBOutlet weak var pointOpacity: UISlider!
    @IBOutlet weak var heatmapSwitch: UISwitch!
    
    //general
    @IBOutlet weak var deleteButton: UIButton!
    @IBAction func deleteButtonPushed(_ sender: UIButton) {
        self.showDeletionAlert()
    }
    @IBAction func closeButtonPushed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //the properties will have been initialized before instantiate
    //layer is classfied as Point, Polyline, Polygon
    //Point: MGLCircleStyleLayer, MGLHeatmapLayer
    //Polyline: MGLLineStyleLayer
    //Polygon: MGLFillStyleLayer
    //you can get the class of layer by self.layerClass()
    var mapView: MGLMapView!
    var layer: MGLStyleLayer!
    
    func layerClass() -> String {
        return String(describing: type(of: self.layer!))
    }
    
    func layerClass(layer: MGLStyleLayer) -> String {
        return String(describing: type(of: layer))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.applyEdit()
    }

    func initUI() {
        switch self.layerClass() {
        case "MGLRasterStyleLayer":
            let rasterLayer = self.layer! as! MGLRasterStyleLayer
            rasterOpacity.value = rasterLayer.rasterOpacity.expressionValue(with: nil, context: nil) as! Float
            deleteButton.isHidden = true
        case "MGLFillStyleLayer":
            let polygonLayer = self.layer! as! MGLFillStyleLayer
            fillOpacity.value = polygonLayer.fillOpacity.expressionValue(with: nil, context: nil) as! Float
            polygonColor = polygonLayer.fillColor.expressionValue(with: nil, context: nil) as? UIColor
            initColorSlider(container: polygonColorSliderView, color:polygonColor)
        case "MGLLineStyleLayer":
            let polylineLayer = self.layer! as! MGLLineStyleLayer
            lineOpacity.value = polylineLayer.lineOpacity.expressionValue(with: nil, context: nil) as! Float
            lineColor = polylineLayer.lineColor.expressionValue(with: nil, context: nil) as? UIColor
            initColorSlider(container: lineColorSliderView, color:lineColor)
        case "MGLCircleStyleLayer":
            let pointLayer = self.layer! as! MGLCircleStyleLayer
            pointOpacity.value = pointLayer.circleOpacity.expressionValue(with: nil, context: nil) as! Float
            pointColor = pointLayer.circleColor.expressionValue(with: nil, context: nil) as? UIColor
            initColorSlider(container: pointColorSliderView, color:pointColor)
            heatmapSwitch.isOn = false
        case "MGLHeatmapStyleLayer":
            let heatmapLayer = self.layer! as! MGLHeatmapStyleLayer
            pointOpacity.value = heatmapLayer.heatmapOpacity.expressionValue(with: nil, context: nil) as! Float
            heatmapSwitch.isOn = true
        default:
            return
        }
    }
    
    func applyEdit() {
        switch self.layerClass() {
        case "MGLRasterStyleLayer":
            let rasterLayer = self.layer! as! MGLRasterStyleLayer
            rasterLayer.rasterOpacity = NSExpression(forConstantValue: rasterOpacity.value)
        case "MGLFillStyleLayer":
            let polygonLayer = self.layer! as! MGLFillStyleLayer
            polygonLayer.fillOpacity = NSExpression(forConstantValue: fillOpacity.value)
            polygonLayer.fillColor = NSExpression(forConstantValue: polygonColor)
        case "MGLLineStyleLayer":
            let polylineLayer = self.layer! as! MGLLineStyleLayer
            polylineLayer.lineOpacity = NSExpression(forConstantValue: lineOpacity.value)
            polylineLayer.lineColor = NSExpression(forConstantValue: lineColor)
        case "MGLCircleStyleLayer":
            let pointLayer = self.layer! as! MGLCircleStyleLayer
            //opacity
            pointLayer.circleOpacity = NSExpression(forConstantValue: pointOpacity.value)
            pointLayer.circleColor = NSExpression(forConstantValue: pointColor)
            //heatmap mode
            if (heatmapSwitch.isOn) {
                let heatmapLayer = MGLHeatmapStyleLayer(identifier: pointLayer.identifier, source: mapView.style!.source(withIdentifier:pointLayer.sourceIdentifier!)!)
                heatmapLayer.heatmapOpacity = NSExpression(forConstantValue: pointOpacity.value)
                mapView.style!.removeLayer(pointLayer)
                mapView.style!.addLayer(heatmapLayer)
            }
        case "MGLHeatmapStyleLayer":
            let heatmapLayer = self.layer! as! MGLHeatmapStyleLayer
            //opacity
            heatmapLayer.heatmapOpacity = NSExpression(forConstantValue: pointOpacity.value)
            //heatmap mode
            if (!heatmapSwitch.isOn) {
                let pointLayer = MGLCircleStyleLayer(identifier: heatmapLayer.identifier, source: mapView.style!.source(withIdentifier:heatmapLayer.sourceIdentifier!)!)
                pointLayer.circleStrokeWidth = NSExpression(forConstantValue: 0.2)
                pointLayer.circleStrokeColor = NSExpression(forConstantValue: UIColor(red: 1, green: 1, blue: 1, alpha: 1))
                pointLayer.circleOpacity = NSExpression(forConstantValue: pointOpacity.value)
                mapView.style!.removeLayer(heatmapLayer)
                mapView.style!.addLayer(pointLayer)
            }
        default:
            return
        }
    }
    
    func initColorSlider(container:UIView, color:UIColor) {
        let previewView = DefaultPreviewView()
        previewView.side = .top
        previewView.animationDuration = 0.2
        previewView.offsetAmount = 0
        
        let colorSlider = ColorSlider(orientation: .horizontal, previewView: previewView)
        colorSlider.frame = container.bounds
        colorSlider.color = color
        
        colorSlider.addTarget(self, action: #selector(changePolygonColor(sender:)), for: .valueChanged)
        container.addSubview(colorSlider)
    }
    
    @objc func changePolygonColor(sender:ColorSlider) {
        switch self.layerClass() {
        case "MGLFillStyleLayer":
            self.polygonColor = sender.color
        case "MGLLineStyleLayer":
            self.lineColor = sender.color
        case "MGLCircleStyleLayer":
            self.pointColor = sender.color
        default:
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch self.layerClass() {
        case "MGLRasterStyleLayer":
            if ( section == 0 ) { return super.tableView(tableView, heightForHeaderInSection: section) }
        case "MGLFillStyleLayer":
            if ( section == 1 ) { return super.tableView(tableView, heightForHeaderInSection: section) }
        case "MGLLineStyleLayer":
            if ( section == 2 ) { return super.tableView(tableView, heightForHeaderInSection: section) }
        case "MGLCircleStyleLayer", "MGLHeatmapStyleLayer":
            if ( section == 3 ) { return super.tableView(tableView, heightForHeaderInSection: section) }
        default:
            break
        }
        //general
        if (section == 4 ) { return super.tableView(tableView, heightForHeaderInSection: section) }
        
        return CGFloat.leastNonzeroMagnitude
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch self.layerClass() {
        case "MGLRasterStyleLayer":
            if ( section == 0 ) { return super.tableView(tableView, titleForHeaderInSection: section) }
        case "MGLFillStyleLayer":
            if ( section == 1 ) { return super.tableView(tableView, titleForHeaderInSection: section) }
        case "MGLLineStyleLayer":
            if ( section == 2 ) { return super.tableView(tableView, titleForHeaderInSection: section) }
        case "MGLCircleStyleLayer", "MGLHeatmapStyleLayer":
            if ( section == 3 ) { return super.tableView(tableView, titleForHeaderInSection: section) }
        default:
            break
        }
        //general
        if (section == 4 ) { return super.tableView(tableView, titleForHeaderInSection: section) }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.layerClass() {
        case "MGLRasterStyleLayer":
            if ( section == 0 ) { return super.tableView(tableView, numberOfRowsInSection: section) }
        case "MGLFillStyleLayer":
            if ( section == 1 ) { return super.tableView(tableView, numberOfRowsInSection: section) }
        case "MGLLineStyleLayer":
            if ( section == 2 ) { return super.tableView(tableView, numberOfRowsInSection: section) }
        case "MGLCircleStyleLayer", "MGLHeatmapStyleLayer":
            if ( section == 3 ) { return super.tableView(tableView, numberOfRowsInSection: section) }
        default:
            break
        }
        //general
        if (section == 4 ) { return super.tableView(tableView, numberOfRowsInSection: section) }
        
        return 0
    }
    
    private func showDeletionAlert() {
        let alert = UIAlertController(
            title: "Caution",
            message: "Confirm before deletion.",
            preferredStyle: UIAlertController.Style.alert)
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: UIAlertAction.Style.cancel,
                handler: nil))
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default) { _ in
                    self.mapView.style!.removeLayer(self.layer)
                    self.mapView.style!.removeSource(self.mapView.style!.source(withIdentifier: self.layer.identifier)!)
                    let superVC = self.presentingViewController as! LayerViewController
                    superVC.updateTableView()
                    self.dismiss(animated: true, completion: nil)
            }
        )
        self.present(alert, animated: true, completion: nil)
    }
}

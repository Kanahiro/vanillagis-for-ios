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
    @IBOutlet weak var lineOpacity: UISlider!
    
    //point
    @IBOutlet weak var pointOpacity: UISlider!
    @IBOutlet weak var heatmapSwitch: UISwitch!
    
    
    
    @IBAction func closeButtonPushed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var mapView: MGLMapView!
    var layer: MGLStyleLayer!
    
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
        case "MGLFillStyleLayer":
            let polygonLayer = self.layer! as! MGLFillStyleLayer
            fillOpacity.value = polygonLayer.fillOpacity.expressionValue(with: nil, context: nil) as! Float
            polygonColor = polygonLayer.fillColor.expressionValue(with: nil, context: nil) as? UIColor
            initColorSlider(container: polygonColorSliderView)
        case "MGLLineStyleLayer":
            let polylineLayer = self.layer! as! MGLLineStyleLayer
            lineOpacity.value = polylineLayer.lineOpacity.expressionValue(with: nil, context: nil) as! Float
        case "MGLCircleStyleLayer":
            let pointLayer = self.layer! as! MGLCircleStyleLayer
            pointOpacity.value = pointLayer.circleOpacity.expressionValue(with: nil, context: nil) as! Float
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
        case "MGLCircleStyleLayer":
            let pointLayer = self.layer! as! MGLCircleStyleLayer
            //opacity
            pointLayer.circleOpacity = NSExpression(forConstantValue: pointOpacity.value)
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
                pointLayer.circleOpacity = NSExpression(forConstantValue: pointOpacity.value)
                mapView.style!.removeLayer(heatmapLayer)
                mapView.style!.addLayer(pointLayer)
            }
        default:
            return
        }
        
    }
    //color silider
    func initColorSlider(container:UIView) {
        let previewView = DefaultPreviewView()
        previewView.side = .top
        previewView.animationDuration = 0.2
        previewView.offsetAmount = 0
        
        let colorSlider = ColorSlider(orientation: .horizontal, previewView: previewView)
        colorSlider.frame = self.polygonColorSliderView.bounds
        colorSlider.color = self.polygonColor
        colorSlider.addTarget(self, action: #selector(changePolygonColor(sender:)), for: .valueChanged)
        container.addSubview(colorSlider)
    }
    
    @objc func changePolygonColor(sender:ColorSlider) {
        switch self.layerClass() {
        case "MGLFillStyleLayer":
            self.polygonColor = sender.color
        default:
            return
        }
    }
    
    func layerClass() -> String {
        return String(describing: type(of: self.layer!))
    }
    
    func layerClass(layer: MGLStyleLayer) -> String {
        return String(describing: type(of: layer))
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if ( section == 0 ) {
            if (self.layerClass() == "MGLRasterStyleLayer" ) { return super.tableView(tableView, heightForHeaderInSection: section) }
        }
        
        if ( section == 1 ) {
            if (self.layerClass() == "MGLFillStyleLayer" ) { return super.tableView(tableView, heightForHeaderInSection: section) }
        }
        
        if ( section == 2 ) {
            if (self.layerClass() == "MGLLineStyleLayer" ) { return super.tableView(tableView, heightForHeaderInSection: section) }
        }
        
        if ( section == 3 ) {
            if (self.layerClass() == "MGLCircleStyleLayer" ) { return super.tableView(tableView, heightForHeaderInSection: section) }
            if (self.layerClass() == "MGLHeatmapStyleLayer" ) { return super.tableView(tableView, heightForHeaderInSection: section) }
        }
        
        return CGFloat.leastNonzeroMagnitude
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if ( section == 0 ) {
            if (self.layerClass() == "MGLRasterStyleLayer" ) { return super.tableView(tableView, titleForHeaderInSection: section) }
        }
        
        if ( section == 1 ) {
            if (self.layerClass() == "MGLFillStyleLayer" ) { return super.tableView(tableView, titleForHeaderInSection: section) }
        }
        
        if ( section == 2 ) {
            if (self.layerClass() == "MGLLineStyleLayer" ) { return super.tableView(tableView, titleForHeaderInSection: section) }
        }
        
        if ( section == 3 ) {
            if (self.layerClass() == "MGLCircleStyleLayer" ) { return super.tableView(tableView, titleForHeaderInSection: section) }
            if (self.layerClass() == "MGLHeatmapStyleLayer" ) { return super.tableView(tableView, titleForHeaderInSection: section) }
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ( section == 0 ) {
            if (self.layerClass() == "MGLRasterStyleLayer" ) { return super.tableView(tableView, numberOfRowsInSection: section) }
        }
        
        if ( section == 1 ) {
            if (self.layerClass() == "MGLFillStyleLayer" ) { return super.tableView(tableView, numberOfRowsInSection: section) }
        }
        
        if ( section == 2 ) {
            if (self.layerClass() == "MGLLineStyleLayer" ) { return super.tableView(tableView, numberOfRowsInSection: section) }
        }
        
        if ( section == 3 ) {
            if (self.layerClass() == "MGLCircleStyleLayer" ) { return super.tableView(tableView, numberOfRowsInSection: section) }
            if (self.layerClass() == "MGLHeatmapStyleLayer" ) { return super.tableView(tableView, numberOfRowsInSection: section) }
        }
        
        return 0
    }
    
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row != 0) { return }
        var alertTextField: UITextField?

        let alert = UIAlertController(
            title: "Raster",
            message: "Enter XYZ tile URL",
            preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(
            configurationHandler: {(textField: UITextField!) in
                alertTextField = textField
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
                if let text = alertTextField?.text {
                    self.tileUrlLabel.text = text
                    //TODO URL VALIDATION
                }
            }
        )

        self.present(alert, animated: true, completion: nil)
    }
    */
    
    /*
    // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

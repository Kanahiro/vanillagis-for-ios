//
//  LayerViewController.swift
//  vanillagis
//
//  Created by Kanahiro Iguchi on 2019/10/03.
//  Copyright © 2019 Labo288. All rights reserved.
//
import Foundation
import UIKit
import Mapbox

class LayerViewController:UIViewController {
    var mapView: MGLMapView!
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initTableView()
        self.initToolbar()
    }
    
    func initTableView() {
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 44), style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.rowHeight = 60
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //custom cell
        let nib = UINib(nibName: "LayerViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "layerViewCell")
        
        //並び替え
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
        
        self.view.addSubview(tableView)
    }
    
    func updateTableView() {
        self.tableView.reloadData()
    }
    
    func layerType(layer:MGLStyleLayer) -> String {
        let layerClass = String(describing: type(of: layer))
        switch layerClass {
        case "MGLRasterStyleLayer":
            return "Raster"
        case "MGLCircleStyleLayer", "MGLHeatmapStyleLayer":
            return "Point"
        case "MGLLineStyleLayer":
            return "Polyline"
        case "MGLFillStyleLayer":
            return "Polygon"
        default:
            return layerClass
        }
    }
    
    func initToolbar() {
        var myToolbar: UIToolbar!
        myToolbar = UIToolbar(frame: CGRect(x: 0, y: self.view.bounds.size.height - 44, width: self.view.bounds.size.width, height: 44.0))
        myToolbar.isTranslucent = false
        let barCancelButton: UIBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.closeButtonCilick(sender:)))
        barCancelButton.tag = 1
        
        myToolbar.items = [barCancelButton]
        
        self.view.addSubview(myToolbar)
    }
    
    @objc func closeButtonCilick(sender:UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LayerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapView.style!.layers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "layerViewCell") as! LayerViewCell
        let layer = mapView.style!.layers[indexPath.row]
        
        //init props
        cell.mapView = self.mapView
        cell.selectedLayer = layer
        cell.senderViewController = self
        
        cell.layerNameLabel?.text = layer.identifier
        cell.layerTypeLabel?.text = self.layerType(layer: layer)
        cell.layerSwitch.isOn = layer.isVisible
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let layer = mapView.style!.layers[indexPath.row]
        if (self.layerType(layer: layer) == "MGLSymbolStyleLayer" ) {
            return 0
        }
        return tableView.rowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let layer = mapView.style!.layers[indexPath.row]
        layer.isVisible = !layer.isVisible
        tableView.reloadData()
    }

    //並び替え
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let layer = mapView.style!.layers[indexPath.row]
        if (self.layerType(layer: layer) == "MGLSymbolStyleLayer" ) {
            return false
        }
        return true
    }

    //並び替え処理
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let selectedLayer = mapView.style!.layers[sourceIndexPath.row]
        mapView.style!.removeLayer(selectedLayer)
        //末尾に挿入する場合addLayer
        if (mapView.style!.layers.count == destinationIndexPath.row) {
            mapView.style!.addLayer(selectedLayer)
        } else {
            mapView.style!.insertLayer(selectedLayer, at: UInt(destinationIndexPath.row))
        }
        tableView.reloadData()
    }

    //追加と削除ボタン
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}

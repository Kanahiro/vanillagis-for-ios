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

class LayerViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    var layers: [MGLStyleLayer]!
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return layers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "layerViewCell") as! LayerViewCell
        let layer = layers[layers.count - 1 - indexPath.row]
        cell.layerNameLabel?.text = layer.identifier
        //cell.detailTextLabel?.text = String(describing: type(of: layer))
        cell.layerSwitch.isOn = layer.isVisible
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let layer = layers[layers.count - 1 - indexPath.row]
        layer.isVisible = !layer.isVisible
        tableView.reloadData()
    }
    
    //並び替え
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //並び替え処理
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

    }
    
    //追加と削除ボタン
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
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

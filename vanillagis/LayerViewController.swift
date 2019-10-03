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
        
        self.initHeaderToolbar()
        self.initTableView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return layers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        let layer = layers[layers.count - 1 - indexPath.row]
        cell.textLabel?.text = layer.identifier
        if (layer.isVisible) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let layer = layers[layers.count - 1 - indexPath.row]
        layer.isVisible = !layer.isVisible
        tableView.reloadData()
    }
    
    func initHeaderToolbar() {
        var myToolbar: UIToolbar!
        myToolbar = UIToolbar(frame: CGRect(x: 0, y: self.view.bounds.size.height - 44, width: self.view.bounds.size.width, height: 44.0))
        myToolbar.isTranslucent = false
        let barCancelButton: UIBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.closeButtonCilick(sender:)))
        barCancelButton.tag = 1
        
        myToolbar.items = [barCancelButton]
        
        self.view.addSubview(myToolbar)
    }
    
    func initTableView() {
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 44), style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    @objc func closeButtonCilick(sender:UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
